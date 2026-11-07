use crate::{
    SeedPhrase, SeedPhraseGenerationError, SeedPhraseGenerationSource, SeedPhraseWordlist,
};
use zeroize::Zeroizing;

/// Generates a mnemonic in the selected wordlist. Supplied entropy is used verbatim.
pub fn generate_seed_phrase(
    wordlist: SeedPhraseWordlist,
    source: SeedPhraseGenerationSource<'_>,
) -> Result<SeedPhrase, SeedPhraseGenerationError> {
    let mut random = Zeroizing::new([0u8; 32]);
    let entropy = match source {
        SeedPhraseGenerationSource::Random(count) => {
            // Every three mnemonic words encode four bytes of entropy.
            let entropy_bytes = usize::from(count) / 3 * 4;
            let bytes = &mut random[..entropy_bytes];
            getrandom::fill(bytes)?;
            bytes
        }
        SeedPhraseGenerationSource::Entropy(bytes) => bytes,
    };
    SeedPhrase::from_entropy_in(wordlist, entropy).map_err(|_| {
        SeedPhraseGenerationError::InvalidEntropyLength {
            actual_bytes: entropy.len(),
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::SeedPhraseWordCount;

    #[test]
    fn matches_published_zero_entropy_vectors() {
        // https://github.com/trezor/python-mnemonic/blob/master/vectors.json
        for (language, first, last) in [
            (SeedPhraseWordlist::English, "abandon", "about"),
            (SeedPhraseWordlist::Japanese, "あいこくしん", "あおぞら"),
        ] {
            let phrase =
                generate_seed_phrase(language, SeedPhraseGenerationSource::Entropy(&[0; 16]))
                    .unwrap();
            let mut expected = vec![first; 11];
            expected.push(last);
            assert!(phrase.words().eq(expected));
        }
    }

    #[test]
    fn generates_valid_phrases_for_every_word_count_and_wordlist() {
        for &language in SeedPhraseWordlist::ALL {
            for (count, words) in [
                (SeedPhraseWordCount::Words12, 12),
                (SeedPhraseWordCount::Words15, 15),
                (SeedPhraseWordCount::Words18, 18),
                (SeedPhraseWordCount::Words21, 21),
                (SeedPhraseWordCount::Words24, 24),
            ] {
                let phrase =
                    generate_seed_phrase(language, SeedPhraseGenerationSource::Random(count))
                        .unwrap();
                assert_eq!(phrase.word_count(), words);
                assert!(SeedPhrase::parse_in(language, phrase.to_string()).is_ok());
                let entropy = zeroize::Zeroizing::new(phrase.to_entropy());
                let restored =
                    generate_seed_phrase(language, SeedPhraseGenerationSource::Entropy(&entropy))
                        .unwrap();
                assert!(restored.words().eq(phrase.words()));
            }
        }
    }

    #[test]
    fn rejects_unsupported_entropy_lengths() {
        for length in [0, 12, 15, 17, 31, 33, 36] {
            assert!(matches!(
                generate_seed_phrase(SeedPhraseWordlist::English, SeedPhraseGenerationSource::Entropy(&vec![0; length])),
                Err(SeedPhraseGenerationError::InvalidEntropyLength { actual_bytes }) if actual_bytes == length
            ));
        }
    }
}
