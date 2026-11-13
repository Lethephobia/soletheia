use crate::application::{
    account::{AccountAddress, PrivateKeyAccountKeyImporter, PrivateKeyAccountKeyImporterError},
    keypair::AccountKeypair,
    storage::KeypairStore,
};
use solana_keypair::{read_keypair, Keypair, Signer};

pub struct SolanaPrivateKeyAccountKeyImporter<S> {
    keypair_store: S,
}

impl<S> SolanaPrivateKeyAccountKeyImporter<S> {
    pub fn new(keypair_store: S) -> Self {
        Self { keypair_store }
    }
}

impl<S: KeypairStore> PrivateKeyAccountKeyImporter for SolanaPrivateKeyAccountKeyImporter<S> {
    fn import(
        &self,
        private_key: &str,
    ) -> Result<AccountAddress, PrivateKeyAccountKeyImporterError> {
        let input = private_key.trim();
        let keypair = if input.starts_with('[') {
            read_keypair(&mut input.as_bytes())
                .map_err(|_| PrivateKeyAccountKeyImporterError::InvalidPrivateKey)?
        } else {
            Keypair::try_from_base58_string(input)
                .map_err(|_| PrivateKeyAccountKeyImporterError::InvalidPrivateKey)?
        };
        let address = AccountAddress::new(keypair.pubkey().to_bytes());
        self.keypair_store
            .save(&AccountKeypair::from_derived_parts(
                address,
                *keypair.secret_bytes(),
            ))?;
        Ok(address)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::application::storage::KeypairStoreError;
    use std::cell::Cell;

    #[derive(Default)]
    struct Store {
        address: Cell<Option<AccountAddress>>,
    }

    impl KeypairStore for Store {
        fn save(&self, keypair: &AccountKeypair) -> Result<(), KeypairStoreError> {
            if self.address.get().is_some() {
                return Err(KeypairStoreError::AlreadyExists);
            }
            assert_eq!(
                Keypair::new_from_array(*keypair.secret_bytes())
                    .pubkey()
                    .to_bytes(),
                *keypair.address().value()
            );
            self.address.set(Some(keypair.address()));
            Ok(())
        }

        fn delete(&self, _: AccountAddress) -> Result<(), KeypairStoreError> {
            unreachable!()
        }
    }

    #[test]
    fn imports_base58_and_cli_keypairs_without_overwriting_existing_keys() {
        let key = Keypair::new();
        let address = AccountAddress::new(key.pubkey().to_bytes());
        for input in [key.to_base58_string(), format!("{:?}", key.to_bytes())] {
            let importer = SolanaPrivateKeyAccountKeyImporter::new(Store::default());
            assert_eq!(importer.import(&input), Ok(address));
            assert_eq!(importer.keypair_store.address.get(), Some(address));
            assert_eq!(
                importer.import(&input),
                Err(KeypairStoreError::AlreadyExists.into())
            );
        }
    }

    #[test]
    fn rejects_public_addresses_and_inconsistent_keypairs_before_saving() {
        let importer = SolanaPrivateKeyAccountKeyImporter::new(Store::default());
        let key = Keypair::new();
        let mut bytes = key.to_bytes();
        bytes[63] ^= 1;
        for input in [
            key.pubkey().to_string(),
            format!("{bytes:?}"),
            "[256]".into(),
            String::new(),
        ] {
            assert_eq!(
                importer.import(&input),
                Err(PrivateKeyAccountKeyImporterError::InvalidPrivateKey)
            );
        }
        assert!(importer.keypair_store.address.get().is_none());
    }
}
