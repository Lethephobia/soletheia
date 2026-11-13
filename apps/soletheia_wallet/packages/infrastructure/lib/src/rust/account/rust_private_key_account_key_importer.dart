import 'package:application/application.dart';

import '../../rust_bridge/api/account/import_private_key_account_keys.dart'
    as rust;

final class RustPrivateKeyAccountKeyImporter
    implements PrivateKeyAccountKeyImporter {
  const RustPrivateKeyAccountKeyImporter();

  @override
  Future<AccountAddress> import({required String privateKey}) async {
    final address = await rust.importPrivateKeyAccountKeys(
      privateKey: privateKey,
    );
    return AccountAddress(address.value.inner);
  }
}
