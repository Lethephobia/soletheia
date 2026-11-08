import 'package:application/application.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_creation_view_state.freezed.dart';

@Freezed(toStringOverride: false)
abstract class AccountCreationViewState with _$AccountCreationViewState {
  const AccountCreationViewState._();

  const factory AccountCreationViewState({
    @Default(MnemonicWordlist.english) MnemonicWordlist wordlist,
    @Default(MnemonicWordCount.words12) MnemonicWordCount wordCount,
    @Default(false) bool customEntropy,
    @Default('') String entropy,
    @Default("") String passphrase,
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
        (created != null ||
            (parsedPath != null &&
                (!customEntropy || isValidEntropy(entropy))));
  }

  bool isValidEntropy(String? value) {
    final hex = value?.trim() ?? '';
    return hex.length == hexLength && RegExp(r'^[0-9a-fA-F]+$').hasMatch(hex);
  }
}
