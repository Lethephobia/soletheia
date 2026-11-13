import 'dart:async';
import 'dart:typed_data';

import 'package:application/application.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:soletheia/app.dart';

import '../../support/account_test_container.dart';
import '../../support/pump_wallet_widget.dart';

class _TestKeys implements MnemonicAccountKeyCreator {
  final calls =
      <
        (
          MnemonicWordlist,
          MnemonicGenerationSource,
          MnemonicPassphrase,
          DerivationPath,
        )
      >[];
  late Completer<MnemonicAccount> response;

  @override
  Future<MnemonicAccount> create({
    required MnemonicWordlist wordlist,
    required MnemonicGenerationSource source,
    required MnemonicPassphrase passphrase,
    required DerivationPath derivationPath,
  }) {
    calls.add((wordlist, source, passphrase, derivationPath));
    response = Completer<MnemonicAccount>();
    return response.future;
  }
}

class _FailingRepository extends TestAccountRepository {
  bool fail = true;
  final attempts = <Account>[];

  @override
  Future<void> save(UnitOfWork uow, Account account) async {
    attempts.add(account);
    if (fail) throw Exception('storage unavailable');
    await super.save(uow, account);
  }
}

void main() {
  testWidgets('reopening the creation screen resets its form', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWalletWidget(
      UncontrolledProviderScope(
        container: await accountTestContainer(),
        child: const App(),
      ),
    );
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Custom entropy'),
      'abcd',
    );

    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextField>(find.widgetWithText(TextField, 'Custom entropy'))
          .controller!
          .text,
      isEmpty,
    );
  });

  testWidgets(
    'Create passes the options to Rust and retries metadata without creating another key',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(390, 844);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      final keys = _TestKeys();
      final store = _FailingRepository();
      await tester.pumpWalletWidget(
        UncontrolledProviderScope(
          container: await accountTestContainer(
            creator: DefaultMnemonicAccountCreator(
              keys,
              store,
              const TestUnitOfWorkFactory(),
            ),
            repository: store,
          ),
          child: const App(),
        ),
      );
      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();
      final submit = find.widgetWithText(TextButton, 'Create');
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pump();
      expect(keys.calls.single, (
        MnemonicWordlist.english,
        const MnemonicGenerationSource.random(MnemonicWordCount.words12),
        const MnemonicPassphrase.empty(),
        DerivationPath.parse("m/44'/501'/0'/0'"),
      ));
      expect(tester.widget<TextButton>(submit).onPressed, isNull);
      tester.view.physicalSize = const Size(1280, 800);
      await tester.pump();
      await tester.tapAt(const Offset(8, 8));
      await tester.pump();
      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(submit, findsOneWidget);
      tester.view.physicalSize = const Size(390, 844);
      await tester.pump();
      keys.response.completeError(Exception('test failure'));
      await tester.pumpAndSettle();
      expect(
        find.widgetWithText(
          SnackBar,
          'Could not create the account. Try again.',
        ),
        findsOneWidget,
      );

      final path = find.widgetWithText(TextFormField, 'Derivation path*');
      await tester.ensureVisible(path);
      await tester.tap(path);
      await tester.pumpAndSettle();
      expect(find.text("m/44'/501'/1'/0'"), findsOneWidget);
      expect(find.text("m/44'/501'/2'/0'"), findsOneWidget);
      await tester.enterText(path, 'm/44/501/2');
      await tester.pumpAndSettle();
      expect(find.text("m/44'/501'/1'/0'"), findsNothing);
      const suggestedPath = "m/44'/501'/2'/0'";
      await tester.tap(find.text(suggestedPath));
      await tester.pumpAndSettle();
      final input = tester.widget<TextField>(
        find.descendant(of: path, matching: find.byType(TextField)),
      );
      expect(input.controller!.text, suggestedPath);
      await tester.enterText(path, 'invalid');
      await tester.pump();
      final invalidPath = find.text('Enter an absolute derivation path.');
      expect(invalidPath, findsNothing);
      expect(tester.widget<TextButton>(submit).onPressed, isNotNull);
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pump();
      expect(invalidPath, findsOneWidget);
      expect(keys.calls, hasLength(1));
      await tester.enterText(path, "m/44/501/7/0");
      await tester.pump();
      expect(invalidPath, findsNothing);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Passphrase'),
        ' test ',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Custom entropy'),
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
      expect(keys.calls, hasLength(1));
      final invalidHex = find.text('Use only hexadecimal digits (0–9, A–F).');
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Custom entropy'),
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
      expect(keys.calls, hasLength(1));
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Custom entropy'),
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
          find.widgetWithText(TextField, 'Custom entropy'),
        );
        expect(entropy.enabled, enabled);
        expect(tester.widget<TextButton>(submit).onPressed != null, enabled);
      }

      expectFormEnabled(false);
      expect(keys.calls.last.$3.value, ' test ');
      expect(keys.calls.last.$4.value, "m/44'/501'/7'/0'");
      final source = keys.calls.last.$2 as EntropyMnemonicGenerationSource;
      expect(source.entropy.bytes, List.generate(16, (i) => i + 1));
      final created = MnemonicAccount(
        address: AccountAddress(Uint8List(32)),
        mnemonicId: MnemonicId(Uint8List(16)),
      );
      keys.response.complete(created);
      await tester.pumpAndSettle();
      expect(
        find.widgetWithText(
          SnackBar,
          'Keys saved. Retry saving the account details.',
        ),
        findsOneWidget,
      );
      store.fail = false;
      tester.view.physicalSize = const Size(1280, 800);
      await tester.pumpAndSettle();
      final retry = find.widgetWithText(TextButton, 'Retry saving');
      await tester.tapAt(const Offset(8, 8));
      await tester.pumpAndSettle();
      tester.view.physicalSize = const Size(390, 844);
      await tester.pumpAndSettle();
      await tester.ensureVisible(retry);
      await tester.tap(retry);
      await tester.pumpAndSettle();
      expect(keys.calls, hasLength(2));
      expect(store.attempts, hasLength(2));
      expect(store.attempts.last, same(store.attempts.first));
      expect(find.text('Token'), findsWidgets);
      expect(find.widgetWithText(SnackBar, 'Account created.'), findsOneWidget);
    },
  );
}
