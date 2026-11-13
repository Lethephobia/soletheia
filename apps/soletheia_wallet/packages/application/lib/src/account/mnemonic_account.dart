import 'package:freezed_annotation/freezed_annotation.dart';

import '../mnemonic/mnemonic_id.dart';
import 'account_address.dart';

part 'mnemonic_account.freezed.dart';

@Freezed(copyWith: false)
sealed class MnemonicAccount with _$MnemonicAccount {
  const factory MnemonicAccount({
    required AccountAddress address,
    required MnemonicId mnemonicId,
  }) = _MnemonicAccount;
}
