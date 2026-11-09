import 'package:freezed_annotation/freezed_annotation.dart';

import '../mnemonic/mnemonic_id.dart';
import 'derivation_path.dart';

part 'mnemonic_derivation.freezed.dart';

/// The stored mnemonic and path used to derive an account.
@freezed
sealed class MnemonicDerivation with _$MnemonicDerivation {
  const factory MnemonicDerivation({
    required MnemonicId mnemonicId,
    required DerivationPath derivationPath,
  }) = _MnemonicDerivation;
}
