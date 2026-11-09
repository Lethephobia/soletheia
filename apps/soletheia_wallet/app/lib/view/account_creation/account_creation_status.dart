import 'package:application/application.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_creation_status.freezed.dart';

@freezed
sealed class AccountCreationStatus with _$AccountCreationStatus {
  const factory AccountCreationStatus.idle() = AccountCreationIdle;
  const factory AccountCreationStatus.creating() = AccountCreating;
  const factory AccountCreationStatus.saving(Account account) = AccountSaving;
  const factory AccountCreationStatus.creationFailed() = AccountCreationFailed;
  const factory AccountCreationStatus.saveFailed(Account account) =
      AccountSaveFailed;
  const factory AccountCreationStatus.succeeded() = AccountCreationSucceeded;
}
