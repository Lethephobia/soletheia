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
      const creator = RustAccountCreator();
      final path = DerivationPath.parse("m/44'/501'/0'/0'");
      final random = Random.secure();
      final entropy = Uint8List.fromList(
        List.generate(16, (_) => random.nextInt(256)),
      );
      final source = MnemonicGenerationSource.entropy(MnemonicEntropy(entropy));
      // Each test run derives a different address, then retries that exact address.
      final passphrase = const MnemonicPassphrase('integration test');
      Future<CreatedAccount> create() {
        return creator.create(
          wordlist: MnemonicWordlist.english,
          source: source,
          passphrase: passphrase,
          derivationPath: path,
        );
      }

      final account = await create();
      final dir = await Directory.systemTemp.createTemp('account-test');
      addTearDown(() => dir.delete(recursive: true));
      final store = DriftAccountRepository(directory: dir);
      addTearDown(store.close);
      await store.save(
        Account(
          address: account.address,
          mnemonicId: account.mnemonicId,
          derivationPath: path,
        ),
      );
      final saved = (await store.watchAll().first).singleWhere(
        (entry) => entry.address == account.address,
      );
      expect(saved.mnemonicId, account.mnemonicId);
      expect(saved.derivationPath, path);
      await expectLater(
        create(),
        throwsA(
          const AccountCreatorError.keypairStorage(
            KeypairStoreError.alreadyExists(),
          ),
        ),
      );
    },
  );
}
