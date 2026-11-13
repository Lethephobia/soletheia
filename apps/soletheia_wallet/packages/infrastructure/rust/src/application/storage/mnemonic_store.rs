use super::{MnemonicId, MnemonicStoreError};
use crate::application::mnemonic::Mnemonic;

pub trait MnemonicStore {
    /// Inserts a new entry and returns its unique ID. Never reuses an existing entry.
    fn save(&self, mnemonic: &Mnemonic) -> Result<MnemonicId, MnemonicStoreError>;

    fn delete(&self, id: MnemonicId) -> Result<(), MnemonicStoreError>;
}
