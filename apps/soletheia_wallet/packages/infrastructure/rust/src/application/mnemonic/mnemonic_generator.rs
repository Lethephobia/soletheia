use super::{Mnemonic, MnemonicGenerationSource, MnemonicGeneratorError, MnemonicWordlist};

pub trait MnemonicGenerator {
    fn generate_mnemonic(
        &self,
        wordlist: MnemonicWordlist,
        source: MnemonicGenerationSource,
    ) -> Result<Mnemonic, MnemonicGeneratorError>;
}
