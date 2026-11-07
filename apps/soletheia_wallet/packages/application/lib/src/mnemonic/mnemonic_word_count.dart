enum MnemonicWordCount {
  words12(12, 16),
  words15(15, 20),
  words18(18, 24),
  words21(21, 28),
  words24(24, 32);

  const MnemonicWordCount(this.words, this.entropyBytes);

  final int words;
  final int entropyBytes;
}
