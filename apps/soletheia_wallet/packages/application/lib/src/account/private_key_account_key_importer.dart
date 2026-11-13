import 'account_address.dart';

abstract interface class PrivateKeyAccountKeyImporter {
  /// Validates and stores a Solana keypair, returning its public address.
  Future<AccountAddress> import({required String privateKey});
}
