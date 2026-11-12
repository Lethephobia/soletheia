import 'account.dart';

/// The keys exist on this device, so only metadata persistence needs retrying.
final class AccountSaveException implements Exception {
  const AccountSaveException(this.account, this.cause);

  final Account account;
  final Exception cause;
}
