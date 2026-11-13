use super::{AccountAddress, AccountKeyDeleterError};
use crate::application::storage::MnemonicId;

pub trait AccountKeyDeleter {
    fn delete(
        &self,
        address: AccountAddress,
        unused_mnemonic: Option<MnemonicId>,
    ) -> Result<(), AccountKeyDeleterError>;
}
