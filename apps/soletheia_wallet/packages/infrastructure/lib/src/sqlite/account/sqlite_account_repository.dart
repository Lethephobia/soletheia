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
  Future<T> transaction<T>(Future<T> Function() operation) =>
      _db.transaction(operation);

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

  @override
  Future<({MnemonicId? unusedMnemonic, bool isEmpty})> deleteAccount(
    AccountAddress address,
  ) {
    return _db.transaction(() async {
      final removed = await (_db.delete(
        _db.accounts,
      )..where((row) => row.address.equals(address.bytes))).goAndReturn();
      if (removed.isEmpty) throw const AccountNotFoundException();
      final id = removed.single.mnemonicId;
      MnemonicId? unusedMnemonic;
      if (id != null) {
        final shared =
            await (_db.select(_db.accounts)
                  ..where((row) => row.mnemonicId.equals(id))
                  ..limit(1))
                .getSingleOrNull();
        if (shared == null) unusedMnemonic = MnemonicId(id);
      }
      final remaining = await (_db.select(
        _db.accounts,
      )..limit(1)).getSingleOrNull();

      return (unusedMnemonic: unusedMnemonic, isEmpty: remaining == null);
    });
  }

  @override
  Stream<AccountAddress?> watchCurrentAddress() {
    final query = _db.select(_db.accounts)
      ..orderBy([
        (row) => OrderingTerm.desc(row.isCurrent),
        (row) => OrderingTerm.asc(row.address),
      ])
      ..limit(1);
    return query.watchSingleOrNull().map(
      (row) => row == null ? null : AccountAddress(row.address),
    );
  }

  @override
  Future<void> selectAccount(AccountAddress address) {
    return _db.transaction(() async {
      await (_db.update(_db.accounts)..where((row) => row.isCurrent)).write(
        const AccountsCompanion(isCurrent: Value(false)),
      );
      final count =
          await (_db.update(_db.accounts)
                ..where((row) => row.address.equals(address.bytes)))
              .write(const AccountsCompanion(isCurrent: Value(true)));
      if (count == 0) throw const AccountNotFoundException();
    });
  }

  Future<void> close() => _db.close();
}
