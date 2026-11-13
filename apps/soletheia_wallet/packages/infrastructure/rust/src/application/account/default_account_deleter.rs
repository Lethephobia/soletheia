use super::{AccountAddress, AccountDeleter, AccountDeleterError};
use crate::application::storage::{KeypairStore, MnemonicId, MnemonicStore};

pub struct DefaultAccountDeleter<M, K> {
    mnemonic_store: M,
    keypair_store: K,
}

impl<M, K> DefaultAccountDeleter<M, K> {
    pub fn new(mnemonic_store: M, keypair_store: K) -> Self {
        Self {
            mnemonic_store,
            keypair_store,
        }
    }
}

impl<M: MnemonicStore, K: KeypairStore> AccountDeleter for DefaultAccountDeleter<M, K> {
    fn delete(
        &self,
        address: AccountAddress,
        unused_mnemonic: Option<MnemonicId>,
    ) -> Result<(), AccountDeleterError> {
        self.keypair_store
            .delete_keypair(address)
            .map_err(AccountDeleterError::KeypairStorage)?;
        if let Some(id) = unused_mnemonic {
            self.mnemonic_store
                .delete_mnemonic(id)
                .map_err(AccountDeleterError::MnemonicStorage)?;
        }
        Ok(())
    }
}
