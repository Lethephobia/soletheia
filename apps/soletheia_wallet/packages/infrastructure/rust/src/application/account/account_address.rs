#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct AccountAddress {
    pub value: [u8; 32],
}

impl AccountAddress {
    #[flutter_rust_bridge::frb(ignore)]
    pub fn new(bytes: [u8; 32]) -> Self {
        Self { value: bytes }
    }

    #[flutter_rust_bridge::frb(ignore)]
    pub fn value(&self) -> &[u8; 32] {
        &self.value
    }
}
