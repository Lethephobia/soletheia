import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'mnemonic_entropy_exception.dart';
import 'mnemonic_word_count.dart';

part 'mnemonic_entropy.freezed.dart';

/// The entropy used to generate a BIP-39 mnemonic.
@Freezed(copyWith: false, toStringOverride: false)
sealed class MnemonicEntropy with _$MnemonicEntropy {
  factory MnemonicEntropy(Uint8List bytes) = _MnemonicEntropy;

  factory MnemonicEntropy.forWordCount(
    MnemonicWordCount wordCount,
    Uint8List bytes,
  ) {
    if (bytes.length != wordCount.entropyBytes) {
      throw InvalidEntropyLengthException(
        bytes.length,
        expectedBytes: wordCount.entropyBytes,
      );
    }
    return MnemonicEntropy(bytes);
  }

  MnemonicEntropy._(Uint8List bytes) : bytes = _validatedCopy(bytes);

  final Uint8List bytes;

  static Uint8List _validatedCopy(Uint8List bytes) {
    if (!MnemonicWordCount.values.any(
      (count) => count.entropyBytes == bytes.length,
    )) {
      throw InvalidEntropyLengthException(bytes.length);
    }
    return Uint8List.fromList(bytes).asUnmodifiableView();
  }

  @override
  String toString() => 'MnemonicEntropy(<redacted>)';
}
