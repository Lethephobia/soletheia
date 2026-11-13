import 'dart:async';

import 'package:application/unit_of_work.dart';

import 'wallet_database.dart';

final class SqliteUnitOfWorkFactory implements UnitOfWorkFactory {
  const SqliteUnitOfWorkFactory(this._db);

  final WalletDatabase _db;

  @override
  Future<T> run<T>(Future<T> Function(UnitOfWork uow) operation) {
    return _db.transaction(() async {
      final uow = _SqliteUnitOfWork(_db);
      try {
        return await runZoned(
          () => operation(uow),
          zoneValues: {_SqliteUnitOfWork: uow},
        );
      } finally {
        uow.active = false;
      }
    });
  }

  static void check(UnitOfWork uow, WalletDatabase db) {
    if (uow is! _SqliteUnitOfWork ||
        !uow.active ||
        !identical(uow.db, db) ||
        !identical(Zone.current[_SqliteUnitOfWork], uow)) {
      throw StateError(
        'Expected an active transaction for this wallet database.',
      );
    }
  }
}

final class _SqliteUnitOfWork implements UnitOfWork {
  _SqliteUnitOfWork(this.db);

  final WalletDatabase db;
  bool active = true;
}
