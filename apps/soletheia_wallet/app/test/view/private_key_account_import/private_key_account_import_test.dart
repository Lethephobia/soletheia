import 'dart:typed_data';

import 'package:application/application.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:soletheia/app.dart';
import 'package:soletheia/routing.dart';

import '../../support/account_test_container.dart';
import '../../support/pump_wallet_widget.dart';

class _Importer implements PrivateKeyAccountImporter {
  final account = Account(address: AccountAddress(Uint8List(32)));
  final calls = <String>[];
  final retries = <Account>[];

  @override
  Future<Account> import({required String privateKey}) async {
    calls.add(privateKey);
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
    final container = await accountTestContainer(privateKeyImporter: importer);
    await tester.pumpWalletWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    await tester.tap(find.text('Import private key'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Import'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid Solana keypair.'), findsOneWidget);
    expect(importer.calls, isEmpty);
    final keyField = find.byType(TextField);
    expect(tester.widget<TextField>(keyField).obscureText, isTrue);
    await tester.enterText(keyField, 'test-keypair');
    await tester.tap(find.widgetWithText(TextButton, 'Import'));
    await tester.pumpAndSettle();
    expect(importer.calls, ['test-keypair']);
    expect(keyField, findsNothing);
    await tester.tap(find.widgetWithText(TextButton, 'Retry saving'));
    await tester.pumpAndSettle();
    expect(importer.calls, hasLength(1));
    expect(importer.retries, [importer.account]);
    expect(container.read(routerProvider).state.uri.path, '/tokens');
  });
}
