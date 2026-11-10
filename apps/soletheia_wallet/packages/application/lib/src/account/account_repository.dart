import 'account.dart';
import 'account_address.dart';

/// Persists the wallet's accounts on this device.
abstract interface class AccountRepository {
  /// Emits the stored accounts on subscription and after changes.
  Stream<List<Account>> watchAll();

  /// Emits the selected address, or null when the wallet has no accounts.
  Stream<AccountAddress?> watchCurrentAddress();

  /// Selects an existing account on this device.
  Future<void> selectAccount(AccountAddress address);

  /// Inserts or updates [account] by its address.
  Future<void> save(Account account);
}
