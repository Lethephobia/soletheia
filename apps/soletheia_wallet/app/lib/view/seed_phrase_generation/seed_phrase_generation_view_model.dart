import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'seed_phrase_generation_view_model.g.dart';

class SeedPhraseGenerationState {
  const SeedPhraseGenerationState({
    this.wordlist = 'en',
    this.wordCount = 12,
    this.customEntropy = false,
    this.entropy = '',
  });

  final String wordlist;
  final int wordCount;
  final bool customEntropy;
  final String entropy;

  int get entropyBits => wordCount ~/ 3 * 32;
  int get hexLength => entropyBits ~/ 4;

  bool isValidEntropy(String? value) {
    final hex = value?.trim() ?? '';
    return hex.length == hexLength && RegExp(r'^[0-9a-fA-F]+$').hasMatch(hex);
  }

  SeedPhraseGenerationState copyWith({
    String? wordlist,
    int? wordCount,
    bool? customEntropy,
    String? entropy,
  }) {
    return SeedPhraseGenerationState(
      wordlist: wordlist ?? this.wordlist,
      wordCount: wordCount ?? this.wordCount,
      customEntropy: customEntropy ?? this.customEntropy,
      entropy: entropy ?? this.entropy,
    );
  }
}

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
