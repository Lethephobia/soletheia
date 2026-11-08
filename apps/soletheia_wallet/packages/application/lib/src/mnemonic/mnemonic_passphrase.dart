import 'package:freezed_annotation/freezed_annotation.dart';

part 'mnemonic_passphrase.freezed.dart';

/// The BIP-39 passphrase supplied to seed derivation, including any whitespace.
@Freezed(copyWith: false, toStringOverride: false)
final class MnemonicPassphrase with _$MnemonicPassphrase {
  const MnemonicPassphrase(this.value);

  const MnemonicPassphrase.empty() : this('');

  final String value;

  @override
  String toString() => 'MnemonicPassphrase(<redacted>)';
}
