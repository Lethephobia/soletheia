use super::{AccountAddress, AccountDeleterError};
use crate::application::storage::MnemonicId;

pub trait AccountDeleter {
    fn delete_account(
        &self,
        address: AccountAddress,
        unused_mnemonic: Option<MnemonicId>,
    ) -> Result<(), AccountDeleterError>;
}
