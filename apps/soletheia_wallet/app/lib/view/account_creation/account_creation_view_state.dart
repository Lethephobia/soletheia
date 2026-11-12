import 'package:application/application.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'account_creation_status.dart';
import 'entropy_validation_error.dart';

part 'account_creation_view_state.freezed.dart';

@Freezed(toStringOverride: false)
abstract class AccountCreationViewState with _$AccountCreationViewState {
  const AccountCreationViewState._();

  const factory AccountCreationViewState({
    @Default(MnemonicWordlist.english) MnemonicWordlist wordlist,
    @Default(MnemonicWordCount.words12) MnemonicWordCount wordCount,
    @Default('') String entropy,
    EntropyValidationError? entropyError,
    @Default('') String passphrase,
    @Default(AccountCreationViewState.defaultPath) String path,
    DerivationPathException? pathError,
    @Default(AccountCreationStatus.idle()) AccountCreationStatus status,
  }) = _AccountCreationViewState;

  static const defaultPath = "m/44'/501'/0'/0'";

  int get hexLength => wordCount.entropyBytes * 2;

  bool get isFormLocked {
    return status is! AccountCreationIdle && status is! AccountCreationFailed;
  }

  bool get canSubmit => !isFormLocked || status is AccountSaveFailed;

  EntropyValidationError? validateEntropy() {
    if (entropy.isEmpty) return null;
    final hex = entropy.trim();
    if (hex.isEmpty || RegExp(r'[^0-9a-fA-F]').hasMatch(hex)) {
      return const EntropyValidationError.invalidHex();
    }
    if (hex.length != hexLength) {
      return EntropyValidationError.invalidLength(expectedLength: hexLength);
    }
    return null;
  }
}
