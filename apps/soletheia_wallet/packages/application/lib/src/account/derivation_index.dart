import 'derivation_path_exception.dart';

int validateDerivationIndex(int value) {
  if (value < 0 || value > 0x7fffffff) {
    throw const InvalidDerivationPathException();
  }
  return value;
}
