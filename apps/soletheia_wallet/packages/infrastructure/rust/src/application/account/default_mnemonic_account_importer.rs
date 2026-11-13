use super::{MnemonicAccount, MnemonicAccountWriter};
use super::{MnemonicAccountImporter, MnemonicAccountImporterError};
use crate::application::{
    keypair::{DerivationPath, KeypairDeriver},
    mnemonic::{MnemonicParser, MnemonicPassphrase},
    storage::{KeypairStore, MnemonicStore},
};

pub struct DefaultMnemonicAccountImporter<P, D, M, K> {
    parser: P,
    writer: MnemonicAccountWriter<D, M, K>,
}

impl<P, D, M, K> DefaultMnemonicAccountImporter<P, D, M, K> {
    pub fn new(parser: P, deriver: D, mnemonic_store: M, keypair_store: K) -> Self {
        Self {
            parser,
            writer: MnemonicAccountWriter::new(deriver, mnemonic_store, keypair_store),
        }
    }
}

impl<P: MnemonicParser, D: KeypairDeriver, M: MnemonicStore, K: KeypairStore>
    MnemonicAccountImporter for DefaultMnemonicAccountImporter<P, D, M, K>
{
    fn import(
        &self,
        phrase: &str,
        passphrase: &MnemonicPassphrase,
        derivation_path: &DerivationPath,
    ) -> Result<MnemonicAccount, MnemonicAccountImporterError> {
        let mnemonic = self.parser.parse(phrase)?;
        Ok(self.writer.save(&mnemonic, passphrase, derivation_path)?)
    }
}
