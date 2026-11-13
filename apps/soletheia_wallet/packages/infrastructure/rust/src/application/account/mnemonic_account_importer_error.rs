use super::MnemonicAccountWriterError;
use crate::application::mnemonic::MnemonicParserError;

#[derive(Debug, thiserror::Error)]
pub enum MnemonicAccountImporterError {
    #[error(transparent)]
    MnemonicParsing(#[from] MnemonicParserError),
    #[error(transparent)]
    AccountWrite(#[from] MnemonicAccountWriterError),
}
