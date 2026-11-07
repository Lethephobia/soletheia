import 'package:freezed_annotation/freezed_annotation.dart';

part 'mnemonic_word.freezed.dart';

/// A single word in a BIP-39 mnemonic.
@Freezed(copyWith: false, toStringOverride: false)
sealed class MnemonicWord with _$MnemonicWord {
  const factory MnemonicWord(String value) = _MnemonicWord;

  const MnemonicWord._();

  @override
  String toString() => 'MnemonicWord(<redacted>)';
}
