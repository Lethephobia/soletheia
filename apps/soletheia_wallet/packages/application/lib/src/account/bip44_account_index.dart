import 'package:freezed_annotation/freezed_annotation.dart';

import 'derivation_index.dart';

part 'bip44_account_index.freezed.dart';

@Freezed(copyWith: false)
sealed class Bip44AccountIndex with _$Bip44AccountIndex {
  factory Bip44AccountIndex(int value) = _Bip44AccountIndex;

  Bip44AccountIndex._(int value) : value = validateDerivationIndex(value);

  final int value;
}
