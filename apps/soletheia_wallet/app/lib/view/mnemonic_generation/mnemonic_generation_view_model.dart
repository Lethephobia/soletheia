import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'mnemonic_generation_state.dart';

part 'mnemonic_generation_view_model.g.dart';

@riverpod
class MnemonicGenerationViewModel extends _$MnemonicGenerationViewModel {
  static const wordCounts = [12, 15, 18, 21, 24];

  @override
  MnemonicGenerationState build() => const MnemonicGenerationState();

  void selectWordlist(String? value) {
    if (value != null) {
      state = state.copyWith(wordlist: value);
    }
  }

  void selectWordCount(int? value) {
    if (value != null && wordCounts.contains(value)) {
      state = state.copyWith(wordCount: value);
    }
  }

  void setCustomEntropy(bool value) {
    state = state.copyWith(customEntropy: value);
  }

  void setEntropy(String value) {
    state = state.copyWith(entropy: value);
  }
}
