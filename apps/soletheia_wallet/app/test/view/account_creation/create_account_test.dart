import 'dart:async';
import 'dart:typed_data';

import 'package:application/application.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:soletheia/app.dart';
import 'package:soletheia/account.dart';

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

class _MetadataStore extends AccountMetadataStore {
  bool fail = true;

  @override
  Future<void> save(AccountMetadata record) async {
    if (fail) throw StateError('storage unavailable');
  }
}

void main() {
  testWidgets('reopening the creation screen resets its form', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create new account'));
    await tester.pumpAndSettle();
    final toggle = find.byType(SwitchListTile);
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).last, 'abcd');

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create new account'));
    await tester.pumpAndSettle();
    expect(tester.widget<SwitchListTile>(toggle).value, isFalse);
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField).last).controller!.text,
      isEmpty,
    );
  });

  testWidgets(
    'Create passes the options to Rust and retries metadata without creating another key',
    (tester) async {
      final creator = _Creator();
      final store = _MetadataStore();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accountCreatorProvider.overrideWithValue(creator),
            accountMetadataStoreProvider.overrideWithValue(store),
          ],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Create new account'));
      await tester.pumpAndSettle();
      final submit = find.widgetWithText(FilledButton, 'Create account');
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
      creator.response.completeError(StateError('test failure'));
      await tester.pumpAndSettle();
      expect(
        find.text('Could not create the account. Try again.'),
        findsOneWidget,
      );

      final path = find.widgetWithText(TextFormField, 'Derivation path');
      await tester.enterText(path, 'invalid');
      await tester.pump();
      expect(tester.widget<FilledButton>(submit).onPressed, isNull);
      await tester.enterText(path, "m/44/501/7/0");
      await tester.enterText(
        find.widgetWithText(TextFormField, 'BIP-39 passphrase (optional)'),
        ' test ',
      );
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(submit).onPressed, isNull);
      await tester.enterText(
        find.byType(TextFormField).last,
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
        final toggle = tester.widget<SwitchListTile>(
          find.byType(SwitchListTile),
        );
        expect(toggle.onChanged != null, enabled);
        final entropy = tester.widget<TextField>(find.byType(TextField).last);
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
        find.text('Keys saved. Retry saving the account details.'),
        findsOneWidget,
      );
      store.fail = false;
      final retry = find.widgetWithText(FilledButton, 'Retry saving');
      await tester.ensureVisible(retry);
      await tester.tap(retry);
      await tester.pumpAndSettle();
      expect(creator.calls, hasLength(2));
      expect(find.text('Accounts'), findsWidgets);
      expect(find.text('11111111111111111111111111111111'), findsOneWidget);
    },
  );
}
