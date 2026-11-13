import 'dart:io';
import 'dart:math';

import 'package:application/application.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('imports a mnemonic and selects the persisted account', (
    _,
  ) async {
    await initializeRust();
    final directory = await Directory.systemTemp.createTemp('account-import');
    addTearDown(() => directory.delete(recursive: true));
    final database = WalletDatabase(directory: directory);
    final repository = SqliteAccountRepository(database);
    final factory = SqliteUnitOfWorkFactory(database);
    addTearDown(database.close);
    final importer = DefaultMnemonicAccountImporter(
      const RustMnemonicAccountKeyImporter(),
      repository,
      factory,
    );
    final path = DerivationPath.parse("m/44'/501'/0'/0'");
    // Isolate the Keychain address for each run of the public test vector.
    final random = Random.secure();
    final passphrase = MnemonicPassphrase(
      List.generate(16, (_) => random.nextInt(256)).join('-'),
    );
    Future<Account> importPhrase(String phrase) {
      return importer.import(
        phrase: phrase,
        passphrase: passphrase,
        derivationPath: path,
      );
    }

    final words = List.filled(12, 'abandon');
    await expectLater(
      importPhrase(words.join(' ')),
      throwsA(
        const MnemonicAccountKeyImporterError.mnemonicParsing(
          MnemonicParserError.invalidChecksum(),
        ),
      ),
    );
    expect(await repository.watchAll().first, isEmpty);

    words.last = 'about';
    final account = await importPhrase(words.join(' '));
    addTearDown(
      () => DefaultAccountDeleter(
        const RustAccountKeyDeleter(),
        repository,
        factory,
      ).delete(account.address),
    );
    expect(account.mnemonicDerivation!.derivationPath, path);
    expect(await repository.watchAll().first, [account]);
    expect(await repository.watchCurrentAddress().first, account.address);
    await importer.retrySave(account);
    expect(await repository.watchAll().first, [account]);
  });
}
