use super::KeypairDeriverError;

/// Absolute Ed25519 path. All components are hardened.
#[flutter_rust_bridge::frb(opaque)]
pub struct DerivationPath(String);

impl std::str::FromStr for DerivationPath {
    type Err = KeypairDeriverError;

    fn from_str(input: &str) -> Result<Self, Self::Err> {
        let mut parts = input.split('/');
        if parts.next() != Some("m") {
            return Err(KeypairDeriverError::InvalidPath);
        }
        let mut path = String::from("m");
        for part in parts {
            let digits = part.strip_suffix('\'').unwrap_or(part);
            let index = digits
                .parse::<u32>()
                .ok()
                .filter(|n| *n < (1 << 31) && digits.bytes().all(|b| b.is_ascii_digit()))
                .ok_or(KeypairDeriverError::InvalidPath)?;
            use std::fmt::Write;

            write!(path, "/{index}'").expect("writing to a String cannot fail");
        }
        Ok(Self(path))
    }
}

impl DerivationPath {
    #[flutter_rust_bridge::frb(sync)]
    pub fn parse(value: String) -> Result<Self, KeypairDeriverError> {
        value.parse()
    }

    #[flutter_rust_bridge::frb(ignore)]
    pub fn value(&self) -> &str {
        &self.0
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn normalizes_hardened_indices_and_rejects_out_of_range_components() {
        assert_eq!(
            "m/44/501/0'/2147483647"
                .parse::<DerivationPath>()
                .unwrap()
                .value(),
            "m/44'/501'/0'/2147483647'"
        );
        for path in ["0/0", "m/", "m/2147483648", "m/+1", "m/-1", "m/1''"] {
            assert!(matches!(
                path.parse::<DerivationPath>(),
                Err(KeypairDeriverError::InvalidPath)
            ));
        }
    }
}
