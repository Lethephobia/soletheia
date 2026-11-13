#[derive(Debug, PartialEq, Eq, thiserror::Error)]
pub enum KeypairParserError {
    #[error("invalid Solana keypair")]
    InvalidKeypair,
}
