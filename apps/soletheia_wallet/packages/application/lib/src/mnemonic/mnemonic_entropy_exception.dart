sealed class MnemonicEntropyException implements Exception {
  const MnemonicEntropyException();
}

final class InvalidEntropyLengthException extends MnemonicEntropyException {
  const InvalidEntropyLengthException(this.actualBytes, {this.expectedBytes});

  final int actualBytes;
  final int? expectedBytes;
}
