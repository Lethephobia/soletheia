import '../mnemonic/mnemonic_passphrase.dart';
import 'account.dart';
import 'derivation_path.dart';

abstract interface class MnemonicAccountImporter {
  /// Imports the keys, persists the account and selects it.
  Future<Account> import({
    required String phrase,
    required MnemonicPassphrase passphrase,
    required DerivationPath derivationPath,
  });

  /// Retries metadata persistence after the keys were saved.
  Future<void> retrySave(Account account);
}
