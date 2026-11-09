use uuid::Uuid;

#[derive(Clone, Copy, Debug, Eq, PartialEq, Hash)]
pub struct MnemonicId {
    pub value: [u8; 16],
}

impl MnemonicId {
    #[flutter_rust_bridge::frb(ignore)]
    pub fn new() -> Self {
        Self {
            value: Uuid::new_v4().into_bytes(),
        }
    }

    #[flutter_rust_bridge::frb(ignore)]
    pub fn value(&self) -> &[u8; 16] {
        &self.value
    }
}

#[flutter_rust_bridge::frb(ignore)]
impl Default for MnemonicId {
    fn default() -> Self {
        Self::new()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn generates_uuid_v4_mnemonic_ids() {
        let id = MnemonicId::new();
        let uuid = Uuid::from_bytes(*id.value());
        assert_eq!(uuid.get_version(), Some(uuid::Version::Random));
        assert_eq!(uuid.get_variant(), uuid::Variant::RFC4122);
    }
}
