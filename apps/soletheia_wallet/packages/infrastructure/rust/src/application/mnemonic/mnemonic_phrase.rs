use super::{MnemonicWord, MnemonicWordlist};
use zeroize::Zeroizing;

/// A validated phrase, kept in its original wordlist.
pub struct Mnemonic {
    wordlist: MnemonicWordlist,
    words: Vec<MnemonicWord>,
}

impl Mnemonic {
    pub(crate) fn new(wordlist: MnemonicWordlist, words: Vec<MnemonicWord>) -> Self {
        Self { wordlist, words }
    }

    pub fn wordlist(&self) -> MnemonicWordlist {
        self.wordlist
    }

    pub fn words(&self) -> &[MnemonicWord] {
        &self.words
    }

    pub(crate) fn to_phrase(&self) -> Zeroizing<String> {
        let words: Vec<_> = self.words.iter().map(MnemonicWord::value).collect();
        Zeroizing::new(words.join(" "))
    }
}
