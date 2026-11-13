import 'account.dart';

abstract interface class PrivateKeyAccountImporter {
  Future<Account> import({required String privateKey});

  /// Retries metadata persistence after the keypair was saved.
  Future<void> retrySave(Account account);
}
