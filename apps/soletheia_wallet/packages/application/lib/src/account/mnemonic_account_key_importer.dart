import '../mnemonic/mnemonic_passphrase.dart';
import 'derivation_path.dart';
import 'mnemonic_account.dart';

abstract interface class MnemonicAccountKeyImporter {
  Future<MnemonicAccount> import({
    required String phrase,
    required MnemonicPassphrase passphrase,
    required DerivationPath derivationPath,
  });
}
