import 'dart:async';
import 'dart:typed_data';

import 'package:application/application.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:soletheia/app.dart';

import '../../support/account_test_container.dart';
import '../../support/pump_wallet_widget.dart';

class _Creator implements AccountCreator {
  final calls =
      <
        (
          MnemonicWordlist,
          MnemonicGenerationSource,
          MnemonicPassphrase,
          DerivationPath,
        )
      >[];
  late Completer<CreatedAccount> response;

  @override
  Future<CreatedAccount> create({
    required MnemonicWordlist wordlist,
    required MnemonicGenerationSource source,
    required MnemonicPassphrase passphrase,
    required DerivationPath derivationPath,
  }) {
    calls.add((wordlist, source, passphrase, derivationPath));
    response = Completer<CreatedAccount>();
    return response.future;
  }
}

class _FailingRepository extends TestAccountRepository {
  bool fail = true;
  final attempts = <Account>[];

  @override
  Future<void> save(Account account) async {
    attempts.add(account);
    if (fail) throw Exception('storage unavailable');
    await super.save(account);
  }
}

void main() {
  testWidgets('reopening the creation screen resets its form', (tester) async {
    await tester.pumpWalletWidget(
      UncontrolledProviderScope(
        container: await accountTestContainer(),
        child: const App(),
      ),
    );
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Custom entropy (optional)'),
      'abcd',
    );

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextField>(
            find.widgetWithText(TextField, 'Custom entropy (optional)'),
          )
          .controller!
          .text,
      isEmpty,
    );
  });

  testWidgets(
    'Create passes the options to Rust and retries metadata without creating another key',
    (tester) async {
      final creator = _Creator();
      final store = _FailingRepository();
      await tester.pumpWalletWidget(
        UncontrolledProviderScope(
          container: await accountTestContainer(
            creator: creator,
            repository: store,
          ),
          child: const App(),
        ),
      );
      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();
      final submit = find.widgetWithText(FilledButton, 'Create');
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pump();
      expect(creator.calls.single, (
        MnemonicWordlist.english,
        const MnemonicGenerationSource.random(MnemonicWordCount.words12),
        const MnemonicPassphrase.empty(),
        DerivationPath.parse("m/44'/501'/0'/0'"),
      ));
      expect(tester.widget<FilledButton>(submit).onPressed, isNull);
      creator.response.completeError(Exception('test failure'));
      await tester.pumpAndSettle();
      expect(
        find.widgetWithText(
          SnackBar,
          'Could not create the account. Try again.',
        ),
        findsOneWidget,
      );

      final path = find.widgetWithText(TextFormField, 'Derivation path');
      await tester.enterText(path, 'invalid');
      await tester.pump();
      final invalidPath = find.text('Enter an absolute derivation path.');
      expect(invalidPath, findsNothing);
      expect(tester.widget<FilledButton>(submit).onPressed, isNotNull);
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pump();
      expect(invalidPath, findsOneWidget);
      expect(creator.calls, hasLength(1));
      await tester.enterText(path, "m/44/501/7/0");
      await tester.pump();
      expect(invalidPath, findsNothing);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Passphrase (optional)'),
        ' test ',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Custom entropy (optional)'),
        '0f',
      );
      await tester.pumpAndSettle();
      final invalidEntropy = find.text(
        'Enter exactly 32 hexadecimal characters.',
      );
      expect(invalidEntropy, findsNothing);
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pump();
      expect(invalidEntropy, findsOneWidget);
      expect(creator.calls, hasLength(1));
      final invalidHex = find.text('Use only hexadecimal digits (0–9, A–F).');
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Custom entropy (optional)'),
        '   ',
      );
      await tester.pumpAndSettle();
      expect(invalidEntropy, findsNothing);
      expect(invalidHex, findsNothing);
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pump();
      expect(invalidHex, findsOneWidget);
      expect(invalidEntropy, findsNothing);
      expect(creator.calls, hasLength(1));
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Custom entropy (optional)'),
        '0102030405060708090A0b0c0d0e0f10',
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pump();
      void expectFormEnabled(bool enabled) {
        final menus = tester.widgetList<DropdownMenu<dynamic>>(
          find.byWidgetPredicate((widget) => widget is DropdownMenu<dynamic>),
        );
        expect(menus.map((menu) => menu.enabled), [enabled, enabled]);
        final entropy = tester.widget<TextField>(
          find.widgetWithText(TextField, 'Custom entropy (optional)'),
        );
        expect(entropy.enabled, enabled);
        expect(tester.widget<FilledButton>(submit).onPressed != null, enabled);
      }

      expectFormEnabled(false);
      expect(creator.calls.last.$3.value, ' test ');
      expect(creator.calls.last.$4.value, "m/44'/501'/7'/0'");
      final source = creator.calls.last.$2 as EntropyMnemonicGenerationSource;
      expect(source.entropy.bytes, List.generate(16, (i) => i + 1));
      final created = CreatedAccount(
        address: AccountAddress(Uint8List(32)),
        mnemonicId: MnemonicId(Uint8List(16)),
      );
      creator.response.complete(created);
      await tester.pumpAndSettle();
      expect(
        find.widgetWithText(
          SnackBar,
          'Keys saved. Retry saving the account details.',
        ),
        findsOneWidget,
      );
      store.fail = false;
      final retry = find.widgetWithText(FilledButton, 'Retry saving');
      await tester.ensureVisible(retry);
      await tester.tap(retry);
      await tester.pumpAndSettle();
      expect(creator.calls, hasLength(2));
      expect(store.attempts, hasLength(2));
      expect(store.attempts.last, same(store.attempts.first));
      expect(find.text('Token'), findsWidgets);
      expect(find.widgetWithText(SnackBar, 'Account created.'), findsOneWidget);
    },
  );
}
