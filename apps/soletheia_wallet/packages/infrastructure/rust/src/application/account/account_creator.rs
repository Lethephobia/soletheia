use super::{AccountCreatorError, CreatedAccount};
use crate::application::{
    keypair::DerivationPath,
    mnemonic::{MnemonicGenerationSource, MnemonicPassphrase, MnemonicWordlist},
};

pub trait AccountCreator {
    /// Returns the address and mnemonic ID after both secrets have been saved.
    fn create_account(
        &self,
        wordlist: MnemonicWordlist,
        source: MnemonicGenerationSource,
        passphrase: &MnemonicPassphrase,
        derivation_path: &DerivationPath,
    ) -> Result<CreatedAccount, AccountCreatorError>;
}
