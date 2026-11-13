import 'package:application/application.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mnemonic_account_import_status.freezed.dart';

@freezed
sealed class MnemonicAccountImportStatus with _$MnemonicAccountImportStatus {
  const factory MnemonicAccountImportStatus.idle() = MnemonicAccountImportIdle;
  const factory MnemonicAccountImportStatus.importing() =
      MnemonicAccountImporting;
  const factory MnemonicAccountImportStatus.saving(Account account) =
      MnemonicAccountImportSaving;
  const factory MnemonicAccountImportStatus.importFailed() =
      MnemonicAccountImportFailed;
  const factory MnemonicAccountImportStatus.saveFailed(Account account) =
      MnemonicAccountImportSaveFailed;
  const factory MnemonicAccountImportStatus.succeeded() =
      MnemonicAccountImportSucceeded;
}
