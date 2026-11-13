use crate::application::{
    account::AccountAddress,
    keypair::{AccountKeypair, KeypairParser, KeypairParserError, PrivateKey},
};
use solana_keypair::{read_keypair, Keypair, Signer};

pub struct SolanaKeypairParser;

impl KeypairParser for SolanaKeypairParser {
    fn parse(&self, input: &str) -> Result<AccountKeypair, KeypairParserError> {
        let input = input.trim();
        let keypair = if input.starts_with('[') {
            read_keypair(&mut input.as_bytes()).map_err(|_| KeypairParserError::InvalidKeypair)?
        } else {
            Keypair::try_from_base58_string(input)
                .map_err(|_| KeypairParserError::InvalidKeypair)?
        };
        Ok(AccountKeypair::new(
            AccountAddress::new(keypair.pubkey().to_bytes()),
            PrivateKey::new(*keypair.secret_bytes()),
        ))
    }
}
