use zeroize::Zeroizing;

/// One word of a validated mnemonic, in its original spelling.
#[derive(PartialEq, Eq)]
pub struct MnemonicWord(Zeroizing<String>);

impl MnemonicWord {
    pub(crate) fn from_validated_word(word: &str) -> Self {
        Self(Zeroizing::new(word.to_owned()))
    }

    pub fn value(&self) -> &str {
        &self.0
    }
}
