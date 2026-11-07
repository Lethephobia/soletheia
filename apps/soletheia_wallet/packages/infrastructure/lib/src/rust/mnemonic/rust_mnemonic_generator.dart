import 'package:application/mnemonic.dart';

import '../../rust_bridge/mnemonic/generate_mnemonic.dart' as rust;
import '../../rust_bridge/mnemonic/mnemonic_generation_source.dart' as rust;
import '../../rust_bridge/mnemonic/mnemonic_word_count.dart' as rust;
import '../../rust_bridge/mnemonic/mnemonic_wordlist.dart' as rust;

final class RustMnemonicGenerator implements MnemonicGenerator {
  const RustMnemonicGenerator();

  @override
  Future<Mnemonic> generate({
    required MnemonicWordlist wordlist,
    required MnemonicGenerationSource source,
  }) async {
    final words = await rust.generateMnemonic(
      wordlist: _toRustWordlist(wordlist),
      source: _toRustSource(source),
    );
    return Mnemonic(words.map(MnemonicWord.new).toList());
  }

  static rust.MnemonicWordlist _toRustWordlist(MnemonicWordlist wordlist) {
    return switch (wordlist) {
      MnemonicWordlist.english => rust.MnemonicWordlist.english,
      MnemonicWordlist.japanese => rust.MnemonicWordlist.japanese,
      MnemonicWordlist.korean => rust.MnemonicWordlist.korean,
      MnemonicWordlist.simplifiedChinese =>
        rust.MnemonicWordlist.simplifiedChinese,
      MnemonicWordlist.traditionalChinese =>
        rust.MnemonicWordlist.traditionalChinese,
      MnemonicWordlist.french => rust.MnemonicWordlist.french,
      MnemonicWordlist.italian => rust.MnemonicWordlist.italian,
      MnemonicWordlist.spanish => rust.MnemonicWordlist.spanish,
      MnemonicWordlist.czech => rust.MnemonicWordlist.czech,
      MnemonicWordlist.portuguese => rust.MnemonicWordlist.portuguese,
    };
  }

  static rust.MnemonicWordCount _toRustWordCount(MnemonicWordCount wordCount) {
    return switch (wordCount) {
      MnemonicWordCount.words12 => rust.MnemonicWordCount.words12,
      MnemonicWordCount.words15 => rust.MnemonicWordCount.words15,
      MnemonicWordCount.words18 => rust.MnemonicWordCount.words18,
      MnemonicWordCount.words21 => rust.MnemonicWordCount.words21,
      MnemonicWordCount.words24 => rust.MnemonicWordCount.words24,
    };
  }

  static rust.MnemonicGenerationSource _toRustSource(
    MnemonicGenerationSource source,
  ) {
    return switch (source) {
      RandomMnemonicGenerationSource(:final wordCount) =>
        rust.MnemonicGenerationSource.random(_toRustWordCount(wordCount)),
      EntropyMnemonicGenerationSource(:final entropy) =>
        rust.MnemonicGenerationSource.entropy(entropy.bytes),
    };
  }
}
