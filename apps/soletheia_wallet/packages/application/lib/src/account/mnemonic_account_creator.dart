import '../mnemonic/mnemonic_generation_source.dart';
import '../mnemonic/mnemonic_passphrase.dart';
import '../mnemonic/mnemonic_wordlist.dart';
import 'account.dart';
import 'derivation_path.dart';

abstract interface class MnemonicAccountCreator {
  /// Creates the keys, persists the account and selects it.
  Future<Account> create({
    required MnemonicWordlist wordlist,
    required MnemonicGenerationSource source,
    required MnemonicPassphrase passphrase,
    required DerivationPath derivationPath,
  });

  /// Retries persistence after the keys have already been created.
  Future<void> retrySave(Account account);
}
