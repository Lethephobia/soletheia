import 'dart:typed_data';
import 'dart:math';
import 'dart:io';

import 'package:application/application.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/rust.dart';
import 'package:integration_test/integration_test.dart';
import 'package:soletheia/account.dart';

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
      final store = AccountMetadataStore(directory: () async => dir);
      await store.save(AccountMetadata(account, path));
      final saved = (await store.load()).singleWhere(
        (entry) => entry.account.address == account.address,
      );
      expect(saved.account.mnemonicId, account.mnemonicId);
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
