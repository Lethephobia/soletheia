import 'package:application/application.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'entropy_validation_error.dart';

part 'account_creation_view_state.freezed.dart';

@Freezed(toStringOverride: false)
abstract class AccountCreationViewState with _$AccountCreationViewState {
  const AccountCreationViewState._();

  const factory AccountCreationViewState({
    @Default(MnemonicWordlist.english) MnemonicWordlist wordlist,
    @Default(MnemonicWordCount.words12) MnemonicWordCount wordCount,
    @Default(false) bool isCustomEntropy,
    @Default('') String entropy,
    EntropyValidationError? entropyError,
    @Default('') String passphrase,
    @Default(AccountCreationViewState.defaultPath) String path,
    CreatedAccount? created,
    AsyncValue<CreatedAccount>? creation,
  }) = _AccountCreationViewState;

  static const defaultPath = "m/44'/501'/0'/0'";

  DerivationPath? get parsedPath {
    try {
      return DerivationPath.parse(path);
    } on DerivationPathException {
      return null;
    }
  }

  int get entropyBits => wordCount.entropyBytes * 8;
  int get hexLength => entropyBits ~/ 4;

  bool get isFormLocked => creation?.isLoading == true || created != null;

  bool get canSubmit {
    return creation?.isLoading != true &&
        (created != null || parsedPath != null);
  }

  EntropyValidationError? validateEntropy() {
    final hex = entropy.trim();
    if (RegExp(r'[^0-9a-fA-F]').hasMatch(hex)) {
      return const EntropyValidationError.invalidHex();
    }
    if (hex.length != hexLength) {
      return EntropyValidationError.invalidLength(expectedLength: hexLength);
    }
    return null;
  }
}
