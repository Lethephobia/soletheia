import 'dart:async';

import 'package:application/unit_of_work.dart';

import '../wallet_database.dart';
import 'sqlite_unit_of_work.dart';

final class SqliteUnitOfWorkFactory implements UnitOfWorkFactory {
  const SqliteUnitOfWorkFactory(this._db);

  static final _zoneKey = Object();

  final WalletDatabase _db;

  @override
  Future<T> run<T>(Future<T> Function(UnitOfWork uow) operation) {
    return _db.transaction(() async {
      final uow = SqliteUnitOfWork(_db);
      try {
        return await runZoned(
          () => operation(uow),
          zoneValues: {_zoneKey: uow},
        );
      } finally {
        uow.close();
      }
    });
  }

  static void check(UnitOfWork uow, WalletDatabase db) {
    if (uow is! SqliteUnitOfWork ||
        !uow.isActive ||
        !identical(uow.db, db) ||
        !identical(Zone.current[_zoneKey], uow)) {
      throw StateError(
        'Expected an active transaction for this wallet database.',
      );
    }
  }
}
