import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:application/account.dart';
import 'package:application/mnemonic.dart';
import 'package:bs58/bs58.dart';
import 'package:infrastructure/drift.dart';
import 'package:test/test.dart';

void main() {
  test(
    'imports legacy accounts once and watches upserts across a restart',
    () async {
      final root = await Directory.systemTemp.createTemp('wallet-db-test');
      addTearDown(() => root.delete(recursive: true));
      final legacy = await Directory.fromUri(root.uri.resolve('accounts/'))
          .create();
      final account = Account(
        address: AccountAddress(Uint8List(32)),
        mnemonicId: MnemonicId(Uint8List(16)),
        derivationPath: DerivationPath.parse('m/44/501/0/0'),
      );
      final address = base58.encode(account.address.bytes);
      await File.fromUri(legacy.uri.resolve('$address.json')).writeAsString(
        jsonEncode({
          'address': address,
          'mnemonicId': base64Encode(account.mnemonicId.bytes),
          'derivationPath': account.derivationPath.value,
        }),
      );
      final updated = account.copyWith(
        derivationPath: DerivationPath.parse('m/44/501/1/0'),
      );
      final repo = DriftAccountRepository(directory: root);
      final stream = StreamIterator(repo.watchAll());
      try {
        expect(await stream.moveNext(), isTrue);
        expect(stream.current, [account]);
        await repo.save(updated);
        expect(await stream.moveNext(), isTrue);
        expect(stream.current, [updated]);
      } finally {
        await stream.cancel();
        await repo.close();
      }
      final reopened = DriftAccountRepository(directory: root);
      addTearDown(reopened.close);
      expect(await reopened.watchAll().first, [updated]);
    },
  );

  test(
    'a failed JSON import can be retried after repairing the file',
    () async {
      final root = await Directory.systemTemp.createTemp('wallet-db-test');
      addTearDown(() => root.delete(recursive: true));
      final legacy = await Directory.fromUri(root.uri.resolve('accounts/'))
          .create();
      final address = AccountAddress(Uint8List(32));
      final encodedAddress = base58.encode(address.bytes);
      final file = File.fromUri(legacy.uri.resolve('$encodedAddress.json'));
      await file.writeAsString('{');
      final first = DriftAccountRepository(directory: root);
      try {
        await expectLater(
          first.watchAll().first,
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'cause',
              contains('FormatException'),
            ),
          ),
        );
      } finally {
        await first.close();
      }
      final id = MnemonicId(Uint8List(16));
      final path = DerivationPath.parse('m/44/501/0/0');
      await file.writeAsString(
        jsonEncode({
          'address': encodedAddress,
          'mnemonicId': base64Encode(id.bytes),
          'derivationPath': path.value,
        }),
      );
      final repaired = DriftAccountRepository(directory: root);
      addTearDown(repaired.close);
      expect(await repaired.watchAll().first, [
        Account(address: address, mnemonicId: id, derivationPath: path),
      ]);
    },
  );
}
