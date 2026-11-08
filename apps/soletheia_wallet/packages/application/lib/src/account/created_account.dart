import 'package:freezed_annotation/freezed_annotation.dart';

import '../mnemonic/mnemonic_id.dart';
import 'account_address.dart';

part 'created_account.freezed.dart';

@Freezed(copyWith: false)
sealed class CreatedAccount with _$CreatedAccount {
  const factory CreatedAccount({
    required AccountAddress address,
    required MnemonicId mnemonicId,
  }) = _CreatedAccount;
}
