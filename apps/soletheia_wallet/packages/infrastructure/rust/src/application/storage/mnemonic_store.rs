use super::{MnemonicId, MnemonicStoreError};
use crate::application::mnemonic::Mnemonic;

pub trait MnemonicStore {
    /// Inserts a new entry and returns its unique ID. Never reuses an existing entry.
    fn save_mnemonic(&self, mnemonic: &Mnemonic) -> Result<MnemonicId, MnemonicStoreError>;

    fn delete_mnemonic(&self, id: MnemonicId) -> Result<(), MnemonicStoreError>;
}
