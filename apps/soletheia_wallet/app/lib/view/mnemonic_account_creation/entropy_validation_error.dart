import 'package:freezed_annotation/freezed_annotation.dart';

part 'entropy_validation_error.freezed.dart';

@freezed
sealed class EntropyValidationError with _$EntropyValidationError {
  const factory EntropyValidationError.invalidHex() = InvalidEntropyHex;
  const factory EntropyValidationError.invalidLength({
    required int expectedLength,
  }) = InvalidEntropyLength;
}
