import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:application/account.dart';
import 'package:application/mnemonic.dart';
import 'package:infrastructure/rust.dart';
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
      final other = Account(address: AccountAddress(Uint8List(32)..[0] = 1));
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
        await repo.save(other);
        await repo.selectAccount(other.address);
        expect(await repo.watchCurrentAddress().first, other.address);
        await expectLater(
          repo.selectAccount(AccountAddress(Uint8List(32)..[0] = 2)),
          throwsA(isA<AccountNotFoundException>()),
        );
      } finally {
        await stream.cancel();
        await repo.close();
      }
      final reopened = SqliteAccountRepository(directory: root);
      addTearDown(reopened.close);
      expect(await reopened.watchAll().first, [updated, other]);
      expect(await reopened.watchCurrentAddress().first, other.address);
    },
  );

  test(
    'deletes only unshared secrets and can retry after a Keychain failure',
    () async {
      final root = await Directory.systemTemp.createTemp('wallet-delete-test');
      addTearDown(() => root.delete(recursive: true));
      final derivation = MnemonicDerivation(
        mnemonicId: MnemonicId(Uint8List(16)),
        derivationPath: DerivationPath.parse('m/44/501/0/0'),
      );
      final first = Account(
        address: AccountAddress(Uint8List(32)),
        mnemonicDerivation: derivation,
      );
      final second = first.copyWith(
        address: AccountAddress(Uint8List(32)..[0] = 1),
      );
      final repo = SqliteAccountRepository(directory: root);
      final keys = _TestKeys()..fail = true;
      final deleter = RustAccountDeleter(repo, deleteKeys: keys.delete);
      addTearDown(repo.close);
      await repo.save(first);
      await repo.save(second);
      await repo.selectAccount(first.address);
      await expectLater(deleter.delete(first.address), throwsException);
      expect(await repo.watchCurrentAddress().first, first.address);
      keys.fail = false;
      expect(await deleter.delete(first.address), isFalse);
      expect(await repo.watchCurrentAddress().first, second.address);
      expect(await deleter.delete(second.address), isTrue);
      expect(await repo.watchAll().first, isEmpty);
      expect(keys.calls, [
        (first.address, null),
        (first.address, null),
        (second.address, derivation.mnemonicId),
      ]);
    },
  );

  test(
    'upgrades an existing wallet and restores its selected account',
    () async {
      final root = await Directory.systemTemp.createTemp('wallet-upgrade-test');
      addTearDown(() => root.delete(recursive: true));
      final address = AccountAddress(Uint8List(32));
      final db = WalletDatabase(directory: root);
      try {
        await db.customStatement('ALTER TABLE accounts DROP COLUMN is_current');
        await db.customStatement('INSERT INTO accounts (address) VALUES (?)', [
          address.bytes,
        ]);
        await db.customStatement('PRAGMA user_version = 1');
      } finally {
        await db.close();
      }
      final repo = SqliteAccountRepository(directory: root);
      addTearDown(repo.close);
      expect(await repo.watchCurrentAddress().first, address);
      await repo.selectAccount(address);
      expect(await repo.watchAll().first, [Account(address: address)]);
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

class _TestKeys {
  final calls = <(AccountAddress, MnemonicId?)>[];
  var fail = false;

  Future<void> delete(
    AccountAddress address, {
    MnemonicId? unusedMnemonic,
  }) async {
    calls.add((address, unusedMnemonic));
    if (fail) throw Exception('Keychain unavailable');
  }
}
