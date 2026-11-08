import 'dart:typed_data';

import 'package:infrastructure/infrastructure.dart';
import 'package:infrastructure/src/rust_bridge/application/keypair/derivation_path.dart';
import 'package:infrastructure/src/rust_bridge/application/mnemonic/mnemonic_entropy.dart';
import 'package:test/test.dart';

void main() {
  setUpAll(initializeRust);
  tearDownAll(RustLib.dispose);

  test('the bridge validates inputs using the Rust value objects', () {
    expect(
      () => MnemonicEntropy(bytes: Uint8List(15)),
      throwsA(isA<MnemonicGeneratorError>()),
    );
    expect(
      () => DerivationPath.parse(value: 'invalid'),
      throwsA(isA<KeypairDeriverError>()),
    );
  });
}
