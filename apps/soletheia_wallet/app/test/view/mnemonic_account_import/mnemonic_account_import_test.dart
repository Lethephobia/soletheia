import 'dart:typed_data';

import 'package:application/application.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:soletheia/app.dart';
import 'package:soletheia/routing.dart';

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
    final phraseField = find.widgetWithText(TextFormField, 'Mnemonic*');
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
