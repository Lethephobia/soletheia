import 'dart:typed_data';

import 'package:application/account.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('rejects addresses shorter or longer than 32 bytes', () {
    for (final size in [0, 31, 33]) {
      expect(
        () => AccountAddress(Uint8List(size)),
        throwsA(
          isA<InvalidAccountAddressLengthException>().having(
            (error) => error.actualBytes,
            'actualBytes',
            size,
          ),
        ),
      );
    }
  });

  test('keeps a stable map key based on the address bytes', () {
    final input = Uint8List(32)..[0] = 7;
    final address = AccountAddress(input);
    final accounts = {address: 'account'};
    final same = AccountAddress(Uint8List.fromList(input));

    input[0] = 9;
    expect(address.bytes[0], 7);
    expect(() => address.bytes[0] = 9, throwsUnsupportedError);
    expect(accounts[same], 'account');
    expect(accounts.containsKey(AccountAddress(input)), isFalse);
  });
}
