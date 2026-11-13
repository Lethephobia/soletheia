use super::AccountAddress;
use crate::application::storage::MnemonicId;

#[derive(Debug, PartialEq, Eq)]
pub struct MnemonicAccount {
    pub address: AccountAddress,
    pub mnemonic_id: MnemonicId,
}
