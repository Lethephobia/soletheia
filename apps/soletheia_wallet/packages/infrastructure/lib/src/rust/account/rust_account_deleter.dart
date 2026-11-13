import 'package:application/application.dart';

import '../../rust_bridge/api/account/delete_account.dart' as rust;
import '../../rust_bridge/application/account/account_address.dart' as rust;
import '../../rust_bridge/application/storage/mnemonic_id.dart' as rust;
import '../../rust_bridge/lib.dart' as rust;

final class RustAccountDeleter implements AccountDeleter {
  const RustAccountDeleter(
    this._repository, {
    this._deleteKeys = _deleteInKeychain,
  });
  final AccountRepository _repository;
  final Future<void> Function(AccountAddress, {MnemonicId? unusedMnemonic})
  _deleteKeys;

  @override
  Future<bool> delete(AccountAddress address) {
    return _repository.transaction(() async {
      final result = await _repository.delete(address);
      await _deleteKeys(address, unusedMnemonic: result.unusedMnemonic);
      return result.isEmpty;
    });
  }

  static Future<void> _deleteInKeychain(
    AccountAddress address, {
    MnemonicId? unusedMnemonic,
  }) {
    return rust.deleteAccount(
      address: rust.AccountAddress(value: rust.U8Array32(address.bytes)),
      unusedMnemonic: unusedMnemonic == null
          ? null
          : rust.MnemonicId(value: rust.U8Array16(unusedMnemonic.bytes)),
    );
  }
}
