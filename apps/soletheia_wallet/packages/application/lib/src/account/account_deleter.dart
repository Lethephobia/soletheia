import 'account_address.dart';

abstract interface class AccountDeleter {
  /// Deletes the account and its unshared keys. Returns true if no accounts remain.
  Future<bool> delete(AccountAddress address);
}
