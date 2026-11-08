sealed class DerivationPathException implements Exception {
  const DerivationPathException();
}

final class InvalidDerivationPathException extends DerivationPathException {
  const InvalidDerivationPathException();
}
