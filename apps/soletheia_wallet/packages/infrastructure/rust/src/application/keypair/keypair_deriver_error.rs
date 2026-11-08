#[derive(Debug, thiserror::Error)]
pub enum KeypairDeriverError {
    #[error("invalid Ed25519 derivation path")]
    InvalidPath,
    #[error("could not derive an Ed25519 keypair at the specified path")]
    DerivationFailed,
}
