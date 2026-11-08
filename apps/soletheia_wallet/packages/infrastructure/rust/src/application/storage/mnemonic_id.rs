#[derive(Clone, Copy, Debug, Eq, PartialEq, Hash)]
pub struct MnemonicId {
    pub value: [u8; 16],
}

impl MnemonicId {
    #[flutter_rust_bridge::frb(ignore)]
    pub fn new(value: [u8; 16]) -> Self {
        Self { value }
    }

    #[flutter_rust_bridge::frb(ignore)]
    pub fn value(&self) -> &[u8; 16] {
        &self.value
    }
}
