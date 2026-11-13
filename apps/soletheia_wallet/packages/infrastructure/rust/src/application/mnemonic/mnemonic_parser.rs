use super::{Mnemonic, MnemonicParserError};

pub trait MnemonicParser {
    fn parse(&self, phrase: &str) -> Result<Mnemonic, MnemonicParserError>;
}
