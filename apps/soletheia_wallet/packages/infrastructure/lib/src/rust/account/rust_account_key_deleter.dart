import 'package:application/application.dart';

import '../../rust_bridge/api/account/delete_account_keys.dart' as rust;
import '../../rust_bridge/application/account/account_address.dart' as rust;
import '../../rust_bridge/application/storage/mnemonic_id.dart' as rust;
import '../../rust_bridge/lib.dart' as rust;

final class RustAccountKeyDeleter implements AccountKeyDeleter {
  const RustAccountKeyDeleter();

  @override
  Future<void> delete(AccountAddress address, {MnemonicId? unusedMnemonic}) {
    return rust.deleteAccountKeys(
      address: rust.AccountAddress(value: rust.U8Array32(address.bytes)),
      unusedMnemonic: unusedMnemonic == null
          ? null
          : rust.MnemonicId(value: rust.U8Array16(unusedMnemonic.bytes)),
    );
  }
}
