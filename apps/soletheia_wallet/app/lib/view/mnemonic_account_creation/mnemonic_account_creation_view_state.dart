import 'package:application/application.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'mnemonic_account_creation_status.dart';
import 'entropy_validation_error.dart';

part 'mnemonic_account_creation_view_state.freezed.dart';

@Freezed(toStringOverride: false)
abstract class MnemonicAccountCreationViewState
    with _$MnemonicAccountCreationViewState {
  const MnemonicAccountCreationViewState._();

  const factory MnemonicAccountCreationViewState({
    @Default(MnemonicWordlist.english) MnemonicWordlist wordlist,
    @Default(MnemonicWordCount.words12) MnemonicWordCount wordCount,
    @Default('') String entropy,
    EntropyValidationError? entropyError,
    @Default('') String passphrase,
    @Default(MnemonicAccountCreationViewState.defaultPath) String path,
    DerivationPathException? pathError,
    @Default(MnemonicAccountCreationStatus.idle())
    MnemonicAccountCreationStatus status,
  }) = _MnemonicAccountCreationViewState;

  static const defaultPath = "m/44'/501'/0'/0'";

  int get hexLength => wordCount.entropyBytes * 2;

  bool get isFormLocked {
    return status is! MnemonicAccountCreationIdle &&
        status is! MnemonicAccountCreationFailed;
  }

  bool get canSubmit => !isFormLocked || status is MnemonicAccountSaveFailed;

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
