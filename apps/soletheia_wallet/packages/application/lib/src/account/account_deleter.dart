import 'account_address.dart';

abstract interface class AccountDeleter {
  /// Removes the local account and its unshared secrets.
  /// Returns true when no accounts remain.
  Future<bool> delete(AccountAddress address);
}
