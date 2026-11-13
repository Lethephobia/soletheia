use super::{Mnemonic, MnemonicGenerationSource, MnemonicGeneratorError, MnemonicWordlist};

pub trait MnemonicGenerator {
    fn generate(
        &self,
        wordlist: MnemonicWordlist,
        source: MnemonicGenerationSource,
    ) -> Result<Mnemonic, MnemonicGeneratorError>;
}
