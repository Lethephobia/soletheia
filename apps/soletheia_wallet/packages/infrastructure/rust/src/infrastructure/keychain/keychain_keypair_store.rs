use super::keychain_item::KeychainItem;
use crate::application::{
    keypair::AccountKeypair,
    storage::{KeypairStore, KeypairStoreError},
};
use zeroize::Zeroizing;

pub struct KeychainKeypairStore;

impl KeychainKeypairStore {
    // Keep the original address namespace so an existing v1 record also blocks duplicates.
    const SERVICE: &str = "soletheia.wallet.account-secret";

    // v2: version followed by the 32 signing bytes.
    fn encode_keypair(keypair: &AccountKeypair) -> Zeroizing<Vec<u8>> {
        let mut data = Zeroizing::new(Vec::with_capacity(1 + keypair.secret_bytes().len()));
        data.push(2);
        data.extend_from_slice(keypair.secret_bytes());
        data
    }

    fn map_insert_error(error: security_framework::base::Error) -> KeypairStoreError {
        match error.code() {
            security_framework_sys::base::errSecDuplicateItem => KeypairStoreError::AlreadyExists,
            status => KeypairStoreError::Keychain(status),
        }
    }
}

impl KeypairStore for KeychainKeypairStore {
    fn delete_keypair(
        &self,
        address: crate::application::account::AccountAddress,
    ) -> Result<(), KeypairStoreError> {
        let account = solana_keypair::Address::new_from_array(*address.value()).to_string();
        KeychainItem::delete(Self::SERVICE, &account).map_err(KeypairStoreError::Keychain)
    }

    fn save_keypair(&self, keypair: &AccountKeypair) -> Result<(), KeypairStoreError> {
        let account =
            solana_keypair::Address::new_from_array(*keypair.address().value()).to_string();
        KeychainItem::insert(Self::SERVICE, &account, &Self::encode_keypair(keypair))
            .map_err(Self::map_insert_error)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::application::account::AccountAddress;
    use solana_keypair::{Keypair, Signer};

    impl AccountKeypair {
        fn test_keypair() -> AccountKeypair {
            let key = Keypair::new();
            AccountKeypair::from_derived_parts(
                AccountAddress::new(key.pubkey().to_bytes()),
                *key.secret_bytes(),
            )
        }
    }

    #[test]
    fn stores_only_the_version_and_signing_bytes() {
        let key = AccountKeypair::test_keypair();
        let record = KeychainKeypairStore::encode_keypair(&key);

        assert_eq!(record[0], 2);
        assert!(&record[1..] == key.secret_bytes());
    }

    #[test]
    #[ignore = "requires a signed test process with Keychain access"]
    fn keychain_preserves_original_key_on_duplicate() {
        use security_framework::passwords::{
            delete_generic_password_options, generic_password, PasswordOptions,
        };

        let key = AccountKeypair::test_keypair();
        let account = solana_keypair::Address::new_from_array(*key.address().value()).to_string();
        let options = || {
            let mut options =
                PasswordOptions::new_generic_password(KeychainKeypairStore::SERVICE, &account);
            options.use_protected_keychain();
            options
        };
        KeychainKeypairStore.save_keypair(&key).unwrap();
        let duplicate = KeychainKeypairStore.save_keypair(&key);
        let stored = generic_password(options()).map(Zeroizing::new);
        delete_generic_password_options(options()).unwrap();

        assert_eq!(duplicate, Err(KeypairStoreError::AlreadyExists));
        assert!(
            stored.unwrap().as_slice() == KeychainKeypairStore::encode_keypair(&key).as_slice()
        );
    }
}
