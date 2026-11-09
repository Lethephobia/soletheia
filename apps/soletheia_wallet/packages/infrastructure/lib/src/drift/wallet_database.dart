import 'dart:convert';
import 'dart:io';

import 'package:application/application.dart';
import 'package:bs58/bs58.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'wallet_database.g.dart';

@DataClassName('AccountRow')
class Accounts extends Table {
  BlobColumn get address => blob()();
  BlobColumn get mnemonicId => blob()();
  TextColumn get derivationPath => text()();

  @override
  Set<Column<Object>> get primaryKey => {address};
}

@DriftDatabase(tables: [Accounts])
class WalletDatabase extends _$WalletDatabase {
  WalletDatabase({Directory? directory})
    : this._(
        directory == null
            ? getApplicationSupportDirectory()
            : Future.value(directory),
      );

  WalletDatabase._(this._directory)
    : super(
        LazyDatabase(() async {
          final root = await _directory;
          return NativeDatabase.createInBackground(
            File.fromUri(root.uri.resolve('wallet.sqlite')),
          );
        }),
      );

  final Future<Directory> _directory;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (migrator) async {
        await transaction(() async {
          await migrator.createAll();
          await _importLegacyAccounts();
        });
      },
    );
  }

  Future<void> _importLegacyAccounts() async {
    final root = await _directory;
    final legacy = Directory.fromUri(root.uri.resolve('accounts/'));
    if (!await legacy.exists()) return;
    await for (final file in legacy.list(followLinks: false)) {
      if (file is! File || !file.path.endsWith('.json')) continue;
      final json =
          jsonDecode(await file.readAsString()) as Map<String, Object?>;
      final address = AccountAddress(base58.decode(json['address'] as String));
      final mnemonicId = MnemonicId(base64Decode(json['mnemonicId'] as String));
      final path = DerivationPath.parse(json['derivationPath'] as String);
      await into(accounts).insertOnConflictUpdate(
        AccountRow(
          address: address.bytes,
          mnemonicId: mnemonicId.bytes,
          derivationPath: path.value,
        ),
      );
    }
  }
}
