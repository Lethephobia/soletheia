import 'package:application/application.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mnemonic_account_creation_status.freezed.dart';

@freezed
sealed class MnemonicAccountCreationStatus
    with _$MnemonicAccountCreationStatus {
  const factory MnemonicAccountCreationStatus.idle() =
      MnemonicAccountCreationIdle;
  const factory MnemonicAccountCreationStatus.creating() =
      MnemonicAccountCreating;
  const factory MnemonicAccountCreationStatus.saving(Account account) =
      MnemonicAccountSaving;
  const factory MnemonicAccountCreationStatus.creationFailed() =
      MnemonicAccountCreationFailed;
  const factory MnemonicAccountCreationStatus.saveFailed(Account account) =
      MnemonicAccountSaveFailed;
  const factory MnemonicAccountCreationStatus.succeeded() =
      MnemonicAccountCreationSucceeded;
}
