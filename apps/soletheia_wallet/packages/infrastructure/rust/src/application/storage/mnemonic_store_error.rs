#[derive(Debug, PartialEq, Eq, thiserror::Error)]
pub enum MnemonicStoreError {
    #[error("the secret already exists")]
    AlreadyExists,
    #[error("could not generate a mnemonic identifier")]
    IdentifierGeneration,
    #[error("Keychain failed with OSStatus {0}")]
    Keychain(i32),
}
