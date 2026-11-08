use crate::application::account::AccountAddress;
use zeroize::Zeroizing;

pub struct AccountKeypair {
    address: AccountAddress,
    secret: Zeroizing<[u8; 32]>,
}

impl AccountKeypair {
    pub(crate) fn from_derived_parts(address: AccountAddress, secret: [u8; 32]) -> Self {
        Self {
            address,
            secret: Zeroizing::new(secret),
        }
    }

    pub fn address(&self) -> AccountAddress {
        self.address
    }

    pub fn secret_bytes(&self) -> &[u8; 32] {
        &self.secret
    }
}
