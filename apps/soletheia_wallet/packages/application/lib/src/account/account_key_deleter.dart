import '../mnemonic/mnemonic_id.dart';
import 'account_address.dart';

abstract interface class AccountKeyDeleter {
  Future<void> delete(AccountAddress address, {MnemonicId? unusedMnemonic});
}
