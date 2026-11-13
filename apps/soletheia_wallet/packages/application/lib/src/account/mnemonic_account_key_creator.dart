import '../mnemonic/mnemonic_generation_source.dart';
import '../mnemonic/mnemonic_passphrase.dart';
import '../mnemonic/mnemonic_wordlist.dart';
import 'derivation_path.dart';
import 'mnemonic_account.dart';

abstract interface class MnemonicAccountKeyCreator {
  Future<MnemonicAccount> create({
    required MnemonicWordlist wordlist,
    required MnemonicGenerationSource source,
    required MnemonicPassphrase passphrase,
    required DerivationPath derivationPath,
  });
}
