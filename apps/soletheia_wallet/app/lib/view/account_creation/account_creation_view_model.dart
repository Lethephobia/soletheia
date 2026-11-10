import 'dart:typed_data';

import 'package:application/application.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../account.dart';
import 'account_creation_status.dart';
import 'account_creation_view_state.dart';

part 'account_creation_view_model.g.dart';

@riverpod
class AccountCreationViewModel extends _$AccountCreationViewModel {
  @override
  AccountCreationViewState build() => const AccountCreationViewState();

  void selectWordlist(MnemonicWordlist? value) {
    if (!state.isFormLocked && value != null) {
      state = state.copyWith(
        wordlist: value,
        status: const AccountCreationStatus.idle(),
      );
    }
  }

  void selectWordCount(MnemonicWordCount? value) {
    if (!state.isFormLocked && value != null) {
      state = state.copyWith(
        wordCount: value,
        entropyError: null,
        status: const AccountCreationStatus.idle(),
      );
    }
  }

  void setEntropy(String value) {
    if (state.isFormLocked) return;
    state = state.copyWith(
      entropy: value,
      entropyError: null,
      status: const AccountCreationStatus.idle(),
    );
  }

  void setPassphrase(String value) {
    if (state.isFormLocked) return;
    state = state.copyWith(
      passphrase: value,
      status: const AccountCreationStatus.idle(),
    );
  }

  void setPath(String value) {
    if (state.isFormLocked) return;
    state = state.copyWith(
      path: value,
      pathError: null,
      status: const AccountCreationStatus.idle(),
    );
  }

  Future<void> createAccount() async {
    if (!state.canSubmit) return;
    final pending = state;
    if (pending.status case AccountSaveFailed(:final account)) {
      await _saveAccount(ref.read(accountRepositoryProvider), account);
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
    final repository = ref.read(accountRepositoryProvider);
    state = pending.copyWith(status: const AccountCreationStatus.creating());
    final CreatedAccount created;
    try {
      final source = pending.entropy.isNotEmpty
          ? MnemonicGenerationSource.entropy(_parseEntropy(pending))
          : MnemonicGenerationSource.random(pending.wordCount);
      created = await ref
          .read(accountCreatorProvider)
          .create(
            wordlist: pending.wordlist,
            source: source,
            passphrase: MnemonicPassphrase(pending.passphrase),
            derivationPath: path,
          );
    } catch (_) {
      if (ref.mounted) {
        state = state.copyWith(
          status: const AccountCreationStatus.creationFailed(),
        );
      }
      return;
    }
    final account = Account(
      address: created.address,
      mnemonicDerivation: MnemonicDerivation(
        mnemonicId: created.mnemonicId,
        derivationPath: path,
      ),
    );
    await _saveAccount(repository, account);
  }

  Future<void> _saveAccount(
    AccountRepository repository,
    Account account,
  ) async {
    if (ref.mounted) {
      state = state.copyWith(
        status: AccountCreationStatus.saving(account),
        passphrase: '',
        entropy: '',
      );
    }
    try {
      await repository.save(account);
      await repository.selectAccount(account.address);
    } catch (_) {
      if (ref.mounted) {
        state = state.copyWith(
          status: AccountCreationStatus.saveFailed(account),
        );
      }
      return;
    }
    if (ref.mounted) {
      state = state.copyWith(status: const AccountCreationStatus.succeeded());
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
