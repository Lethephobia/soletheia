import 'seed_phrase.dart';
import 'seed_phrase_generation_source.dart';
import 'seed_phrase_wordlist.dart';

/// Generates BIP-39 mnemonics in the selected wordlist.
abstract interface class SeedPhraseGenerator {
  Future<SeedPhrase> generate({
    required SeedPhraseWordlist wordlist,
    required SeedPhraseGenerationSource source,
  });
}
