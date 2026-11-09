import 'dart:io';

import 'package:application/application.dart';
import 'package:drift/drift.dart';

import 'wallet_database.dart';

/// Stores account metadata in the local wallet database.
class DriftAccountRepository implements AccountRepository {
  DriftAccountRepository({Directory? directory})
    : _db = WalletDatabase(directory: directory);

  final WalletDatabase _db;

  @override
  Stream<List<Account>> watchAll() {
    final query = _db.select(_db.accounts)
      ..orderBy([(row) => OrderingTerm.asc(row.address)]);
    return query.map((row) {
      return Account(
        address: AccountAddress(row.address),
        mnemonicId: MnemonicId(row.mnemonicId),
        derivationPath: DerivationPath.parse(row.derivationPath),
      );
    }).watch();
  }

  @override
  Future<void> save(Account account) async {
    await _db
        .into(_db.accounts)
        .insertOnConflictUpdate(
          AccountRow(
            address: account.address.bytes,
            mnemonicId: account.mnemonicId.bytes,
            derivationPath: account.derivationPath.value,
          ),
        );
  }

  Future<void> close() => _db.close();
}
