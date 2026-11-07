sealed class SeedPhraseEntropyException implements Exception {
  const SeedPhraseEntropyException();
}

final class InvalidEntropyLengthException extends SeedPhraseEntropyException {
  const InvalidEntropyLengthException(this.actualBytes, {this.expectedBytes});

  final int actualBytes;
  final int? expectedBytes;
}
