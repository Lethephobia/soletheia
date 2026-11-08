use crate::application::{
    account::AccountAddress,
    keypair::{AccountKeypair, DerivationPath, KeypairDeriver, KeypairDeriverError},
    mnemonic::{Mnemonic, MnemonicPassphrase},
};
use solana_keypair::{seed_derivable::keypair_from_seed_and_derivation_path, Signer};

pub struct SolanaKeypairDeriver;

impl SolanaKeypairDeriver {
    fn derive_seed(
        mnemonic: &Mnemonic,
        passphrase: &MnemonicPassphrase,
    ) -> Result<zeroize::Zeroizing<[u8; 64]>, KeypairDeriverError> {
        let phrase = ::bip39::Mnemonic::parse_in_normalized(
            crate::infrastructure::bip39::Bip39MnemonicGenerator::language(mnemonic.wordlist()),
            &mnemonic.to_phrase(),
        )
        .map_err(|_| KeypairDeriverError::DerivationFailed)?;
        Ok(zeroize::Zeroizing::new(phrase.to_seed(passphrase.value())))
    }
}

impl KeypairDeriver for SolanaKeypairDeriver {
    fn derive_keypair(
        &self,
        mnemonic: &Mnemonic,
        passphrase: &MnemonicPassphrase,
        derivation_path: &DerivationPath,
    ) -> Result<AccountKeypair, KeypairDeriverError> {
        let seed = Self::derive_seed(mnemonic, passphrase)?;
        let path =
            solana_derivation_path::DerivationPath::from_absolute_path_str(derivation_path.value())
                .map_err(|_| KeypairDeriverError::InvalidPath)?;
        let keypair = keypair_from_seed_and_derivation_path(seed.as_slice(), Some(path))
            .map_err(|_| KeypairDeriverError::DerivationFailed)?;

        Ok(AccountKeypair::from_derived_parts(
            AccountAddress::new(keypair.pubkey().to_bytes()),
            *keypair.secret_bytes(),
        ))
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::application::mnemonic::{
        MnemonicGenerationSource, MnemonicGenerator, MnemonicWordlist,
    };
    use crate::infrastructure::bip39::Bip39MnemonicGenerator;

    #[test]
    fn derives_the_same_addresses_as_solana_keygen() {
        // Public BIP-39 zero-entropy vector. Addresses from solana-keygen pubkey
        // with prompt://?key=0 or prompt://?key=0/0 and the indicated passphrase.
        let mnemonic = Bip39MnemonicGenerator
            .generate_mnemonic(
                MnemonicWordlist::English,
                MnemonicGenerationSource::Entropy(vec![0; 16].try_into().unwrap()),
            )
            .unwrap();
        for (path, passphrase, expected) in [
            (
                "m/44'/501'/0'",
                "",
                "GjJyeC1r2RgkuoCWMyPYkCWSGSGLcz266EaAkLA27AhL",
            ),
            (
                "m/44'/501'/0'/0'",
                "",
                "HAgk14JpMQLgt6rVgv7cBQFJWFto5Dqxi472uT3DKpqk",
            ),
            (
                "m/44'/501'/0'/0'",
                "TREZOR",
                "7zSmbu6gKkb6HB7UDPtHYjwCWuBHU1D4TpNZFm4sndQe",
            ),
        ] {
            let path = path.parse().unwrap();
            let keypair = SolanaKeypairDeriver
                .derive_keypair(
                    &mnemonic,
                    &MnemonicPassphrase::new(passphrase.into()),
                    &path,
                )
                .unwrap();
            assert_eq!(
                solana_keypair::Address::new_from_array(*keypair.address().value()).to_string(),
                expected
            );
        }
    }
}
