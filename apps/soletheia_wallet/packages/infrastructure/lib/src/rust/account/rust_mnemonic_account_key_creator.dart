import 'package:application/application.dart';

import '../../rust_bridge/api/account/create_mnemonic_account_keys.dart'
    as rust;
import '../../rust_bridge/application/keypair/derivation_path.dart' as rust;
import '../../rust_bridge/application/mnemonic/mnemonic_entropy.dart' as rust;
import '../../rust_bridge/application/mnemonic/mnemonic_generation_source.dart'
    as rust;
import '../../rust_bridge/application/mnemonic/mnemonic_passphrase.dart'
    as rust;
import '../../rust_bridge/application/mnemonic/mnemonic_word_count.dart'
    as rust;
import '../../rust_bridge/application/mnemonic/mnemonic_wordlist.dart' as rust;

final class RustMnemonicAccountKeyCreator implements MnemonicAccountKeyCreator {
  const RustMnemonicAccountKeyCreator();

  @override
  Future<MnemonicAccount> create({
    required MnemonicWordlist wordlist,
    required MnemonicGenerationSource source,
    required MnemonicPassphrase passphrase,
    required DerivationPath derivationPath,
  }) async {
    final account = await rust.createMnemonicAccountKeys(
      wordlist: _toRustWordlist(wordlist),
      source: _toRustSource(source),
      passphrase: rust.MnemonicPassphrase(value: passphrase.value),
      derivationPath: rust.DerivationPath.parse(value: derivationPath.value),
    );
    return MnemonicAccount(
      address: AccountAddress(account.address.value.inner),
      mnemonicId: MnemonicId(account.mnemonicId.value.inner),
    );
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
        rust.MnemonicGenerationSource.entropy(
          rust.MnemonicEntropy(bytes: entropy.bytes),
        ),
    };
  }
}
