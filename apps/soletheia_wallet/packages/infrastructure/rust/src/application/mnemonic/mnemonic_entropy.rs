use super::MnemonicGeneratorError;
use zeroize::Zeroizing;

#[flutter_rust_bridge::frb(opaque)]
pub struct MnemonicEntropy(Zeroizing<Vec<u8>>);

impl TryFrom<Vec<u8>> for MnemonicEntropy {
    type Error = MnemonicGeneratorError;

    fn try_from(bytes: Vec<u8>) -> Result<Self, Self::Error> {
        let bytes = Zeroizing::new(bytes);
        match bytes.len() {
            16 | 20 | 24 | 28 | 32 => Ok(Self(bytes)),
            actual_bytes => Err(MnemonicGeneratorError::InvalidEntropyLength { actual_bytes }),
        }
    }
}

impl MnemonicEntropy {
    #[flutter_rust_bridge::frb(sync)]
    pub fn new(bytes: Vec<u8>) -> Result<Self, MnemonicGeneratorError> {
        bytes.try_into()
    }

    #[flutter_rust_bridge::frb(ignore)]
    pub fn value(&self) -> &[u8] {
        &self.0
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn accepts_only_supported_entropy_sizes() {
        for size in 0..=36 {
            let entropy = MnemonicEntropy::try_from(vec![0; size]);
            if [16, 20, 24, 28, 32].contains(&size) {
                assert_eq!(entropy.unwrap().value().len(), size);
            } else {
                assert!(
                    matches!(entropy, Err(MnemonicGeneratorError::InvalidEntropyLength { actual_bytes }) if actual_bytes == size)
                );
            }
        }
    }
}
