use super::{
    mnemonic_generation_error::MnemonicGenerationError, MnemonicGenerationSource, MnemonicWordlist,
};
use bip39::Mnemonic;
use zeroize::Zeroizing;

/// Generates a mnemonic in the selected wordlist. Supplied entropy is used verbatim.
pub fn generate_mnemonic(
    wordlist: MnemonicWordlist,
    source: MnemonicGenerationSource,
) -> anyhow::Result<Vec<String>> {
    let entropy = match source {
        MnemonicGenerationSource::Random(count) => {
            // Every three mnemonic words encode four bytes of entropy.
            let entropy_bytes = usize::from(count) / 3 * 4;
            let mut bytes = Zeroizing::new(vec![0u8; entropy_bytes]);
            getrandom::fill(&mut bytes).map_err(MnemonicGenerationError::Randomness)?;
            bytes
        }
        MnemonicGenerationSource::Entropy(bytes) => Zeroizing::new(bytes),
    };
    let phrase = Mnemonic::from_entropy_in(wordlist, &entropy).map_err(|_| {
        MnemonicGenerationError::InvalidEntropyLength {
            actual_bytes: entropy.len(),
        }
    })?;
    Ok(phrase.words().map(str::to_owned).collect())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::mnemonic::MnemonicWordCount;

    #[test]
    fn matches_published_zero_entropy_vectors() {
        // https://github.com/trezor/python-mnemonic/blob/master/vectors.json
        for (language, first, last) in [
            (MnemonicWordlist::English, "abandon", "about"),
            (MnemonicWordlist::Japanese, "あいこくしん", "あおぞら"),
        ] {
            let phrase =
                generate_mnemonic(language, MnemonicGenerationSource::Entropy(vec![0; 16]))
                    .unwrap();
            let mut expected = vec![first; 11];
            expected.push(last);
            assert_eq!(phrase, expected);
        }
    }

    #[test]
    fn generates_valid_phrases_for_every_word_count_and_wordlist() {
        for &language in MnemonicWordlist::ALL {
            for (count, words) in [
                (MnemonicWordCount::Words12, 12),
                (MnemonicWordCount::Words15, 15),
                (MnemonicWordCount::Words18, 18),
                (MnemonicWordCount::Words21, 21),
                (MnemonicWordCount::Words24, 24),
            ] {
                let phrase =
                    generate_mnemonic(language, MnemonicGenerationSource::Random(count)).unwrap();
                assert_eq!(phrase.len(), words);
                let parsed = Mnemonic::parse_in(language, phrase.join(" ")).unwrap();
                let entropy = parsed.to_entropy();
                let restored =
                    generate_mnemonic(language, MnemonicGenerationSource::Entropy(entropy))
                        .unwrap();
                assert!(restored == phrase);
            }
        }
    }

    #[test]
    fn rejects_unsupported_entropy_lengths() {
        for length in [0, 12, 15, 17, 31, 33, 36] {
            assert!(matches!(
                generate_mnemonic(MnemonicWordlist::English, MnemonicGenerationSource::Entropy(vec![0; length])).unwrap_err().downcast::<MnemonicGenerationError>(),
                Ok(MnemonicGenerationError::InvalidEntropyLength { actual_bytes }) if actual_bytes == length
            ));
        }
    }
}
