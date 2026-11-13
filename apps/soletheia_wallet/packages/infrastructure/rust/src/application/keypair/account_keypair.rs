use super::PrivateKey;
use crate::application::account::AccountAddress;

pub struct AccountKeypair {
    address: AccountAddress,
    private_key: PrivateKey,
}

impl AccountKeypair {
    pub(crate) fn new(address: AccountAddress, private_key: PrivateKey) -> Self {
        Self {
            address,
            private_key,
        }
    }

    pub fn address(&self) -> AccountAddress {
        self.address
    }

    pub fn private_key(&self) -> &PrivateKey {
        &self.private_key
    }
}
