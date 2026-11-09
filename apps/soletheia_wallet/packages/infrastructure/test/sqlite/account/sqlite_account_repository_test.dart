import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:application/account.dart';
import 'package:application/mnemonic.dart';
import 'package:infrastructure/sqlite.dart';
import 'package:infrastructure/src/sqlite/wallet_database.dart';
import 'package:test/test.dart';

void main() {
  test(
    'watches account inserts and updates and persists them across a restart',
    () async {
      final root = await Directory.systemTemp.createTemp('wallet-db-test');
      addTearDown(() => root.delete(recursive: true));
      final derivation = MnemonicDerivation(
        mnemonicId: MnemonicId(Uint8List(16)),
        derivationPath: DerivationPath.parse('m/44/501/0/0'),
      );
      final account = Account(
        address: AccountAddress(Uint8List(32)),
        mnemonicDerivation: derivation,
      );
      final updated = account.copyWith(mnemonicDerivation: null);
      final repo = SqliteAccountRepository(directory: root);
      final stream = StreamIterator(repo.watchAll());
      try {
        expect(await stream.moveNext(), isTrue);
        expect(stream.current, isEmpty);
        await repo.save(account);
        expect(await stream.moveNext(), isTrue);
        expect(stream.current, [account]);
        await repo.save(updated);
        expect(await stream.moveNext(), isTrue);
        expect(stream.current, [updated]);
      } finally {
        await stream.cancel();
        await repo.close();
      }
      final reopened = SqliteAccountRepository(directory: root);
      addTearDown(reopened.close);
      expect(await reopened.watchAll().first, [updated]);
    },
  );

  test(
    'the initial schema rejects an incomplete mnemonic derivation',
    () async {
      final root = await Directory.systemTemp.createTemp('wallet-db-test');
      addTearDown(() => root.delete(recursive: true));
      final db = WalletDatabase(directory: root);
      addTearDown(db.close);
      for (final values in [
        [Uint8List(16), null],
        [null, 'm/44/501/0/0'],
      ]) {
        await expectLater(
          db.customStatement(
            'INSERT INTO accounts (address, mnemonic_id, derivation_path) VALUES (?, ?, ?)',
            [Uint8List(32), ...values],
          ),
          throwsA(
            predicate((e) => e.toString().contains('CHECK constraint failed')),
          ),
        );
      }
    },
  );
}
