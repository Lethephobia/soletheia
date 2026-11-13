use crate::application::storage::{KeypairStoreError, MnemonicStoreError};

#[derive(Debug, PartialEq, Eq, thiserror::Error)]
pub enum AccountKeyDeleterError {
    #[error("could not delete keypair: {0}")]
    KeypairStorage(#[source] KeypairStoreError),
    #[error("could not delete mnemonic: {0}")]
    MnemonicStorage(#[source] MnemonicStoreError),
    #[error("account deletion requires the Apple Keychain")]
    UnsupportedPlatform,
}
