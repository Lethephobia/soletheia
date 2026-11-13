use super::{MnemonicAccount, MnemonicAccountWriter};
use super::{MnemonicAccountCreator, MnemonicAccountCreatorError};
use crate::application::{
    keypair::{DerivationPath, KeypairDeriver},
    mnemonic::{MnemonicGenerationSource, MnemonicGenerator, MnemonicPassphrase, MnemonicWordlist},
    storage::{KeypairStore, MnemonicStore},
};

pub struct DefaultMnemonicAccountCreator<G, D, M, K> {
    generator: G,
    writer: MnemonicAccountWriter<D, M, K>,
}

impl<G, D, M, K> DefaultMnemonicAccountCreator<G, D, M, K> {
    pub fn new(generator: G, deriver: D, mnemonic_store: M, keypair_store: K) -> Self {
        Self {
            generator,
            writer: MnemonicAccountWriter::new(deriver, mnemonic_store, keypair_store),
        }
    }
}

impl<G: MnemonicGenerator, D: KeypairDeriver, M: MnemonicStore, K: KeypairStore>
    MnemonicAccountCreator for DefaultMnemonicAccountCreator<G, D, M, K>
{
    fn create(
        &self,
        wordlist: MnemonicWordlist,
        source: MnemonicGenerationSource,
        passphrase: &MnemonicPassphrase,
        derivation_path: &DerivationPath,
    ) -> Result<MnemonicAccount, MnemonicAccountCreatorError> {
        let mnemonic = self.generator.generate(wordlist, source)?;
        Ok(self.writer.save(&mnemonic, passphrase, derivation_path)?)
    }
}
