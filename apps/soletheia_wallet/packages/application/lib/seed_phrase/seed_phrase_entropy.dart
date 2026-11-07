import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'seed_phrase_entropy_exception.dart';
import 'seed_phrase_word_count.dart';

part 'seed_phrase_entropy.freezed.dart';

/// The entropy used to generate a BIP-39 mnemonic.
@Freezed(copyWith: false, toStringOverride: false)
sealed class SeedPhraseEntropy with _$SeedPhraseEntropy {
  factory SeedPhraseEntropy(Uint8List bytes) = _SeedPhraseEntropy;

  factory SeedPhraseEntropy.forWordCount(
    SeedPhraseWordCount wordCount,
    Uint8List bytes,
  ) {
    if (bytes.length != wordCount.entropyBytes) {
      throw InvalidEntropyLengthException(
        bytes.length,
        expectedBytes: wordCount.entropyBytes,
      );
    }
    return SeedPhraseEntropy(bytes);
  }

  SeedPhraseEntropy._(Uint8List bytes) : bytes = _validatedCopy(bytes);

  final Uint8List bytes;

  static Uint8List _validatedCopy(Uint8List bytes) {
    if (!SeedPhraseWordCount.values.any(
      (count) => count.entropyBytes == bytes.length,
    )) {
      throw InvalidEntropyLengthException(bytes.length);
    }
    return Uint8List.fromList(bytes).asUnmodifiableView();
  }

  @override
  String toString() => 'SeedPhraseEntropy(<redacted>)';
}
