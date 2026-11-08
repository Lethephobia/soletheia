import '../mnemonic/mnemonic_generation_source.dart';
import '../mnemonic/mnemonic_passphrase.dart';
import '../mnemonic/mnemonic_wordlist.dart';
import 'created_account.dart';
import 'derivation_path.dart';

abstract interface class AccountCreator {
  /// Returns the address and mnemonic ID after both secrets have been saved.
  Future<CreatedAccount> create({
    required MnemonicWordlist wordlist,
    required MnemonicGenerationSource source,
    required MnemonicPassphrase passphrase,
    required DerivationPath derivationPath,
  });
}
