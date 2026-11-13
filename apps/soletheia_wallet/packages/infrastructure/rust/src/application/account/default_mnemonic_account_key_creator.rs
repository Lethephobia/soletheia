use super::{MnemonicAccount, MnemonicAccountKeyWriter};
use super::{MnemonicAccountKeyCreator, MnemonicAccountKeyCreatorError};
use crate::application::{
    keypair::{DerivationPath, KeypairDeriver},
    mnemonic::{MnemonicGenerationSource, MnemonicGenerator, MnemonicPassphrase, MnemonicWordlist},
    storage::{KeypairStore, MnemonicStore},
};

pub struct DefaultMnemonicAccountKeyCreator<G, D, M, K> {
    generator: G,
    writer: MnemonicAccountKeyWriter<D, M, K>,
}

impl<G, D, M, K> DefaultMnemonicAccountKeyCreator<G, D, M, K> {
    pub fn new(generator: G, deriver: D, mnemonic_store: M, keypair_store: K) -> Self {
        Self {
            generator,
            writer: MnemonicAccountKeyWriter::new(deriver, mnemonic_store, keypair_store),
        }
    }
}

impl<G: MnemonicGenerator, D: KeypairDeriver, M: MnemonicStore, K: KeypairStore>
    MnemonicAccountKeyCreator for DefaultMnemonicAccountKeyCreator<G, D, M, K>
{
    fn create(
        &self,
        wordlist: MnemonicWordlist,
        source: MnemonicGenerationSource,
        passphrase: &MnemonicPassphrase,
        derivation_path: &DerivationPath,
    ) -> Result<MnemonicAccount, MnemonicAccountKeyCreatorError> {
        let mnemonic = self.generator.generate(wordlist, source)?;
        Ok(self.writer.save(&mnemonic, passphrase, derivation_path)?)
    }
}
