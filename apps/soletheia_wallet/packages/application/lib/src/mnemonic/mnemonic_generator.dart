import 'mnemonic.dart';
import 'mnemonic_generation_source.dart';
import 'mnemonic_wordlist.dart';

/// Generates BIP-39 mnemonics in the selected wordlist.
abstract interface class MnemonicGenerator {
  Future<Mnemonic> generate({
    required MnemonicWordlist wordlist,
    required MnemonicGenerationSource source,
  });
}
