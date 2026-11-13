use super::{AccountAddress, AccountKeyDeleter, AccountKeyDeleterError};
use crate::application::storage::{KeypairStore, MnemonicId, MnemonicStore};

pub struct DefaultAccountKeyDeleter<M, K> {
    mnemonic_store: M,
    keypair_store: K,
}

impl<M, K> DefaultAccountKeyDeleter<M, K> {
    pub fn new(mnemonic_store: M, keypair_store: K) -> Self {
        Self {
            mnemonic_store,
            keypair_store,
        }
    }
}

impl<M: MnemonicStore, K: KeypairStore> AccountKeyDeleter for DefaultAccountKeyDeleter<M, K> {
    fn delete(
        &self,
        address: AccountAddress,
        unused_mnemonic: Option<MnemonicId>,
    ) -> Result<(), AccountKeyDeleterError> {
        self.keypair_store
            .delete(address)
            .map_err(AccountKeyDeleterError::KeypairStorage)?;
        if let Some(id) = unused_mnemonic {
            self.mnemonic_store
                .delete(id)
                .map_err(AccountKeyDeleterError::MnemonicStorage)?;
        }
        Ok(())
    }
}
