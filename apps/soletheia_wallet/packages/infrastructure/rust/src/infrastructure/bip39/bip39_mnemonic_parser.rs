use super::Bip39MnemonicGenerator;
use crate::application::mnemonic::{
    Mnemonic, MnemonicParser, MnemonicParserError, MnemonicWord, MnemonicWordlist,
};
use bip39::{Error, Mnemonic as Bip39Mnemonic};
use std::borrow::Cow;
use zeroize::Zeroizing;

pub struct Bip39MnemonicParser;

impl Bip39MnemonicParser {
    const WORDLISTS: [MnemonicWordlist; 10] = [
        MnemonicWordlist::English,
        MnemonicWordlist::Japanese,
        MnemonicWordlist::Korean,
        MnemonicWordlist::SimplifiedChinese,
        MnemonicWordlist::TraditionalChinese,
        MnemonicWordlist::French,
        MnemonicWordlist::Italian,
        MnemonicWordlist::Spanish,
        MnemonicWordlist::Czech,
        MnemonicWordlist::Portuguese,
    ];

    fn parse_normalized(phrase: &str) -> Result<Mnemonic, MnemonicParserError> {
        let mut error = MnemonicParserError::NoMatchingWordlist;
        for wordlist in Self::WORDLISTS {
            let language = Bip39MnemonicGenerator::language(wordlist);
            match Bip39Mnemonic::parse_in_normalized(language, phrase) {
                Ok(parsed) => {
                    let words = parsed
                        .words()
                        .map(MnemonicWord::from_validated_word)
                        .collect();
                    return Ok(Mnemonic::new(wordlist, words));
                }
                Err(Error::BadWordCount(actual)) => {
                    return Err(MnemonicParserError::InvalidWordCount { actual });
                }
                Err(Error::InvalidChecksum) => error = MnemonicParserError::InvalidChecksum,
                Err(Error::UnknownWord(_)) => continue,
                // Parsing with a fixed language and without an entropy input cannot produce these.
                Err(Error::AmbiguousLanguages(_) | Error::BadEntropyBitCount(_)) => unreachable!(),
            }
        }
        Err(error)
    }
}

impl MnemonicParser for Bip39MnemonicParser {
    fn parse(&self, phrase: &str) -> Result<Mnemonic, MnemonicParserError> {
        let mut normalized = Cow::Borrowed(phrase);
        Bip39Mnemonic::normalize_utf8_cow(&mut normalized);
        match normalized {
            Cow::Borrowed(text) => Self::parse_normalized(text),
            Cow::Owned(text) => Self::parse_normalized(&Zeroizing::new(text)),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parses_english_with_mixed_whitespace() {
        let phrase = format!("  {}\nabout\t", ["abandon"; 11].join("\t "));
        let mnemonic = Bip39MnemonicParser.parse(&phrase).unwrap();
        assert_eq!(mnemonic.wordlist(), MnemonicWordlist::English);
        assert!(mnemonic
            .words()
            .iter()
            .map(MnemonicWord::value)
            .eq(phrase.split_whitespace()));
    }

    #[test]
    fn normalizes_japanese_words_and_ideographic_spaces() {
        let phrase = format!("{}　あおぞら", ["あいこくしん"; 11].join("　"));
        let mnemonic = Bip39MnemonicParser.parse(&phrase).unwrap();
        assert_eq!(mnemonic.wordlist(), MnemonicWordlist::Japanese);
        assert_eq!(mnemonic.words()[11].value(), "あおぞら");
    }

    #[test]
    fn accepts_a_phrase_valid_in_both_chinese_wordlists() {
        let phrase = format!("{} 在", ["的"; 11].join(" "));
        let mnemonic = Bip39MnemonicParser.parse(&phrase).unwrap();
        assert!(matches!(
            mnemonic.wordlist(),
            MnemonicWordlist::SimplifiedChinese | MnemonicWordlist::TraditionalChinese
        ));
        assert_eq!(mnemonic.to_phrase().as_str(), phrase);
    }

    #[test]
    fn tries_the_next_wordlist_after_a_checksum_failure() {
        let mnemonic = Bip39MnemonicParser.parse(&["canal"; 12].join(" ")).unwrap();
        assert_eq!(mnemonic.wordlist(), MnemonicWordlist::French);
    }

    #[test]
    fn distinguishes_word_count_wordlist_and_checksum_errors() {
        for (phrase, expected) in [
            (
                String::new(),
                MnemonicParserError::InvalidWordCount { actual: 0 },
            ),
            (
                ["unknownword"; 11].join(" "),
                MnemonicParserError::InvalidWordCount { actual: 11 },
            ),
            (
                ["unknownword"; 12].join(" "),
                MnemonicParserError::NoMatchingWordlist,
            ),
            (["的"; 12].join(" "), MnemonicParserError::InvalidChecksum),
        ] {
            assert_eq!(Bip39MnemonicParser.parse(&phrase).err(), Some(expected));
        }
    }
}
