import 'package:application/mnemonic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('empty is the same passphrase as an explicit empty string', () {
    const empty = MnemonicPassphrase.empty();
    expect(empty.value, '');
    expect(empty, const MnemonicPassphrase(''));
  });

  test('preserves whitespace and redacts the passphrase from log output', () {
    const passphrase = MnemonicPassphrase(' dev ');
    expect(passphrase.value, ' dev ');
    expect(passphrase, isNot(const MnemonicPassphrase('dev')));
    expect(passphrase.toString(), isNot(contains('dev')));
  });
}
