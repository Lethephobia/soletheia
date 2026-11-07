//! BIP-39 mnemonic generation for the Soletheia wallet.

mod generate_seed_phrase;
mod seed_phrase_generation_error;
mod seed_phrase_generation_source;

pub use bip39::{
    Language as SeedPhraseWordlist, Mnemonic as SeedPhrase, WordCount as SeedPhraseWordCount,
};
pub use generate_seed_phrase::generate_seed_phrase;
pub use seed_phrase_generation_error::SeedPhraseGenerationError;
pub use seed_phrase_generation_source::SeedPhraseGenerationSource;
