use super::{AccountKeypair, DerivationPath, KeypairDeriverError};
use crate::application::mnemonic::{Mnemonic, MnemonicPassphrase};

pub trait KeypairDeriver {
    fn derive(
        &self,
        mnemonic: &Mnemonic,
        passphrase: &MnemonicPassphrase,
        derivation_path: &DerivationPath,
    ) -> Result<AccountKeypair, KeypairDeriverError>;
}
