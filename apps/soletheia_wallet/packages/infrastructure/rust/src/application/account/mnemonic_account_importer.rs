use super::{MnemonicAccount, MnemonicAccountImporterError};
use crate::application::{keypair::DerivationPath, mnemonic::MnemonicPassphrase};

pub trait MnemonicAccountImporter {
    fn import(
        &self,
        phrase: &str,
        passphrase: &MnemonicPassphrase,
        derivation_path: &DerivationPath,
    ) -> Result<MnemonicAccount, MnemonicAccountImporterError>;
}
