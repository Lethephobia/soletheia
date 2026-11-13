use super::KeypairStoreError;
use crate::application::account::AccountAddress;
use crate::application::keypair::AccountKeypair;

pub trait KeypairStore {
    /// Inserts by public address. A failed insert must leave existing entries intact.
    fn save(&self, keypair: &AccountKeypair) -> Result<(), KeypairStoreError>;

    /// Succeeds if the keypair is already absent.
    fn delete(&self, address: AccountAddress) -> Result<(), KeypairStoreError>;
}
