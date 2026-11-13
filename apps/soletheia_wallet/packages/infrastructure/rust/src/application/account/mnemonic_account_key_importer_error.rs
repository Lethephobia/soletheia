use super::MnemonicAccountKeyWriterError;
use crate::application::mnemonic::MnemonicParserError;

#[derive(Debug, thiserror::Error)]
pub enum MnemonicAccountKeyImporterError {
    #[error("account import requires Apple Keychain")]
    UnsupportedPlatform,
    #[error(transparent)]
    MnemonicParsing(#[from] MnemonicParserError),
    #[error(transparent)]
    AccountWrite(#[from] MnemonicAccountKeyWriterError),
}
