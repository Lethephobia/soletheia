import 'package:application/mnemonic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mnemonic_generation_state.freezed.dart';

@Freezed(toStringOverride: false)
abstract class MnemonicGenerationState with _$MnemonicGenerationState {
  const MnemonicGenerationState._();

  const factory MnemonicGenerationState({
    @Default(MnemonicWordlist.english) MnemonicWordlist wordlist,
    @Default(MnemonicWordCount.words12) MnemonicWordCount wordCount,
    @Default(false) bool customEntropy,
    @Default('') String entropy,
    AsyncValue<Mnemonic>? generation,
  }) = _MnemonicGenerationState;

  int get entropyBits => wordCount.entropyBytes * 8;
  int get hexLength => entropyBits ~/ 4;

  bool get canGenerate =>
      generation?.isLoading != true &&
      (!customEntropy || isValidEntropy(entropy));

  bool isValidEntropy(String? value) {
    final hex = value?.trim() ?? '';
    return hex.length == hexLength && RegExp(r'^[0-9a-fA-F]+$').hasMatch(hex);
  }
}
