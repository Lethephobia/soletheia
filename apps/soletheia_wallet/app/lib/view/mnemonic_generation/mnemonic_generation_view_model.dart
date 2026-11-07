import 'dart:typed_data';

import 'package:application/mnemonic.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../mnemonic.dart';
import 'mnemonic_generation_state.dart';

part 'mnemonic_generation_view_model.g.dart';

@riverpod
class MnemonicGenerationViewModel extends _$MnemonicGenerationViewModel {
  @override
  MnemonicGenerationState build() => const MnemonicGenerationState();

  void selectWordlist(MnemonicWordlist? value) {
    if (value != null) {
      state = state.copyWith(wordlist: value, generation: null);
    }
  }

  void selectWordCount(MnemonicWordCount? value) {
    if (value != null) {
      state = state.copyWith(wordCount: value, generation: null);
    }
  }

  void setCustomEntropy(bool value) {
    state = state.copyWith(customEntropy: value, generation: null);
  }

  void setEntropy(String value) {
    state = state.copyWith(entropy: value, generation: null);
  }

  Future<void> generate() async {
    if (!state.canGenerate) return;
    final pending = state.copyWith(generation: const AsyncLoading<Mnemonic>());
    state = pending;
    final result = await AsyncValue.guard(() {
      final source = pending.customEntropy
          ? MnemonicGenerationSource.entropy(_parseEntropy(pending))
          : MnemonicGenerationSource.random(pending.wordCount);
      return ref
          .read(mnemonicGeneratorProvider)
          .generate(wordlist: pending.wordlist, source: source);
    });
    if (ref.mounted && identical(state, pending)) {
      state = pending.copyWith(generation: result);
    }
  }

  static MnemonicEntropy _parseEntropy(MnemonicGenerationState form) {
    final hex = form.entropy.trim();
    final bytes = Uint8List(form.wordCount.entropyBytes);
    for (var i = 0; i < bytes.length; i++) {
      bytes[i] = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
    }
    return MnemonicEntropy.forWordCount(form.wordCount, bytes);
  }
}
