import 'dart:io';

import 'package:application/application.dart';
import 'package:drift/drift.dart';

import '../wallet_database.dart';

/// Stores account metadata in the local wallet database.
class SqliteAccountRepository implements AccountRepository {
  SqliteAccountRepository({Directory? directory})
    : _db = WalletDatabase(directory: directory);

  final WalletDatabase _db;

  @override
  Stream<List<Account>> watchAll() {
    final query = _db.select(_db.accounts)
      ..orderBy([(row) => OrderingTerm.asc(row.address)]);
    return query.map((row) {
      return Account(
        address: AccountAddress(row.address),
        mnemonicDerivation: row.mnemonicId == null
            ? null
            : MnemonicDerivation(
                mnemonicId: MnemonicId(row.mnemonicId!),
                derivationPath: DerivationPath.parse(row.derivationPath!),
              ),
      );
    }).watch();
  }

  @override
  Future<void> save(Account account) async {
    await _db
        .into(_db.accounts)
        .insertOnConflictUpdate(
          AccountsCompanion.insert(
            address: account.address.bytes,
            mnemonicId: Value(account.mnemonicDerivation?.mnemonicId.bytes),
            derivationPath: Value(
              account.mnemonicDerivation?.derivationPath.value,
            ),
          ),
        );
  }

  Future<void> close() => _db.close();
}
