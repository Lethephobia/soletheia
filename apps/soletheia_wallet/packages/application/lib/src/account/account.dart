import 'package:freezed_annotation/freezed_annotation.dart';

import '../mnemonic/mnemonic_id.dart';
import 'account_address.dart';
import 'derivation_path.dart';

part 'account.freezed.dart';

/// A wallet account and the information used to locate its keys.
@freezed
sealed class Account with _$Account {
  const factory Account({
    required AccountAddress address,
    required MnemonicId mnemonicId,
    required DerivationPath derivationPath,
  }) = _Account;
}
