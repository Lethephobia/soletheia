import 'dart:typed_data';

import 'package:application/seed_phrase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('accepts exactly the five BIP-39 entropy lengths', () {
    for (var size = 0; size <= 64; size++) {
      final bytes = Uint8List(size);
      if ({16, 20, 24, 28, 32}.contains(size)) {
        expect(SeedPhraseEntropy(bytes).bytes.length, size);
      } else {
        expect(
          () => SeedPhraseEntropy(bytes),
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
      SeedPhraseWordCount.words12: 16,
      SeedPhraseWordCount.words15: 20,
      SeedPhraseWordCount.words18: 24,
      SeedPhraseWordCount.words21: 28,
      SeedPhraseWordCount.words24: 32,
    };
    for (final entry in lengths.entries) {
      for (final size in [...lengths.values, 17]) {
        final bytes = Uint8List(size);
        if (size == entry.value) {
          expect(
            SeedPhraseEntropy.forWordCount(entry.key, bytes),
            SeedPhraseEntropy(bytes),
          );
        } else {
          expect(
            () => SeedPhraseEntropy.forWordCount(entry.key, bytes),
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
    final entropy = SeedPhraseEntropy(bytes);
    final same = SeedPhraseEntropy(bytes);
    bytes[0] = 1;

    expect(entropy.toString(), 'SeedPhraseEntropy(<redacted>)');
    expect(entropy, same);
    expect(entropy.hashCode, same.hashCode);
    expect(entropy, isNot(SeedPhraseEntropy(bytes)));
    expect(() => entropy.bytes[0] = 1, throwsUnsupportedError);
  });
}
