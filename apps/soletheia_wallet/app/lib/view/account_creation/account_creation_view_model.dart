import 'dart:typed_data';

import 'package:application/application.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../account.dart';
import 'account_creation_view_state.dart';

part 'account_creation_view_model.g.dart';

@riverpod
class AccountCreationViewModel extends _$AccountCreationViewModel {
  @override
  AccountCreationViewState build() => const AccountCreationViewState();

  void selectWordlist(MnemonicWordlist? value) {
    if (value != null) {
      state = state.copyWith(wordlist: value, creation: null);
    }
  }

  void selectWordCount(MnemonicWordCount? value) {
    if (value != null) {
      state = state.copyWith(
        wordCount: value,
        hasEntropyError: false,
        creation: null,
      );
    }
  }

  void setCustomEntropy(bool value) {
    state = state.copyWith(
      isCustomEntropy: value,
      hasEntropyError: false,
      creation: null,
    );
  }

  void setEntropy(String value) {
    state = state.copyWith(
      entropy: value,
      hasEntropyError: false,
      creation: null,
    );
  }

  void setPassphrase(String value) {
    state = state.copyWith(passphrase: value, creation: null);
  }

  void setPath(String value) {
    state = state.copyWith(path: value, creation: null);
  }

  Future<void> createAccount() async {
    if (!state.canSubmit) return;
    final pending = state;
    if (pending.created == null &&
        pending.isCustomEntropy &&
        !pending.isEntropyValid) {
      state = pending.copyWith(hasEntropyError: true);
      return;
    }
    final path = pending.parsedPath!;
    final repository = ref.read(accountRepositoryProvider);
    state = pending.copyWith(creation: const AsyncLoading());
    final result = await AsyncValue.guard(() async {
      var account = pending.created;
      if (account == null) {
        final source = pending.isCustomEntropy
            ? MnemonicGenerationSource.entropy(_parseEntropy(pending))
            : MnemonicGenerationSource.random(pending.wordCount);
        account = await ref
            .read(accountCreatorProvider)
            .create(
              wordlist: pending.wordlist,
              source: source,
              passphrase: MnemonicPassphrase(pending.passphrase),
              derivationPath: path,
            );
        if (ref.mounted) {
          state = state.copyWith(created: account, passphrase: '', entropy: '');
        }
      }
      await repository.save(
        Account(
          address: account.address,
          mnemonicDerivation: MnemonicDerivation(
            mnemonicId: account.mnemonicId,
            derivationPath: path,
          ),
        ),
      );
      return account;
    });
    if (ref.mounted) {
      state = state.copyWith(creation: result);
    }
  }

  static MnemonicEntropy _parseEntropy(AccountCreationViewState form) {
    final hex = form.entropy.trim();
    final bytes = Uint8List(form.wordCount.entropyBytes);
    for (var i = 0; i < bytes.length; i++) {
      bytes[i] = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
    }
    return MnemonicEntropy.forWordCount(form.wordCount, bytes);
  }
}
