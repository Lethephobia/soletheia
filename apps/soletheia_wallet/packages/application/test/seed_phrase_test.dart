import 'package:application/seed_phrase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('keeps word order and redacts the phrase from log output', () {
    final words = [
      ...List.filled(11, const SeedPhraseWord('abandon')),
      const SeedPhraseWord('about'),
    ];
    final phrase = SeedPhrase(words);
    final same = SeedPhrase(words);
    words[0] = const SeedPhraseWord('about');

    expect(phrase.words.first.value, 'abandon');
    expect(phrase.words.last.value, 'about');
    expect(() => phrase.words.clear(), throwsUnsupportedError);
    expect(phrase, same);
    expect(phrase.hashCode, same.hashCode);
    expect(phrase.words.first.toString(), isNot(contains('abandon')));
    expect(phrase.toString(), isNot(contains('abandon')));
    expect(phrase.toString(), isNot(contains('about')));
  });
}
