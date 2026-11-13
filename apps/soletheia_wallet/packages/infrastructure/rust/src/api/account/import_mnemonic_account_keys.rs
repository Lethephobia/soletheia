use crate::application::{
    account::{MnemonicAccount, MnemonicAccountKeyImporterError},
    keypair::DerivationPath,
    mnemonic::MnemonicPassphrase,
};
use zeroize::Zeroizing;

pub fn import_mnemonic_account_keys(
    phrase: String,
    passphrase: MnemonicPassphrase,
    derivation_path: DerivationPath,
) -> Result<MnemonicAccount, MnemonicAccountKeyImporterError> {
    let phrase = Zeroizing::new(phrase);
    #[cfg(any(target_os = "ios", target_os = "macos"))]
    {
        use crate::application::account::{
            DefaultMnemonicAccountKeyImporter, MnemonicAccountKeyImporter,
        };
        DefaultMnemonicAccountKeyImporter::default().import(&phrase, &passphrase, &derivation_path)
    }

    #[cfg(not(any(target_os = "ios", target_os = "macos")))]
    {
        let _ = (phrase, passphrase, derivation_path);
        Err(MnemonicAccountKeyImporterError::UnsupportedPlatform)
    }
}
