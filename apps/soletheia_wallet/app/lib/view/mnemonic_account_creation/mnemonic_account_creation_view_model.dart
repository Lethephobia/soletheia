import 'dart:typed_data';

import 'package:application/application.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../account.dart';
import 'mnemonic_account_creation_status.dart';
import 'mnemonic_account_creation_view_state.dart';

part 'mnemonic_account_creation_view_model.g.dart';

@riverpod
class MnemonicAccountCreationViewModel
    extends _$MnemonicAccountCreationViewModel {
  @override
  MnemonicAccountCreationViewState build() =>
      const MnemonicAccountCreationViewState();

  void selectWordlist(MnemonicWordlist? value) {
    if (!state.isFormLocked && value != null) {
      state = state.copyWith(
        wordlist: value,
        status: const MnemonicAccountCreationStatus.idle(),
      );
    }
  }

  void selectWordCount(MnemonicWordCount? value) {
    if (!state.isFormLocked && value != null) {
      state = state.copyWith(
        wordCount: value,
        entropyError: null,
        status: const MnemonicAccountCreationStatus.idle(),
      );
    }
  }

  void setEntropy(String value) {
    if (state.isFormLocked) return;
    state = state.copyWith(
      entropy: value,
      entropyError: null,
      status: const MnemonicAccountCreationStatus.idle(),
    );
  }

  void setPassphrase(String value) {
    if (state.isFormLocked) return;
    state = state.copyWith(
      passphrase: value,
      status: const MnemonicAccountCreationStatus.idle(),
    );
  }

  void setPath(String value) {
    if (state.isFormLocked) return;
    state = state.copyWith(
      path: value,
      pathError: null,
      status: const MnemonicAccountCreationStatus.idle(),
    );
  }

  Future<void> createAccount() async {
    if (!state.canSubmit) return;
    final pending = state;
    if (pending.status case MnemonicAccountSaveFailed(:final account)) {
      state = pending.copyWith(
        status: MnemonicAccountCreationStatus.saving(account),
      );
      await _completeCreation(
        () => ref.read(mnemonicAccountCreatorProvider).retrySave(account),
      );
      return;
    }
    final entropyError = pending.validateEntropy();
    final DerivationPath path;
    try {
      path = DerivationPath.parse(pending.path);
    } on DerivationPathException catch (error) {
      state = pending.copyWith(pathError: error, entropyError: entropyError);
      return;
    }
    if (entropyError != null) {
      state = pending.copyWith(entropyError: entropyError);
      return;
    }
    state = pending.copyWith(
      status: const MnemonicAccountCreationStatus.creating(),
    );
    await _completeCreation(() async {
      final source = pending.entropy.isNotEmpty
          ? MnemonicGenerationSource.entropy(_parseEntropy(pending))
          : MnemonicGenerationSource.random(pending.wordCount);
      await ref
          .read(mnemonicAccountCreatorProvider)
          .create(
            wordlist: pending.wordlist,
            source: source,
            passphrase: MnemonicPassphrase(pending.passphrase),
            derivationPath: path,
          );
    });
  }

  Future<void> _completeCreation(Future<void> Function() operation) async {
    try {
      await operation();
      if (!ref.mounted) return;
      state = state.copyWith(
        status: const MnemonicAccountCreationStatus.succeeded(),
        passphrase: '',
        entropy: '',
      );
    } on AccountSaveException catch (error) {
      if (!ref.mounted) return;
      state = state.copyWith(
        status: MnemonicAccountCreationStatus.saveFailed(error.account),
        passphrase: '',
        entropy: '',
      );
    } on Exception {
      if (!ref.mounted) return;
      state = state.copyWith(
        status: const MnemonicAccountCreationStatus.creationFailed(),
      );
    }
  }

  static MnemonicEntropy _parseEntropy(MnemonicAccountCreationViewState form) {
    final hex = form.entropy.trim();
    final bytes = Uint8List(form.wordCount.entropyBytes);
    for (var i = 0; i < bytes.length; i++) {
      bytes[i] = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
    }
    return MnemonicEntropy.forWordCount(form.wordCount, bytes);
  }
}
