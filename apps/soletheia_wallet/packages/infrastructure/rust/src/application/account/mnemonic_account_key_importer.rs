use super::{MnemonicAccount, MnemonicAccountKeyImporterError};
use crate::application::{keypair::DerivationPath, mnemonic::MnemonicPassphrase};

pub trait MnemonicAccountKeyImporter {
    fn import(
        &self,
        phrase: &str,
        passphrase: &MnemonicPassphrase,
        derivation_path: &DerivationPath,
    ) -> Result<MnemonicAccount, MnemonicAccountKeyImporterError>;
}
