use crate::application::{
    account::{MnemonicAccount, MnemonicAccountKeyCreatorError},
    keypair::DerivationPath,
    mnemonic::{MnemonicGenerationSource, MnemonicPassphrase, MnemonicWordlist},
};

pub fn create_mnemonic_account_keys(
    wordlist: MnemonicWordlist,
    source: MnemonicGenerationSource,
    passphrase: MnemonicPassphrase,
    derivation_path: DerivationPath,
) -> Result<MnemonicAccount, MnemonicAccountKeyCreatorError> {
    #[cfg(any(target_os = "ios", target_os = "macos"))]
    {
        use crate::application::account::{
            DefaultMnemonicAccountKeyCreator, MnemonicAccountKeyCreator,
        };
        DefaultMnemonicAccountKeyCreator::default().create(
            wordlist,
            source,
            &passphrase,
            &derivation_path,
        )
    }

    #[cfg(not(any(target_os = "ios", target_os = "macos")))]
    {
        let _ = (wordlist, source, passphrase, derivation_path);
        Err(MnemonicAccountKeyCreatorError::UnsupportedPlatform)
    }
}
