use super::AccountAddress;
use crate::application::storage::MnemonicId;

#[derive(Debug, PartialEq, Eq)]
pub struct CreatedAccount {
    pub address: AccountAddress,
    pub mnemonic_id: MnemonicId,
}
