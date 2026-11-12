use crate::application::{
    account::{AccountAddress, AccountDeleterError},
    storage::MnemonicId,
};

pub fn delete_account(
    address: AccountAddress,
    unused_mnemonic: Option<MnemonicId>,
) -> Result<(), AccountDeleterError> {
    #[cfg(any(target_os = "ios", target_os = "macos"))]
    {
        use crate::application::account::{AccountDeleter, DefaultAccountDeleter};
        DefaultAccountDeleter::default().delete_account(address, unused_mnemonic)
    }

    #[cfg(not(any(target_os = "ios", target_os = "macos")))]
    {
        let _ = (address, unused_mnemonic);
        Err(AccountDeleterError::UnsupportedPlatform)
    }
}
