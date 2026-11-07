import 'seed_phrase.dart';
import 'seed_phrase_entropy.dart';
import 'seed_phrase_word_count.dart';
import 'seed_phrase_wordlist.dart';

/// Generates BIP-39 mnemonics in the selected wordlist.
abstract interface class SeedPhraseGenerator {
  /// Uses cryptographically secure randomness for a phrase of [wordCount] words.
  Future<SeedPhrase> generate({
    required SeedPhraseWordlist wordlist,
    required SeedPhraseWordCount wordCount,
  });

  /// Derives the phrase deterministically from [entropy].
  ///
  /// The byte length determines the word count: 16, 20, 24, 28, or 32 bytes.
  Future<SeedPhrase> fromEntropy({
    required SeedPhraseWordlist wordlist,
    required SeedPhraseEntropy entropy,
  });
}
