use crate::application::{
    keypair::KeypairDeriverError,
    mnemonic::MnemonicGeneratorError,
    storage::{KeypairStoreError, MnemonicId, MnemonicStoreError},
};

#[derive(Debug, thiserror::Error)]
pub enum MnemonicAccountKeyCreatorError {
    #[error("account creation requires Apple Keychain")]
    UnsupportedPlatform,
    #[error(transparent)]
    MnemonicGeneration(#[from] MnemonicGeneratorError),
    #[error(transparent)]
    KeypairDerivation(#[from] KeypairDeriverError),
    #[error("could not save mnemonic: {0}")]
    MnemonicStorage(#[source] MnemonicStoreError),
    #[error("could not save keypair: {0}")]
    KeypairStorage(#[source] KeypairStoreError),
    #[error("could not save keypair ({save}) or remove its new mnemonic ({cleanup})")]
    MnemonicCleanup {
        id: MnemonicId,
        save: KeypairStoreError,
        cleanup: MnemonicStoreError,
    },
}

impl From<super::MnemonicAccountKeyWriterError> for MnemonicAccountKeyCreatorError {
    fn from(error: super::MnemonicAccountKeyWriterError) -> Self {
        use super::MnemonicAccountKeyWriterError as E;
        match error {
            E::KeypairDerivation(error) => Self::KeypairDerivation(error),
            E::MnemonicStorage(error) => Self::MnemonicStorage(error),
            E::KeypairStorage(error) => Self::KeypairStorage(error),
            E::MnemonicCleanup { id, save, cleanup } => Self::MnemonicCleanup { id, save, cleanup },
        }
    }
}
