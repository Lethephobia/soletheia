use crate::application::account::{AccountAddress, PrivateKeyAccountKeyImporterError};
use zeroize::Zeroizing;

pub fn import_private_key_account_keys(
    private_key: String,
) -> Result<AccountAddress, PrivateKeyAccountKeyImporterError> {
    let private_key = Zeroizing::new(private_key);
    #[cfg(any(target_os = "ios", target_os = "macos"))]
    {
        use crate::{
            application::account::{
                DefaultPrivateKeyAccountKeyImporter, PrivateKeyAccountKeyImporter,
            },
            infrastructure::{keychain::KeychainKeypairStore, solana::SolanaKeypairParser},
        };
        DefaultPrivateKeyAccountKeyImporter::new(SolanaKeypairParser, KeychainKeypairStore)
            .import(&private_key)
    }
    #[cfg(not(any(target_os = "ios", target_os = "macos")))]
    {
        let _ = private_key;
        Err(PrivateKeyAccountKeyImporterError::UnsupportedPlatform)
    }
}
