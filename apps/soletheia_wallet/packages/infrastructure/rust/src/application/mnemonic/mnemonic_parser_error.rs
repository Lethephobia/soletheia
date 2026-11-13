#[derive(Debug, PartialEq, Eq, thiserror::Error)]
pub enum MnemonicParserError {
    #[error("invalid mnemonic word count: {actual}")]
    InvalidWordCount { actual: usize },
    #[error("no supported wordlist contains all mnemonic words")]
    NoMatchingWordlist,
    #[error("invalid mnemonic checksum")]
    InvalidChecksum,
}
