import 'package:freezed_annotation/freezed_annotation.dart';

import 'bip44_account_index.dart';
import 'bip44_change_index.dart';
import 'derivation_index.dart';
import 'derivation_path_exception.dart';

part 'derivation_path.freezed.dart';

/// An absolute Ed25519 derivation path, stored with explicit hardened indexes.
@Freezed(copyWith: false)
sealed class DerivationPath with _$DerivationPath {
  factory DerivationPath.parse(String value) = _DerivationPath;

  /// Pass null for [change] to end the path at [account].
  factory DerivationPath.bip44({
    required Bip44AccountIndex account,
    required Bip44ChangeIndex? change,
  }) {
    final path = 'm/44/501/${account.value}';
    return DerivationPath.parse(
      change == null ? path : '$path/${change.value}',
    );
  }

  DerivationPath._(String value) : value = _normalize(value);

  final String value;

  static String _normalize(String path) {
    final parts = path.split('/');
    if (parts.first != 'm') {
      throw const InvalidDerivationPathException();
    }

    final canonical = StringBuffer('m');
    for (final part in parts.skip(1)) {
      final digits = part.endsWith("'")
          ? part.substring(0, part.length - 1)
          : part;
      if (!_decimal.hasMatch(digits)) {
        throw const InvalidDerivationPathException();
      }
      final index = int.tryParse(digits);
      if (index == null) {
        throw const InvalidDerivationPathException();
      }
      canonical.write("/${validateDerivationIndex(index)}'");
    }
    return canonical.toString();
  }

  static final _decimal = RegExp(r'^[0-9]+$');
}
