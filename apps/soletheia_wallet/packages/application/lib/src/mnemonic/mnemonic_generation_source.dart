import 'package:freezed_annotation/freezed_annotation.dart';

import 'mnemonic_entropy.dart';
import 'mnemonic_word_count.dart';

part 'mnemonic_generation_source.freezed.dart';

@Freezed(copyWith: false, toStringOverride: false)
sealed class MnemonicGenerationSource with _$MnemonicGenerationSource {
  /// Use cryptographically secure randomness for a phrase of [wordCount] words.
  const factory MnemonicGenerationSource.random(MnemonicWordCount wordCount) =
      RandomMnemonicGenerationSource;

  /// Derive the phrase deterministically; the entropy length sets the word count.
  const factory MnemonicGenerationSource.entropy(MnemonicEntropy entropy) =
      EntropyMnemonicGenerationSource;
}
