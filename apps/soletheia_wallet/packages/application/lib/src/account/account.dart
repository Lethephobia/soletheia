import 'package:freezed_annotation/freezed_annotation.dart';

import 'account_address.dart';
import 'mnemonic_derivation.dart';

part 'account.freezed.dart';

/// A wallet account and the information used to locate its keys.
@freezed
sealed class Account with _$Account {
  const factory Account({
    required AccountAddress address,
    MnemonicDerivation? mnemonicDerivation,
  }) = _Account;
}
