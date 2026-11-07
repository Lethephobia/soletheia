import 'package:freezed_annotation/freezed_annotation.dart';

import 'mnemonic_word.dart';

part 'mnemonic.freezed.dart';

/// An ordered sequence of BIP-39 words.
@Freezed(copyWith: false, toStringOverride: false)
sealed class Mnemonic with _$Mnemonic {
  /// Takes words that the caller has already generated or validated.
  factory Mnemonic(List<MnemonicWord> words) = _Mnemonic;

  Mnemonic._(List<MnemonicWord> words) : words = List.unmodifiable(words);

  final List<MnemonicWord> words;

  @override
  String toString() => 'Mnemonic(<redacted>)';
}
