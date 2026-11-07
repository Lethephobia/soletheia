use super::MnemonicWordCount;

pub enum MnemonicGenerationSource {
    Random(MnemonicWordCount),
    Entropy(Vec<u8>),
}
