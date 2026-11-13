import 'package:application/unit_of_work.dart';

import '../wallet_database.dart';

final class SqliteUnitOfWork implements UnitOfWork {
  SqliteUnitOfWork(this.db);

  final WalletDatabase db;
  bool _isActive = true;

  bool get isActive => _isActive;

  void close() {
    _isActive = false;
  }
}
