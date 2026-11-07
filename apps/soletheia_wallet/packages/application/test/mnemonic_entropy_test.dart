import 'dart:typed_data';

import 'package:application/mnemonic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('accepts exactly the five BIP-39 entropy lengths', () {
    for (var size = 0; size <= 64; size++) {
      final bytes = Uint8List(size);
      if ({16, 20, 24, 28, 32}.contains(size)) {
        expect(MnemonicEntropy(bytes).bytes.length, size);
      } else {
        expect(
          () => MnemonicEntropy(bytes),
          throwsA(
            isA<InvalidEntropyLengthException>().having(
              (error) => error.actualBytes,
              'actualBytes',
              size,
            ),
          ),
        );
      }
    }
  });

  test('requires the entropy length for the selected word count', () {
    const lengths = {
      MnemonicWordCount.words12: 16,
      MnemonicWordCount.words15: 20,
      MnemonicWordCount.words18: 24,
      MnemonicWordCount.words21: 28,
      MnemonicWordCount.words24: 32,
    };
    for (final entry in lengths.entries) {
      for (final size in [...lengths.values, 17]) {
        final bytes = Uint8List(size);
        if (size == entry.value) {
          expect(
            MnemonicEntropy.forWordCount(entry.key, bytes),
            MnemonicEntropy(bytes),
          );
        } else {
          expect(
            () => MnemonicEntropy.forWordCount(entry.key, bytes),
            throwsA(
              isA<InvalidEntropyLengthException>()
                  .having((e) => e.actualBytes, 'actualBytes', size)
                  .having((e) => e.expectedBytes, 'expectedBytes', entry.value),
            ),
          );
        }
      }
    }
  });

  test('preserves value equality when the input buffer changes', () {
    final bytes = Uint8List(16);
    final entropy = MnemonicEntropy(bytes);
    final same = MnemonicEntropy(bytes);
    bytes[0] = 1;

    expect(entropy.toString(), 'MnemonicEntropy(<redacted>)');
    expect(entropy, same);
    expect(entropy.hashCode, same.hashCode);
    expect(entropy, isNot(MnemonicEntropy(bytes)));
    expect(() => entropy.bytes[0] = 1, throwsUnsupportedError);
  });
}
