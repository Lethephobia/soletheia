import 'package:freezed_annotation/freezed_annotation.dart';

part 'seed_phrase_word.freezed.dart';

/// A single word in a BIP-39 seed phrase.
@Freezed(copyWith: false, toStringOverride: false)
sealed class SeedPhraseWord with _$SeedPhraseWord {
  const factory SeedPhraseWord(String value) = _SeedPhraseWord;

  const SeedPhraseWord._();

  @override
  String toString() => 'SeedPhraseWord(<redacted>)';
}
