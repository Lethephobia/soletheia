import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'account_address_exception.dart';

part 'account_address.freezed.dart';

/// A 32-byte Solana account address.
@Freezed(copyWith: false)
sealed class AccountAddress with _$AccountAddress {
  factory AccountAddress(Uint8List bytes) = _AccountAddress;

  AccountAddress._(Uint8List bytes) : bytes = _validatedCopy(bytes);

  static const int byteLength = 32;

  final Uint8List bytes;

  static Uint8List _validatedCopy(Uint8List bytes) {
    if (bytes.length != byteLength) {
      throw InvalidAccountAddressLengthException(bytes.length);
    }
    return Uint8List.fromList(bytes).asUnmodifiableView();
  }
}
