import 'account.dart';

/// Persists the wallet's accounts on this device.
abstract interface class AccountRepository {
  /// Emits the stored accounts on subscription and after changes.
  Stream<List<Account>> watchAll();

  /// Inserts or updates [account] by its address.
  Future<void> save(Account account);
}
