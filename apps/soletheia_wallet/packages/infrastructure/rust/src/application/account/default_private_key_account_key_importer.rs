use crate::application::{
    account::{AccountAddress, PrivateKeyAccountKeyImporter, PrivateKeyAccountKeyImporterError},
    keypair::KeypairParser,
    storage::KeypairStore,
};

pub struct DefaultPrivateKeyAccountKeyImporter<P, S> {
    keypair_parser: P,
    keypair_store: S,
}

impl<P, S> DefaultPrivateKeyAccountKeyImporter<P, S> {
    pub fn new(keypair_parser: P, keypair_store: S) -> Self {
        Self {
            keypair_parser,
            keypair_store,
        }
    }
}

impl<P: KeypairParser, S: KeypairStore> PrivateKeyAccountKeyImporter
    for DefaultPrivateKeyAccountKeyImporter<P, S>
{
    fn import(
        &self,
        private_key: &str,
    ) -> Result<AccountAddress, PrivateKeyAccountKeyImporterError> {
        let keypair = self
            .keypair_parser
            .parse(private_key)
            .map_err(|_| PrivateKeyAccountKeyImporterError::InvalidPrivateKey)?;
        self.keypair_store.save(&keypair)?;
        Ok(keypair.address())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::application::storage::KeypairStoreError;
    use crate::{
        application::keypair::AccountKeypair, infrastructure::solana::SolanaKeypairParser,
    };
    use solana_keypair::{Keypair, Signer};
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
                Keypair::new_from_array(*keypair.private_key().value())
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
            let importer =
                DefaultPrivateKeyAccountKeyImporter::new(SolanaKeypairParser, Store::default());
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
        let importer =
            DefaultPrivateKeyAccountKeyImporter::new(SolanaKeypairParser, Store::default());
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
