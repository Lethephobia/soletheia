import 'package:freezed_annotation/freezed_annotation.dart';

import 'seed_phrase_word.dart';

part 'seed_phrase.freezed.dart';

/// An ordered sequence of BIP-39 words.
@Freezed(copyWith: false, toStringOverride: false)
sealed class SeedPhrase with _$SeedPhrase {
  /// Takes words that the caller has already generated or validated.
  factory SeedPhrase(List<SeedPhraseWord> words) = _SeedPhrase;

  SeedPhrase._(List<SeedPhraseWord> words) : words = List.unmodifiable(words);

  final List<SeedPhraseWord> words;

  @override
  String toString() => 'SeedPhrase(<redacted>)';
}
