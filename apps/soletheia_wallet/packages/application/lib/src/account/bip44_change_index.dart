import 'package:freezed_annotation/freezed_annotation.dart';

import 'derivation_index.dart';

part 'bip44_change_index.freezed.dart';

@Freezed(copyWith: false)
sealed class Bip44ChangeIndex with _$Bip44ChangeIndex {
  factory Bip44ChangeIndex(int value) = _Bip44ChangeIndex;

  Bip44ChangeIndex._(int value) : value = validateDerivationIndex(value);

  final int value;
}
