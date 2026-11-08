use zeroize::Zeroizing;

#[derive(Default)]
#[flutter_rust_bridge::frb(opaque)]
pub struct MnemonicPassphrase(Zeroizing<String>);

impl MnemonicPassphrase {
    #[flutter_rust_bridge::frb(sync)]
    pub fn new(value: String) -> Self {
        Self(Zeroizing::new(value))
    }

    #[flutter_rust_bridge::frb(ignore)]
    pub fn value(&self) -> &str {
        &self.0
    }
}
