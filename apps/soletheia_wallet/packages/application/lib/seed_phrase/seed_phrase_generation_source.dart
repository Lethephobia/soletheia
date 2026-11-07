import 'package:freezed_annotation/freezed_annotation.dart';

import 'seed_phrase_entropy.dart';
import 'seed_phrase_word_count.dart';

part 'seed_phrase_generation_source.freezed.dart';

@Freezed(copyWith: false, toStringOverride: false)
sealed class SeedPhraseGenerationSource with _$SeedPhraseGenerationSource {
  /// Use cryptographically secure randomness for a phrase of [wordCount] words.
  const factory SeedPhraseGenerationSource.random(
    SeedPhraseWordCount wordCount,
  ) = RandomSeedPhraseGenerationSource;

  /// Derive the phrase deterministically; the entropy length sets the word count.
  const factory SeedPhraseGenerationSource.entropy(SeedPhraseEntropy entropy) =
      EntropySeedPhraseGenerationSource;
}
