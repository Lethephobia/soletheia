use super::{AccountKeypair, KeypairParserError};

pub trait KeypairParser {
    fn parse(&self, input: &str) -> Result<AccountKeypair, KeypairParserError>;
}
