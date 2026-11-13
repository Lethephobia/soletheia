use crate::application::{
    account::{AccountCreatorError, CreatedAccount},
    keypair::DerivationPath,
    mnemonic::{MnemonicGenerationSource, MnemonicPassphrase, MnemonicWordlist},
};

pub fn create_account(
    wordlist: MnemonicWordlist,
    source: MnemonicGenerationSource,
    passphrase: MnemonicPassphrase,
    derivation_path: DerivationPath,
) -> Result<CreatedAccount, AccountCreatorError> {
    #[cfg(any(target_os = "ios", target_os = "macos"))]
    {
        use crate::application::account::{AccountCreator, DefaultAccountCreator};
        DefaultAccountCreator::default().create(wordlist, source, &passphrase, &derivation_path)
    }

    #[cfg(not(any(target_os = "ios", target_os = "macos")))]
    {
        let _ = (wordlist, source, passphrase, derivation_path);
        Err(AccountCreatorError::UnsupportedPlatform)
    }
}
