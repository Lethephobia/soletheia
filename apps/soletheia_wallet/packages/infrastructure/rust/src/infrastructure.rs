pub mod bip39;
#[cfg(any(target_os = "macos", target_os = "ios"))]
pub mod keychain;
pub mod solana;

#[cfg(any(target_os = "ios", target_os = "macos"))]
impl Default
    for crate::application::account::DefaultAccountCreator<
        crate::infrastructure::bip39::Bip39MnemonicGenerator,
        crate::infrastructure::solana::SolanaKeypairDeriver,
        crate::infrastructure::keychain::KeychainMnemonicStore,
        crate::infrastructure::keychain::KeychainKeypairStore,
    >
{
    fn default() -> Self {
        Self::new(
            crate::infrastructure::bip39::Bip39MnemonicGenerator,
            crate::infrastructure::solana::SolanaKeypairDeriver,
            crate::infrastructure::keychain::KeychainMnemonicStore,
            crate::infrastructure::keychain::KeychainKeypairStore,
        )
    }
}

#[cfg(any(target_os = "ios", target_os = "macos"))]
impl Default
    for crate::application::account::DefaultAccountDeleter<
        keychain::KeychainMnemonicStore,
        keychain::KeychainKeypairStore,
    >
{
    fn default() -> Self {
        Self::new(
            keychain::KeychainMnemonicStore,
            keychain::KeychainKeypairStore,
        )
    }
}

#[cfg(test)]
mod tests {
    use crate::application::keypair::KeypairDeriverError;
    use crate::application::{
        account::{
            AccountAddress, AccountCreator, AccountCreatorError, CreatedAccount,
            DefaultAccountCreator,
        },
        keypair::{AccountKeypair, DerivationPath, KeypairDeriver},
        mnemonic::{Mnemonic, MnemonicGenerationSource, MnemonicPassphrase, MnemonicWordlist},
        storage::{KeypairStore, KeypairStoreError, MnemonicId, MnemonicStore, MnemonicStoreError},
    };
    use crate::infrastructure::{bip39::Bip39MnemonicGenerator, solana::SolanaKeypairDeriver};
    use std::cell::{Cell, RefCell};
    use std::collections::HashSet;

    #[derive(Default)]
    struct TestMnemonics {
        entries: RefCell<HashSet<MnemonicId>>,
        next: Cell<u8>,
        fail_delete: bool,
    }

    impl MnemonicStore for &TestMnemonics {
        fn save_mnemonic(&self, mnemonic: &Mnemonic) -> Result<MnemonicId, MnemonicStoreError> {
            assert!(mnemonic.words().last().unwrap().value() == "about");
            let id = MnemonicId {
                value: [self.next.get(); 16],
            };
            self.next.set(self.next.get() + 1);
            if self.entries.borrow_mut().insert(id) {
                Ok(id)
            } else {
                Err(MnemonicStoreError::AlreadyExists)
            }
        }

        fn delete_mnemonic(&self, id: MnemonicId) -> Result<(), MnemonicStoreError> {
            if self.fail_delete {
                return Err(MnemonicStoreError::Keychain(-1));
            }
            assert!(self.entries.borrow_mut().remove(&id));
            Ok(())
        }
    }

    struct TestKeys<F>(F);

    impl<F: Fn(&AccountKeypair) -> Result<(), KeypairStoreError>> KeypairStore for TestKeys<F> {
        fn delete_keypair(&self, _: AccountAddress) -> Result<(), KeypairStoreError> {
            panic!("unexpected delete")
        }
        fn save_keypair(&self, keypair: &AccountKeypair) -> Result<(), KeypairStoreError> {
            (self.0)(keypair)
        }
    }

    struct UnexpectedStorage;

    impl MnemonicStore for UnexpectedStorage {
        fn save_mnemonic(&self, _: &Mnemonic) -> Result<MnemonicId, MnemonicStoreError> {
            panic!("unexpected save")
        }
        fn delete_mnemonic(&self, _: MnemonicId) -> Result<(), MnemonicStoreError> {
            panic!("unexpected delete")
        }
    }

    impl KeypairStore for UnexpectedStorage {
        fn delete_keypair(&self, _: AccountAddress) -> Result<(), KeypairStoreError> {
            panic!("unexpected delete")
        }
        fn save_keypair(&self, _: &AccountKeypair) -> Result<(), KeypairStoreError> {
            panic!("unexpected save")
        }
    }

    impl<G, D, M, K> DefaultAccountCreator<G, D, M, K>
    where
        Self: AccountCreator,
    {
        fn create_test_account(&self) -> Result<CreatedAccount, AccountCreatorError> {
            self.create_account(
                MnemonicWordlist::English,
                MnemonicGenerationSource::Entropy(vec![0; 16].try_into().unwrap()),
                &MnemonicPassphrase::new("TREZOR".into()),
                &"m/44'/501'/0'/0'".parse()?,
            )
        }
    }

    #[test]
    fn returns_the_saved_address_and_propagates_duplicate_errors() {
        let mnemonics = TestMnemonics::default();
        let saved = Cell::new(None);
        let keys = TestKeys(|keypair: &AccountKeypair| {
            if saved.get().is_some() {
                return Err(KeypairStoreError::AlreadyExists);
            }
            saved.set(Some(keypair.address()));
            Ok(())
        });
        let creator = DefaultAccountCreator::new(
            Bip39MnemonicGenerator,
            SolanaKeypairDeriver,
            &mnemonics,
            keys,
        );
        let CreatedAccount {
            address,
            mnemonic_id,
        } = creator.create_test_account().unwrap();
        assert_eq!(
            solana_keypair::Address::new_from_array(*address.value()).to_string(),
            "7zSmbu6gKkb6HB7UDPtHYjwCWuBHU1D4TpNZFm4sndQe"
        );
        let original = mnemonics.entries.borrow().clone();
        assert_eq!(original, HashSet::from([mnemonic_id]));
        assert_eq!(saved.get(), Some(address));
        assert!(matches!(
            creator.create_test_account(),
            Err(AccountCreatorError::KeypairStorage(
                KeypairStoreError::AlreadyExists
            ))
        ));
        assert_eq!(*mnemonics.entries.borrow(), original);
        assert_eq!(saved.get(), Some(address));
    }

    #[test]
    fn mnemonic_insert_failure_preserves_existing_entry_and_skips_keypair_save() {
        let mnemonics = TestMnemonics::default();
        let existing = MnemonicId { value: [0; 16] };
        mnemonics.entries.borrow_mut().insert(existing);
        let creator = DefaultAccountCreator::new(
            Bip39MnemonicGenerator,
            SolanaKeypairDeriver,
            &mnemonics,
            UnexpectedStorage,
        );
        assert!(matches!(
            creator.create_test_account(),
            Err(AccountCreatorError::MnemonicStorage(
                MnemonicStoreError::AlreadyExists
            ))
        ));
        assert_eq!(*mnemonics.entries.borrow(), HashSet::from([existing]));
    }

    #[test]
    fn cleanup_failure_reports_both_errors_and_the_mnemonic_id() {
        let mnemonics = TestMnemonics {
            fail_delete: true,
            ..Default::default()
        };
        let keys = TestKeys(|_: &AccountKeypair| Err(KeypairStoreError::AlreadyExists));
        let creator = DefaultAccountCreator::new(
            Bip39MnemonicGenerator,
            SolanaKeypairDeriver,
            &mnemonics,
            keys,
        );
        let error = creator.create_test_account().unwrap_err();
        assert!(
            matches!(error, AccountCreatorError::MnemonicCleanup { id, save: KeypairStoreError::AlreadyExists, cleanup: MnemonicStoreError::Keychain(-1) } if mnemonics.entries.borrow().contains(&id))
        );
    }

    #[test]
    fn generation_errors_stop_creation_before_storage() {
        use crate::application::mnemonic::{MnemonicGenerator, MnemonicGeneratorError};

        struct FailingGenerator;

        impl MnemonicGenerator for FailingGenerator {
            fn generate_mnemonic(
                &self,
                _: MnemonicWordlist,
                _: MnemonicGenerationSource,
            ) -> Result<Mnemonic, MnemonicGeneratorError> {
                Err(MnemonicGeneratorError::Randomness)
            }
        }
        let creator = DefaultAccountCreator::new(
            FailingGenerator,
            SolanaKeypairDeriver,
            UnexpectedStorage,
            UnexpectedStorage,
        );
        assert!(matches!(
            creator.create_test_account(),
            Err(AccountCreatorError::MnemonicGeneration(
                MnemonicGeneratorError::Randomness
            ))
        ));
    }

    #[test]
    fn derivation_errors_stop_creation_before_storage() {
        struct FailingDeriver;

        impl KeypairDeriver for FailingDeriver {
            fn derive_keypair(
                &self,
                _: &Mnemonic,
                _: &MnemonicPassphrase,
                _: &DerivationPath,
            ) -> Result<AccountKeypair, KeypairDeriverError> {
                Err(KeypairDeriverError::DerivationFailed)
            }
        }
        let creator = DefaultAccountCreator::new(
            Bip39MnemonicGenerator,
            FailingDeriver,
            UnexpectedStorage,
            UnexpectedStorage,
        );
        assert!(matches!(
            creator.create_test_account(),
            Err(AccountCreatorError::KeypairDerivation(
                KeypairDeriverError::DerivationFailed
            ))
        ));
    }
}
