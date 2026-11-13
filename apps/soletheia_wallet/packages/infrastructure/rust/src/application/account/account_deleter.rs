use super::{AccountAddress, AccountDeleterError};
use crate::application::storage::MnemonicId;

pub trait AccountDeleter {
    fn delete(
        &self,
        address: AccountAddress,
        unused_mnemonic: Option<MnemonicId>,
    ) -> Result<(), AccountDeleterError>;
}
