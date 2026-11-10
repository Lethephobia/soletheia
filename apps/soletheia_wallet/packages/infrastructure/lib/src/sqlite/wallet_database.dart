import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'wallet_database.g.dart';

@DriftDatabase(include: {'account/accounts.drift'})
class WalletDatabase extends _$WalletDatabase {
  WalletDatabase({Directory? directory})
    : super(
        LazyDatabase(() async {
          final root = directory ?? await getApplicationSupportDirectory();
          return NativeDatabase.createInBackground(
            File.fromUri(root.uri.resolve('wallet.sqlite')),
          );
        }),
      );

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) await migrator.addColumn(accounts, accounts.isCurrent);
    },
  );
}
