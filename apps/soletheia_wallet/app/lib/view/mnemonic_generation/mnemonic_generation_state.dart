import 'package:freezed_annotation/freezed_annotation.dart';

part 'mnemonic_generation_state.freezed.dart';

@Freezed(toStringOverride: false)
abstract class MnemonicGenerationState with _$MnemonicGenerationState {
  const MnemonicGenerationState._();

  const factory MnemonicGenerationState({
    @Default('en') String wordlist,
    @Default(12) int wordCount,
    @Default(false) bool customEntropy,
    @Default('') String entropy,
  }) = _MnemonicGenerationState;

  int get entropyBits => wordCount ~/ 3 * 32;
  int get hexLength => entropyBits ~/ 4;

  bool isValidEntropy(String? value) {
    final hex = value?.trim() ?? '';
    return hex.length == hexLength && RegExp(r'^[0-9a-fA-F]+$').hasMatch(hex);
  }
}
