import 'package:application/account.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BIP-44 includes the change index unless it is null', () {
    expect(
      DerivationPath.bip44(account: Bip44AccountIndex(0), change: null).value,
      "m/44'/501'/0'",
    );
    expect(
      DerivationPath.bip44(
        account: Bip44AccountIndex(0),
        change: Bip44ChangeIndex(0),
      ).value,
      "m/44'/501'/0'/0'",
    );
    expect(
      DerivationPath.bip44(
        account: Bip44AccountIndex(2),
        change: Bip44ChangeIndex(3),
      ).value,
      "m/44'/501'/2'/3'",
    );
  });

  test('account and change indexes accept the full hardened index range', () {
    for (final value in [0, 0x7fffffff]) {
      expect(Bip44AccountIndex(value).value, value);
      expect(Bip44ChangeIndex(value).value, value);
    }
    for (final value in [-1, 0x80000000]) {
      final invalid = throwsA(isA<InvalidDerivationPathException>());
      expect(() => Bip44AccountIndex(value), invalid);
      expect(() => Bip44ChangeIndex(value), invalid);
    }
  });

  test('absolute paths normalize to explicit hardened indexes', () {
    expect(DerivationPath.parse('m').value, 'm');
    expect(
      DerivationPath.parse('m/44/501/0/0'),
      DerivationPath.parse("m/44'/501'/0'/0'"),
    );
    expect(DerivationPath.parse("m/2147483647'").value, "m/2147483647'");
  });

  test(
    'rejects relative paths, malformed components and oversized indexes',
    () {
      for (final path in [
        '',
        '0/0',
        'm/',
        'm//1',
        'm/-1',
        "m/1''",
        'm/2147483648',
      ]) {
        expect(
          () => DerivationPath.parse(path),
          throwsA(isA<InvalidDerivationPathException>()),
          reason: path,
        );
      }
    },
  );
}
