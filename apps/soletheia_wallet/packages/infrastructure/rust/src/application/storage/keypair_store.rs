use super::KeypairStoreError;
use crate::application::keypair::AccountKeypair;

pub trait KeypairStore {
    /// Inserts by public address. A failed insert must leave existing entries intact.
    fn save_keypair(&self, keypair: &AccountKeypair) -> Result<(), KeypairStoreError>;
}
