import 'dart:typed_data';

import 'package:application/application.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:soletheia/app.dart';
import 'package:soletheia/routing.dart';
import 'package:soletheia/view/mnemonic_account_import/mnemonic_phrase_field.dart';

import '../../support/account_test_container.dart';
import '../../support/pump_wallet_widget.dart';

class _Importer implements MnemonicAccountImporter {
  final account = Account(address: AccountAddress(Uint8List(32)));
  final calls = <(String, String, String)>[];
  final retries = <Account>[];

  @override
  Future<Account> import({
    required String phrase,
    required MnemonicPassphrase passphrase,
    required DerivationPath derivationPath,
  }) async {
    calls.add((phrase, passphrase.value, derivationPath.value));
    throw AccountSaveException(account, Exception('storage unavailable'));
  }

  @override
  Future<void> retrySave(Account account) async {
    retries.add(account);
  }
}

void main() {
  testWidgets('commits IME text and edits chips without changing word order', (
    tester,
  ) async {
    final container = await accountTestContainer();
    await tester.pumpWalletWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    await tester.tap(find.text('Import mnemonic'));
    await tester.pumpAndSettle();
    final field = find.byType(MnemonicPhraseField);
    final editor = find.descendant(of: field, matching: find.byType(TextField));
    await tester.showKeyboard(editor);

    const composing = TextEditingValue(
      text: 'あい　',
      selection: TextSelection.collapsed(offset: 3),
      composing: TextRange(start: 0, end: 3),
    );
    tester.testTextInput.updateEditingValue(composing);
    await tester.pump();
    expect(find.byType(InputChip), findsNothing);
    tester.testTextInput.updateEditingValue(
      composing.copyWith(composing: TextRange.empty),
    );
    await tester.pump();
    expect(find.widgetWithText(InputChip, 'あい'), findsOneWidget);

    await tester.enterText(editor, 'two\nthree four');
    await tester.pump();
    expect(
      tester.widget<MnemonicPhraseField>(field).phrase,
      'あい two three four',
    );
    await tester.tap(find.widgetWithText(InputChip, 'two'));
    await tester.pump();
    expect(tester.widget<TextField>(editor).controller!.text, 'two');
    expect(
      find.descendant(
        of: find.widgetWithText(InputChip, 'three'),
        matching: find.text('3.'),
      ),
      findsOneWidget,
    );
    await tester.enterText(editor, 'second ');
    await tester.pump();
    expect(
      tester.widget<MnemonicPhraseField>(field).phrase,
      'あい second three four',
    );
    await tester.enterText(editor, '');
    await tester.pump();
    expect(tester.widget<TextField>(editor).controller!.text, 'second');
    expect(
      tester.widget<MnemonicPhraseField>(field).phrase,
      'あい second three four',
    );

    final lastChip = find.widgetWithText(InputChip, 'four');
    final decorator = find
        .descendant(of: field, matching: find.byType(InputDecorator))
        .first;
    final end = tester.getRect(decorator).right - 2;
    await tester.tapAt(Offset(end, tester.getCenter(lastChip).dy));
    await tester.pump();
    expect(find.widgetWithText(InputChip, 'second'), findsOneWidget);
    expect(tester.widget<TextField>(editor).focusNode!.hasFocus, isTrue);
    tester.testTextInput.enterText('five');
    await tester.pump();
    expect(
      tester.widget<MnemonicPhraseField>(field).phrase,
      'あい second three four five',
    );
  });

  testWidgets('validates the form and retries saving without importing twice', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final importer = _Importer();
    final container = await accountTestContainer(importer: importer);
    await tester.pumpWalletWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    await tester.tap(find.text('Import mnemonic'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Import'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid BIP-39 mnemonic.'), findsOneWidget);
    expect(importer.calls, isEmpty);
    final phraseField = find.descendant(
      of: find.byType(MnemonicPhraseField),
      matching: find.byType(TextField),
    );
    final passphraseField = find.widgetWithText(TextFormField, 'Passphrase');
    const phrase =
        'abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about';
    await tester.enterText(phraseField, phrase);
    await tester.enterText(passphraseField, 'test');
    await tester.tap(find.widgetWithText(TextButton, 'Import'));
    await tester.pumpAndSettle();
    expect(importer.calls, [(phrase, 'test', "m/44'/501'/0'/0'")]);
    expect(find.text(phrase), findsNothing);
    await tester.tap(find.widgetWithText(TextButton, 'Retry saving'));
    await tester.pumpAndSettle();
    expect(importer.calls, hasLength(1));
    expect(importer.retries, [importer.account]);
    expect(container.read(routerProvider).state.uri.path, '/tokens');
  });
}
