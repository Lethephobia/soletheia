use super::{MnemonicAccount, MnemonicAccountKeyWriterError};
use crate::application::{
    keypair::{DerivationPath, KeypairDeriver},
    mnemonic::{Mnemonic, MnemonicPassphrase},
    storage::{KeypairStore, MnemonicStore},
};

pub(super) struct MnemonicAccountKeyWriter<D, M, K> {
    deriver: D,
    mnemonic_store: M,
    keypair_store: K,
}

impl<D, M, K> MnemonicAccountKeyWriter<D, M, K> {
    pub(super) fn new(deriver: D, mnemonic_store: M, keypair_store: K) -> Self {
        Self {
            deriver,
            mnemonic_store,
            keypair_store,
        }
    }
}

impl<D: KeypairDeriver, M: MnemonicStore, K: KeypairStore> MnemonicAccountKeyWriter<D, M, K> {
    pub(super) fn save(
        &self,
        mnemonic: &Mnemonic,
        passphrase: &MnemonicPassphrase,
        derivation_path: &DerivationPath,
    ) -> Result<MnemonicAccount, MnemonicAccountKeyWriterError> {
        let keypair = self.deriver.derive(mnemonic, passphrase, derivation_path)?;

        let id = self
            .mnemonic_store
            .save(mnemonic)
            .map_err(MnemonicAccountKeyWriterError::MnemonicStorage)?;

        if let Err(save) = self.keypair_store.save(&keypair) {
            if let Err(cleanup) = self.mnemonic_store.delete(id) {
                return Err(MnemonicAccountKeyWriterError::MnemonicCleanup { id, save, cleanup });
            }
            return Err(MnemonicAccountKeyWriterError::KeypairStorage(save));
        }

        Ok(MnemonicAccount {
            address: keypair.address(),
            mnemonic_id: id,
        })
    }
}
