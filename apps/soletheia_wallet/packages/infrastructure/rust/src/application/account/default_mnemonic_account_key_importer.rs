use super::{MnemonicAccount, MnemonicAccountKeyWriter};
use super::{MnemonicAccountKeyImporter, MnemonicAccountKeyImporterError};
use crate::application::{
    keypair::{DerivationPath, KeypairDeriver},
    mnemonic::{MnemonicParser, MnemonicPassphrase},
    storage::{KeypairStore, MnemonicStore},
};

pub struct DefaultMnemonicAccountKeyImporter<P, D, M, K> {
    parser: P,
    writer: MnemonicAccountKeyWriter<D, M, K>,
}

impl<P, D, M, K> DefaultMnemonicAccountKeyImporter<P, D, M, K> {
    pub fn new(parser: P, deriver: D, mnemonic_store: M, keypair_store: K) -> Self {
        Self {
            parser,
            writer: MnemonicAccountKeyWriter::new(deriver, mnemonic_store, keypair_store),
        }
    }
}

impl<P: MnemonicParser, D: KeypairDeriver, M: MnemonicStore, K: KeypairStore>
    MnemonicAccountKeyImporter for DefaultMnemonicAccountKeyImporter<P, D, M, K>
{
    fn import(
        &self,
        phrase: &str,
        passphrase: &MnemonicPassphrase,
        derivation_path: &DerivationPath,
    ) -> Result<MnemonicAccount, MnemonicAccountKeyImporterError> {
        let mnemonic = self.parser.parse(phrase)?;
        Ok(self.writer.save(&mnemonic, passphrase, derivation_path)?)
    }
}
