import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:application/application.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'imports and selects a private key account without derivation metadata',
    (_) async {
      await initializeRust();
      final directory = await Directory.systemTemp.createTemp(
        'private-key-import',
      );
      addTearDown(() => directory.delete(recursive: true));
      final database = WalletDatabase(directory: directory);
      addTearDown(database.close);
      final repository = SqliteAccountRepository(database);
      final factory = SqliteUnitOfWorkFactory(database);
      final importer = DefaultPrivateKeyAccountImporter(
        const RustPrivateKeyAccountKeyImporter(),
        repository,
        factory,
      );
      await expectLater(
        importer.import(privateKey: 'invalid'),
        throwsA(const PrivateKeyAccountKeyImporterError.invalidPrivateKey()),
      );
      expect(await repository.watchAll().first, isEmpty);

      // RFC 8032 section 7.1, test vector 1.
      const hex =
          '9d61b19deffd5a60ba844af492ec2cc44449c5697b326919703bac031cae7f60'
          'd75a980182b10ab7d54bfed3c964073a0ee172f3daa62325af021a68f707511a';
      final bytes = [
        for (var i = 0; i < hex.length; i += 2)
          int.parse(hex.substring(i, i + 2), radix: 16),
      ];
      final input = jsonEncode(bytes);
      final account = await importer.import(privateKey: input);
      addTearDown(
        () => DefaultAccountDeleter(
          const RustAccountKeyDeleter(),
          repository,
          factory,
        ).delete(account.address),
      );
      expect(
        account.address,
        AccountAddress(Uint8List.fromList(bytes.sublist(32))),
      );
      expect(account.mnemonicDerivation, isNull);
      await expectLater(
        importer.import(privateKey: input),
        throwsA(
          const PrivateKeyAccountKeyImporterError.store(
            KeypairStoreError.alreadyExists(),
          ),
        ),
      );
      await importer.retrySave(account);
      expect(await repository.watchAll().first, [account]);
      expect(await repository.watchCurrentAddress().first, account.address);
    },
  );
}
