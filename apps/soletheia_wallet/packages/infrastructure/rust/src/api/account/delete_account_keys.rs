use crate::application::{
    account::{AccountAddress, AccountKeyDeleterError},
    storage::MnemonicId,
};

pub fn delete_account_keys(
    address: AccountAddress,
    unused_mnemonic: Option<MnemonicId>,
) -> Result<(), AccountKeyDeleterError> {
    #[cfg(any(target_os = "ios", target_os = "macos"))]
    {
        use crate::application::account::{AccountKeyDeleter, DefaultAccountKeyDeleter};
        DefaultAccountKeyDeleter::default().delete(address, unused_mnemonic)
    }

    #[cfg(not(any(target_os = "ios", target_os = "macos")))]
    {
        let _ = (address, unused_mnemonic);
        Err(AccountKeyDeleterError::UnsupportedPlatform)
    }
}
