use crate::application::storage::KeypairStoreError;

#[derive(Debug, PartialEq, Eq, thiserror::Error)]
pub enum PrivateKeyAccountKeyImporterError {
    #[error("invalid Solana keypair")]
    InvalidPrivateKey,
    #[error(transparent)]
    Store(#[from] KeypairStoreError),
    #[error("unsupported platform")]
    UnsupportedPlatform,
}
