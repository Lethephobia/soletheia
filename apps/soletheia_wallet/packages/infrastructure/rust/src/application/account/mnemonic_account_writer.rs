use super::{MnemonicAccount, MnemonicAccountWriterError};
use crate::application::{
    keypair::{DerivationPath, KeypairDeriver},
    mnemonic::{Mnemonic, MnemonicPassphrase},
    storage::{KeypairStore, MnemonicStore},
};

pub(super) struct MnemonicAccountWriter<D, M, K> {
    deriver: D,
    mnemonic_store: M,
    keypair_store: K,
}

impl<D, M, K> MnemonicAccountWriter<D, M, K> {
    pub(super) fn new(deriver: D, mnemonic_store: M, keypair_store: K) -> Self {
        Self {
            deriver,
            mnemonic_store,
            keypair_store,
        }
    }
}

impl<D: KeypairDeriver, M: MnemonicStore, K: KeypairStore> MnemonicAccountWriter<D, M, K> {
    pub(super) fn save(
        &self,
        mnemonic: &Mnemonic,
        passphrase: &MnemonicPassphrase,
        derivation_path: &DerivationPath,
    ) -> Result<MnemonicAccount, MnemonicAccountWriterError> {
        let keypair = self.deriver.derive(mnemonic, passphrase, derivation_path)?;

        let id = self
            .mnemonic_store
            .save(mnemonic)
            .map_err(MnemonicAccountWriterError::MnemonicStorage)?;

        if let Err(save) = self.keypair_store.save(&keypair) {
            if let Err(cleanup) = self.mnemonic_store.delete(id) {
                return Err(MnemonicAccountWriterError::MnemonicCleanup { id, save, cleanup });
            }
            return Err(MnemonicAccountWriterError::KeypairStorage(save));
        }

        Ok(MnemonicAccount {
            address: keypair.address(),
            mnemonic_id: id,
        })
    }
}
