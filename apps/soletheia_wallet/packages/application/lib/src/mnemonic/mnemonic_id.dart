import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'mnemonic_id_exception.dart';

part 'mnemonic_id.freezed.dart';

/// A 16-byte identifier of a stored mnemonic.
@Freezed(copyWith: false)
sealed class MnemonicId with _$MnemonicId {
  factory MnemonicId(Uint8List bytes) = _MnemonicId;

  MnemonicId._(Uint8List bytes) : bytes = _validatedCopy(bytes);

  static const int byteLength = 16;

  final Uint8List bytes;

  static Uint8List _validatedCopy(Uint8List bytes) {
    if (bytes.length != byteLength) {
      throw InvalidMnemonicIdLengthException(bytes.length);
    }
    return Uint8List.fromList(bytes).asUnmodifiableView();
  }
}
