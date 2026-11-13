use zeroize::Zeroizing;

pub struct PrivateKey(Zeroizing<[u8; 32]>);

impl PrivateKey {
    pub fn new(value: [u8; 32]) -> Self {
        Self(Zeroizing::new(value))
    }

    pub fn value(&self) -> &[u8; 32] {
        &self.0
    }
}
