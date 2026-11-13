import 'package:application/application.dart';
import 'package:infrastructure/rust.dart'
    show MnemonicAccountKeyImporterError_MnemonicParsing;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../account.dart';
import 'mnemonic_account_import_status.dart';
import 'mnemonic_account_import_view_state.dart';

part 'mnemonic_account_import_view_model.g.dart';

@riverpod
class MnemonicAccountImportViewModel extends _$MnemonicAccountImportViewModel {
  @override
  MnemonicAccountImportViewState build() =>
      const MnemonicAccountImportViewState();

  void setPhrase(String value) {
    if (state.isFormLocked) return;
    state = state.copyWith(
      phrase: value,
      hasPhraseError: false,
      status: const MnemonicAccountImportStatus.idle(),
    );
  }

  void setPassphrase(String value) {
    if (state.isFormLocked) return;
    state = state.copyWith(
      passphrase: value,
      status: const MnemonicAccountImportStatus.idle(),
    );
  }

  void setPath(String value) {
    if (state.isFormLocked) return;
    state = state.copyWith(
      path: value,
      pathError: null,
      status: const MnemonicAccountImportStatus.idle(),
    );
  }

  Future<void> importMnemonic() async {
    if (!state.canSubmit) return;
    final pending = state;
    if (pending.status case MnemonicAccountImportSaveFailed(:final account)) {
      state = pending.copyWith(
        status: MnemonicAccountImportStatus.saving(account),
      );
      await _completeImport(
        () => ref.read(mnemonicAccountImporterProvider).retrySave(account),
      );
      return;
    }
    final hasPhraseError = pending.phrase.trim().isEmpty;
    final DerivationPath path;
    try {
      path = DerivationPath.parse(pending.path);
    } on DerivationPathException catch (error) {
      state = pending.copyWith(
        pathError: error,
        hasPhraseError: hasPhraseError,
      );
      return;
    }
    if (hasPhraseError) {
      state = pending.copyWith(hasPhraseError: hasPhraseError);
      return;
    }
    state = pending.copyWith(
      status: const MnemonicAccountImportStatus.importing(),
    );
    await _completeImport(() async {
      await ref
          .read(mnemonicAccountImporterProvider)
          .import(
            phrase: pending.phrase,
            passphrase: MnemonicPassphrase(pending.passphrase),
            derivationPath: path,
          );
    });
  }

  Future<void> _completeImport(Future<void> Function() operation) async {
    try {
      await operation();
      if (!ref.mounted) return;
      state = state.copyWith(
        status: const MnemonicAccountImportStatus.succeeded(),
        passphrase: '',
        phrase: '',
      );
    } on AccountSaveException catch (error) {
      if (!ref.mounted) return;
      state = state.copyWith(
        status: MnemonicAccountImportStatus.saveFailed(error.account),
        passphrase: '',
        phrase: '',
      );
    } on MnemonicAccountKeyImporterError_MnemonicParsing {
      if (!ref.mounted) return;
      state = state.copyWith(
        hasPhraseError: true,
        status: const MnemonicAccountImportStatus.importFailed(),
      );
    } on Exception {
      if (!ref.mounted) return;
      state = state.copyWith(
        status: const MnemonicAccountImportStatus.importFailed(),
      );
    }
  }
}
