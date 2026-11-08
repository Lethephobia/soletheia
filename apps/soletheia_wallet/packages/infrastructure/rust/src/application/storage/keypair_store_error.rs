#[derive(Debug, PartialEq, Eq, thiserror::Error)]
pub enum KeypairStoreError {
    #[error("the secret already exists")]
    AlreadyExists,
    #[error("Keychain failed with OSStatus {0}")]
    Keychain(i32),
}
