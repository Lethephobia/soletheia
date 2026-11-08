use crate::application::mnemonic::{
    Mnemonic, MnemonicGenerationSource, MnemonicGenerator, MnemonicGeneratorError, MnemonicWord,
    MnemonicWordCount, MnemonicWordlist,
};

pub struct Bip39MnemonicGenerator;

impl Bip39MnemonicGenerator {
    pub(in crate::infrastructure) fn language(wordlist: MnemonicWordlist) -> ::bip39::Language {
        use ::bip39::Language;

        match wordlist {
            MnemonicWordlist::English => Language::English,
            MnemonicWordlist::Japanese => Language::Japanese,
            MnemonicWordlist::Korean => Language::Korean,
            MnemonicWordlist::SimplifiedChinese => Language::SimplifiedChinese,
            MnemonicWordlist::TraditionalChinese => Language::TraditionalChinese,
            MnemonicWordlist::French => Language::French,
            MnemonicWordlist::Italian => Language::Italian,
            MnemonicWordlist::Spanish => Language::Spanish,
            MnemonicWordlist::Czech => Language::Czech,
            MnemonicWordlist::Portuguese => Language::Portuguese,
        }
    }
}

impl MnemonicGenerator for Bip39MnemonicGenerator {
    fn generate_mnemonic(
        &self,
        wordlist: MnemonicWordlist,
        source: MnemonicGenerationSource,
    ) -> Result<Mnemonic, MnemonicGeneratorError> {
        let entropy = match source {
            MnemonicGenerationSource::Entropy(bytes) => bytes,
            MnemonicGenerationSource::Random(count) => {
                let length = match count {
                    MnemonicWordCount::Words12 => 16,
                    MnemonicWordCount::Words15 => 20,
                    MnemonicWordCount::Words18 => 24,
                    MnemonicWordCount::Words21 => 28,
                    MnemonicWordCount::Words24 => 32,
                };
                let mut bytes = vec![0; length];
                if getrandom::fill(&mut bytes).is_err() {
                    use zeroize::Zeroize;

                    bytes.zeroize();
                    return Err(MnemonicGeneratorError::Randomness);
                }
                bytes.try_into()?
            }
        };

        let phrase = ::bip39::Mnemonic::from_entropy_in(Self::language(wordlist), entropy.value())
            .map_err(|_| MnemonicGeneratorError::InvalidEntropyLength {
                actual_bytes: entropy.value().len(),
            })?;

        Ok(Mnemonic::new(
            wordlist,
            phrase
                .words()
                .map(MnemonicWord::from_validated_word)
                .collect(),
        ))
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use MnemonicWordlist::*;

    #[test]
    fn matches_published_zero_entropy_vectors() {
        for (language, first, last) in [
            (English, "abandon", "about"),
            (Japanese, "あいこくしん", "あおぞら"),
        ] {
            let phrase = Bip39MnemonicGenerator
                .generate_mnemonic(
                    language,
                    MnemonicGenerationSource::Entropy(vec![0; 16].try_into().unwrap()),
                )
                .unwrap();
            let mut expected = vec![first; 11];
            expected.push(last);
            assert!(phrase.words().iter().map(MnemonicWord::value).eq(expected));
        }
    }

    #[test]
    fn generates_valid_phrases_for_every_word_count_and_wordlist() {
        use MnemonicWordCount::*;

        for language in [
            English,
            Japanese,
            Korean,
            SimplifiedChinese,
            TraditionalChinese,
            French,
            Italian,
            Spanish,
            Czech,
            Portuguese,
        ] {
            for (count, words) in [
                (Words12, 12),
                (Words15, 15),
                (Words18, 18),
                (Words21, 21),
                (Words24, 24),
            ] {
                let phrase = Bip39MnemonicGenerator
                    .generate_mnemonic(language, MnemonicGenerationSource::Random(count))
                    .unwrap();
                let parsed = ::bip39::Mnemonic::parse_in(
                    Bip39MnemonicGenerator::language(language),
                    phrase.to_phrase().as_str(),
                )
                .unwrap();
                assert_eq!(parsed.word_count(), words);
                let restored = Bip39MnemonicGenerator
                    .generate_mnemonic(
                        language,
                        MnemonicGenerationSource::Entropy(parsed.to_entropy().try_into().unwrap()),
                    )
                    .unwrap();
                assert!(restored.words() == phrase.words());
            }
        }
    }
}
