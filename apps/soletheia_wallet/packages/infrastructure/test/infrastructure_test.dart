import 'dart:typed_data';

import 'package:application/mnemonic.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:test/test.dart';

void main() {
  setUpAll(initializeRust);
  tearDownAll(RustLib.dispose);

  const MnemonicGenerator generator = RustMnemonicGenerator();

  test('generates the Japanese BIP-39 vector from zero entropy', () async {
    final phrase = await generator.generate(
      wordlist: MnemonicWordlist.japanese,
      source: MnemonicGenerationSource.entropy(MnemonicEntropy(Uint8List(16))),
    );
    expect(phrase.words.map((word) => word.value), [
      ...List.filled(11, 'あいこくしん'),
      'あおそ\u3099ら',
    ]);
  });

  test('generates random phrases at every supported word count', () async {
    for (final count in MnemonicWordCount.values) {
      final phrase = await generator.generate(
        wordlist: MnemonicWordlist.english,
        source: MnemonicGenerationSource.random(count),
      );
      expect(phrase.words.length, count.words);
    }
  });
}
