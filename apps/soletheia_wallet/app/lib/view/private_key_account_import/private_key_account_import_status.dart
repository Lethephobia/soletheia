import 'package:application/application.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'private_key_account_import_status.freezed.dart';

@freezed
sealed class PrivateKeyAccountImportStatus
    with _$PrivateKeyAccountImportStatus {
  const factory PrivateKeyAccountImportStatus.idle() =
      PrivateKeyAccountImportIdle;
  const factory PrivateKeyAccountImportStatus.importing() =
      PrivateKeyAccountImporting;
  const factory PrivateKeyAccountImportStatus.saving(Account account) =
      PrivateKeyAccountImportSaving;
  const factory PrivateKeyAccountImportStatus.importFailed() =
      PrivateKeyAccountImportFailed;
  const factory PrivateKeyAccountImportStatus.saveFailed(Account account) =
      PrivateKeyAccountImportSaveFailed;
  const factory PrivateKeyAccountImportStatus.succeeded() =
      PrivateKeyAccountImportSucceeded;
}
