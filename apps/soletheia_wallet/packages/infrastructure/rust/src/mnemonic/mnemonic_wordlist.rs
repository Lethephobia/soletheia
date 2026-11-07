pub use bip39::Language as MnemonicWordlist;
use flutter_rust_bridge::frb;

#[frb(mirror(MnemonicWordlist))]
pub enum _MnemonicWordlist {
    English,
    Japanese,
    Korean,
    SimplifiedChinese,
    TraditionalChinese,
    French,
    Italian,
    Spanish,
    Czech,
    Portuguese,
}
