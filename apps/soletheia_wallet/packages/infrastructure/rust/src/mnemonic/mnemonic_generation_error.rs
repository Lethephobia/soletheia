#[derive(Debug, thiserror::Error)]
pub(super) enum MnemonicGenerationError {
    #[error("invalid entropy length: {actual_bytes} bytes")]
    InvalidEntropyLength { actual_bytes: usize },
    #[error("could not obtain randomness from the operating system")]
    Randomness(#[from] getrandom::Error),
}
