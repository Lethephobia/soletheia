use super::{MnemonicEntropy, MnemonicWordCount};

#[flutter_rust_bridge::frb(non_opaque)]
pub enum MnemonicGenerationSource {
    Random(MnemonicWordCount),
    Entropy(MnemonicEntropy),
}
