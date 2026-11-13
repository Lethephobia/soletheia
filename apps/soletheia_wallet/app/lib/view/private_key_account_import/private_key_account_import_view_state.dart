import 'package:freezed_annotation/freezed_annotation.dart';

import 'private_key_account_import_status.dart';

part 'private_key_account_import_view_state.freezed.dart';

@Freezed(toStringOverride: false)
abstract class PrivateKeyAccountImportViewState
    with _$PrivateKeyAccountImportViewState {
  const PrivateKeyAccountImportViewState._();

  const factory PrivateKeyAccountImportViewState({
    @Default('') String privateKey,
    @Default(false) bool hasPrivateKeyError,
    @Default(PrivateKeyAccountImportStatus.idle())
    PrivateKeyAccountImportStatus status,
  }) = _PrivateKeyAccountImportViewState;

  bool get isFormLocked {
    return status is! PrivateKeyAccountImportIdle &&
        status is! PrivateKeyAccountImportFailed;
  }

  bool get keysImported {
    return status is PrivateKeyAccountImportSaveFailed ||
        status is PrivateKeyAccountImportSaving ||
        status is PrivateKeyAccountImportSucceeded;
  }

  bool get canSubmit =>
      !isFormLocked || status is PrivateKeyAccountImportSaveFailed;
}
