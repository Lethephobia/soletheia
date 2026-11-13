import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:application/application.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'creates an Apple Keychain account and reloads its public metadata',
    (tester) async {
      await initializeRust();
      final dir = await Directory.systemTemp.createTemp('account-test');
      addTearDown(() => dir.delete(recursive: true));
      final database = WalletDatabase(directory: dir);
      final store = SqliteAccountRepository(database);
      final factory = SqliteUnitOfWorkFactory(database);
      addTearDown(database.close);
      final creator = DefaultMnemonicAccountCreator(
        const RustMnemonicAccountKeyCreator(),
        store,
        factory,
      );
      final deleter = DefaultAccountDeleter(
        const RustAccountKeyDeleter(),
        store,
        factory,
      );
      final path = DerivationPath.parse("m/44'/501'/0'/0'");
      final random = Random.secure();
      final entropy = Uint8List.fromList(
        List.generate(16, (_) => random.nextInt(256)),
      );
      final source = MnemonicGenerationSource.entropy(MnemonicEntropy(entropy));
      // Each test run derives a different address, then retries that exact address.
      final passphrase = const MnemonicPassphrase('integration test');
      Future<Account> create() {
        return creator.create(
          wordlist: MnemonicWordlist.english,
          source: source,
          passphrase: passphrase,
          derivationPath: path,
        );
      }

      final account = await create();
      final saved = (await store.watchAll().first).singleWhere(
        (entry) => entry.address == account.address,
      );
      expect(saved, account);
      expect(await store.watchCurrentAddress().first, account.address);
      expect(saved.mnemonicDerivation!.derivationPath, path);
      await expectLater(
        create(),
        throwsA(
          const MnemonicAccountKeyCreatorError.keypairStorage(
            KeypairStoreError.alreadyExists(),
          ),
        ),
      );
      expect(await deleter.delete(account.address), isTrue);
      final recreated = await create();
      expect(recreated.address, account.address);
      expect(await deleter.delete(recreated.address), isTrue);
    },
  );
}
