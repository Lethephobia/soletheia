import 'package:application/application.dart';
import 'package:infrastructure/rust.dart'
    show PrivateKeyAccountKeyImporterError;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../account.dart';
import 'private_key_account_import_status.dart';
import 'private_key_account_import_view_state.dart';

part 'private_key_account_import_view_model.g.dart';

@riverpod
class PrivateKeyAccountImportViewModel
    extends _$PrivateKeyAccountImportViewModel {
  @override
  PrivateKeyAccountImportViewState build() =>
      const PrivateKeyAccountImportViewState();

  void setPrivateKey(String value) {
    if (state.isFormLocked) return;
    state = state.copyWith(
      privateKey: value,
      hasPrivateKeyError: false,
      status: const PrivateKeyAccountImportStatus.idle(),
    );
  }

  Future<void> importPrivateKey() async {
    if (!state.canSubmit) return;
    final pending = state;
    if (pending.status case PrivateKeyAccountImportSaveFailed(:final account)) {
      state = pending.copyWith(
        status: PrivateKeyAccountImportStatus.saving(account),
      );
      await _completeImport(
        () => ref.read(privateKeyAccountImporterProvider).retrySave(account),
      );
      return;
    }
    if (pending.privateKey.trim().isEmpty) {
      state = pending.copyWith(hasPrivateKeyError: true);
      return;
    }
    state = pending.copyWith(
      status: const PrivateKeyAccountImportStatus.importing(),
    );
    await _completeImport(() async {
      await ref
          .read(privateKeyAccountImporterProvider)
          .import(privateKey: pending.privateKey);
    });
  }

  Future<void> _completeImport(Future<void> Function() operation) async {
    try {
      await operation();
      if (!ref.mounted) return;
      state = state.copyWith(
        status: const PrivateKeyAccountImportStatus.succeeded(),
        privateKey: '',
      );
    } on AccountSaveException catch (error) {
      if (!ref.mounted) return;
      state = state.copyWith(
        status: PrivateKeyAccountImportStatus.saveFailed(error.account),
        privateKey: '',
      );
    } on PrivateKeyAccountKeyImporterError catch (error) {
      if (!ref.mounted) return;
      state = state.copyWith(
        hasPrivateKeyError:
            error ==
            const PrivateKeyAccountKeyImporterError.invalidPrivateKey(),
        status: const PrivateKeyAccountImportStatus.importFailed(),
      );
    } on Exception {
      if (!ref.mounted) return;
      state = state.copyWith(
        status: const PrivateKeyAccountImportStatus.importFailed(),
      );
    }
  }
}
