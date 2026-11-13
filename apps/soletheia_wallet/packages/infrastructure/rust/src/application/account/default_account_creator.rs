use super::CreatedAccount;
use super::{AccountCreator, AccountCreatorError};
use crate::application::{
    keypair::{DerivationPath, KeypairDeriver},
    mnemonic::{MnemonicGenerationSource, MnemonicGenerator, MnemonicPassphrase, MnemonicWordlist},
    storage::{KeypairStore, MnemonicStore},
};

pub struct DefaultAccountCreator<G, D, M, K> {
    generator: G,
    deriver: D,
    mnemonic_store: M,
    keypair_store: K,
}

impl<G, D, M, K> DefaultAccountCreator<G, D, M, K> {
    pub fn new(generator: G, deriver: D, mnemonic_store: M, keypair_store: K) -> Self {
        Self {
            generator,
            deriver,
            mnemonic_store,
            keypair_store,
        }
    }
}

impl<G: MnemonicGenerator, D: KeypairDeriver, M: MnemonicStore, K: KeypairStore> AccountCreator
    for DefaultAccountCreator<G, D, M, K>
{
    fn create(
        &self,
        wordlist: MnemonicWordlist,
        source: MnemonicGenerationSource,
        passphrase: &MnemonicPassphrase,
        derivation_path: &DerivationPath,
    ) -> Result<CreatedAccount, AccountCreatorError> {
        let mnemonic = self.generator.generate(wordlist, source)?;
        let keypair = self
            .deriver
            .derive(&mnemonic, passphrase, derivation_path)?;

        let id = self
            .mnemonic_store
            .save(&mnemonic)
            .map_err(AccountCreatorError::MnemonicStorage)?;

        if let Err(save) = self.keypair_store.save(&keypair) {
            if let Err(cleanup) = self.mnemonic_store.delete(id) {
                return Err(AccountCreatorError::MnemonicCleanup { id, save, cleanup });
            }
            return Err(AccountCreatorError::KeypairStorage(save));
        }

        Ok(CreatedAccount {
            address: keypair.address(),
            mnemonic_id: id,
        })
    }
}
