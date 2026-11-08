sealed class MnemonicIdException implements Exception {
  const MnemonicIdException();
}

final class InvalidMnemonicIdLengthException extends MnemonicIdException {
  const InvalidMnemonicIdLengthException(this.actualBytes);

  final int actualBytes;
}
