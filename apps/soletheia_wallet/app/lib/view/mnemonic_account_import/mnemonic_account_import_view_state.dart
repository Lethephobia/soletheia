import 'package:application/application.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'mnemonic_account_import_status.dart';

part 'mnemonic_account_import_view_state.freezed.dart';

@Freezed(toStringOverride: false)
abstract class MnemonicAccountImportViewState
    with _$MnemonicAccountImportViewState {
  const MnemonicAccountImportViewState._();

  const factory MnemonicAccountImportViewState({
    @Default('') String phrase,
    @Default(false) bool hasPhraseError,
    @Default('') String passphrase,
    @Default(MnemonicAccountImportViewState.defaultPath) String path,
    DerivationPathException? pathError,
    @Default(MnemonicAccountImportStatus.idle())
    MnemonicAccountImportStatus status,
  }) = _MnemonicAccountImportViewState;

  static const defaultPath = "m/44'/501'/0'/0'";

  bool get isFormLocked {
    return status is! MnemonicAccountImportIdle &&
        status is! MnemonicAccountImportFailed;
  }

  bool get keysImported {
    return status is MnemonicAccountImportSaveFailed ||
        status is MnemonicAccountImportSaving ||
        status is MnemonicAccountImportSucceeded;
  }

  bool get canSubmit =>
      !isFormLocked || status is MnemonicAccountImportSaveFailed;
}
