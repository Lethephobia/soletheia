import 'package:application/application.dart';

import '../../rust_bridge/api/account/import_mnemonic_account_keys.dart'
    as rust;
import '../../rust_bridge/application/keypair/derivation_path.dart' as rust;
import '../../rust_bridge/application/mnemonic/mnemonic_passphrase.dart'
    as rust;

final class RustMnemonicAccountKeyImporter
    implements MnemonicAccountKeyImporter {
  const RustMnemonicAccountKeyImporter();

  @override
  Future<MnemonicAccount> import({
    required String phrase,
    required MnemonicPassphrase passphrase,
    required DerivationPath derivationPath,
  }) async {
    final keys = await rust.importMnemonicAccountKeys(
      phrase: phrase,
      passphrase: rust.MnemonicPassphrase(value: passphrase.value),
      derivationPath: rust.DerivationPath.parse(value: derivationPath.value),
    );
    return MnemonicAccount(
      address: AccountAddress(keys.address.value.inner),
      mnemonicId: MnemonicId(keys.mnemonicId.value.inner),
    );
  }
}
