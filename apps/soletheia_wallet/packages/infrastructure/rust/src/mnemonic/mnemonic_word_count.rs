pub use bip39::WordCount as MnemonicWordCount;
use flutter_rust_bridge::frb;

#[frb(mirror(MnemonicWordCount))]
pub enum _MnemonicWordCount {
    Words12,
    Words15,
    Words18,
    Words21,
    Words24,
}
