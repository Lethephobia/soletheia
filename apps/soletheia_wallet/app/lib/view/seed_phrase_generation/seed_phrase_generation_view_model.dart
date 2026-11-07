import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'seed_phrase_generation_state.dart';

part 'seed_phrase_generation_view_model.g.dart';

@riverpod
class SeedPhraseGenerationViewModel extends _$SeedPhraseGenerationViewModel {
  static const wordCounts = [12, 15, 18, 21, 24];

  @override
  SeedPhraseGenerationState build() => const SeedPhraseGenerationState();

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
