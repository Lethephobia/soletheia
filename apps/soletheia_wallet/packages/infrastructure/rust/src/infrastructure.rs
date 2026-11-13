pub mod bip39;
#[cfg(any(target_os = "macos", target_os = "ios"))]
pub mod keychain;
pub mod solana;

#[cfg(any(target_os = "ios", target_os = "macos"))]
impl Default
    for crate::application::account::DefaultMnemonicAccountCreator<
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
    for crate::application::account::DefaultMnemonicAccountImporter<
        crate::infrastructure::bip39::Bip39MnemonicParser,
        crate::infrastructure::solana::SolanaKeypairDeriver,
        crate::infrastructure::keychain::KeychainMnemonicStore,
        crate::infrastructure::keychain::KeychainKeypairStore,
    >
{
    fn default() -> Self {
        Self::new(
            crate::infrastructure::bip39::Bip39MnemonicParser,
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
            AccountAddress, DefaultMnemonicAccountCreator, MnemonicAccount, MnemonicAccountCreator,
            MnemonicAccountCreatorError,
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
        fn save(&self, mnemonic: &Mnemonic) -> Result<MnemonicId, MnemonicStoreError> {
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

        fn delete(&self, id: MnemonicId) -> Result<(), MnemonicStoreError> {
            if self.fail_delete {
                return Err(MnemonicStoreError::Keychain(-1));
            }
            assert!(self.entries.borrow_mut().remove(&id));
            Ok(())
        }
    }

    struct TestKeys<F>(F);

    impl<F: Fn(&AccountKeypair) -> Result<(), KeypairStoreError>> KeypairStore for TestKeys<F> {
        fn delete(&self, _: AccountAddress) -> Result<(), KeypairStoreError> {
            panic!("unexpected delete")
        }
        fn save(&self, keypair: &AccountKeypair) -> Result<(), KeypairStoreError> {
            (self.0)(keypair)
        }
    }

    struct UnexpectedStorage;

    impl MnemonicStore for UnexpectedStorage {
        fn save(&self, _: &Mnemonic) -> Result<MnemonicId, MnemonicStoreError> {
            panic!("unexpected save")
        }
        fn delete(&self, _: MnemonicId) -> Result<(), MnemonicStoreError> {
            panic!("unexpected delete")
        }
    }

    impl KeypairStore for UnexpectedStorage {
        fn delete(&self, _: AccountAddress) -> Result<(), KeypairStoreError> {
            panic!("unexpected delete")
        }
        fn save(&self, _: &AccountKeypair) -> Result<(), KeypairStoreError> {
            panic!("unexpected save")
        }
    }

    impl<G, D, M, K> DefaultMnemonicAccountCreator<G, D, M, K>
    where
        Self: MnemonicAccountCreator,
    {
        fn create_test_account(&self) -> Result<MnemonicAccount, MnemonicAccountCreatorError> {
            self.create(
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
        let creator = DefaultMnemonicAccountCreator::new(
            Bip39MnemonicGenerator,
            SolanaKeypairDeriver,
            &mnemonics,
            keys,
        );
        let MnemonicAccount {
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
            Err(MnemonicAccountCreatorError::KeypairStorage(
                KeypairStoreError::AlreadyExists
            ))
        ));
        assert_eq!(*mnemonics.entries.borrow(), original);
        assert_eq!(saved.get(), Some(address));
    }

    #[test]
    fn imports_the_expected_address_and_rolls_back_only_the_duplicate_mnemonic() {
        use crate::application::account::{
            DefaultMnemonicAccountImporter, MnemonicAccountImporter, MnemonicAccountImporterError,
            MnemonicAccountWriterError,
        };
        use crate::infrastructure::bip39::Bip39MnemonicParser;

        let phrase = format!("{} about", ["abandon"; 11].join(" "));
        let passphrase = MnemonicPassphrase::new("TREZOR".into());
        let path = "m/44'/501'/0'/0'".parse().unwrap();
        let mnemonics = TestMnemonics::default();
        let saved = Cell::new(None);
        let keys = TestKeys(|keypair: &AccountKeypair| {
            if saved.get().is_some() {
                return Err(KeypairStoreError::AlreadyExists);
            }
            saved.set(Some(keypair.address()));
            Ok(())
        });
        let importer = DefaultMnemonicAccountImporter::new(
            Bip39MnemonicParser,
            SolanaKeypairDeriver,
            &mnemonics,
            keys,
        );
        let account = importer.import(&phrase, &passphrase, &path).unwrap();
        assert_eq!(
            solana_keypair::Address::new_from_array(*account.address.value()).to_string(),
            "7zSmbu6gKkb6HB7UDPtHYjwCWuBHU1D4TpNZFm4sndQe"
        );
        assert!(matches!(
            importer.import(&phrase, &passphrase, &path),
            Err(MnemonicAccountImporterError::AccountWrite(
                MnemonicAccountWriterError::KeypairStorage(KeypairStoreError::AlreadyExists)
            ))
        ));
        assert_eq!(
            *mnemonics.entries.borrow(),
            HashSet::from([account.mnemonic_id])
        );
        assert_eq!(saved.get(), Some(account.address));
    }

    #[test]
    fn rejects_invalid_import_before_storage() {
        use crate::application::account::{
            DefaultMnemonicAccountImporter, MnemonicAccountImporter, MnemonicAccountImporterError,
        };
        use crate::application::mnemonic::MnemonicParserError;
        use crate::infrastructure::bip39::Bip39MnemonicParser;

        let importer = DefaultMnemonicAccountImporter::new(
            Bip39MnemonicParser,
            SolanaKeypairDeriver,
            UnexpectedStorage,
            UnexpectedStorage,
        );
        assert!(matches!(
            importer.import(
                &["abandon"; 12].join(" "),
                &MnemonicPassphrase::new(String::new()),
                &"m/44'/501'/0'/0'".parse().unwrap()
            ),
            Err(MnemonicAccountImporterError::MnemonicParsing(
                MnemonicParserError::InvalidChecksum
            ))
        ));
    }

    #[test]
    fn mnemonic_insert_failure_preserves_existing_entry_and_skips_keypair_save() {
        let mnemonics = TestMnemonics::default();
        let existing = MnemonicId { value: [0; 16] };
        mnemonics.entries.borrow_mut().insert(existing);
        let creator = DefaultMnemonicAccountCreator::new(
            Bip39MnemonicGenerator,
            SolanaKeypairDeriver,
            &mnemonics,
            UnexpectedStorage,
        );
        assert!(matches!(
            creator.create_test_account(),
            Err(MnemonicAccountCreatorError::MnemonicStorage(
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
        let creator = DefaultMnemonicAccountCreator::new(
            Bip39MnemonicGenerator,
            SolanaKeypairDeriver,
            &mnemonics,
            keys,
        );
        let error = creator.create_test_account().unwrap_err();
        assert!(
            matches!(error, MnemonicAccountCreatorError::MnemonicCleanup { id, save: KeypairStoreError::AlreadyExists, cleanup: MnemonicStoreError::Keychain(-1) } if mnemonics.entries.borrow().contains(&id))
        );
    }

    #[test]
    fn generation_errors_stop_creation_before_storage() {
        use crate::application::mnemonic::{MnemonicGenerator, MnemonicGeneratorError};

        struct FailingGenerator;

        impl MnemonicGenerator for FailingGenerator {
            fn generate(
                &self,
                _: MnemonicWordlist,
                _: MnemonicGenerationSource,
            ) -> Result<Mnemonic, MnemonicGeneratorError> {
                Err(MnemonicGeneratorError::Randomness)
            }
        }
        let creator = DefaultMnemonicAccountCreator::new(
            FailingGenerator,
            SolanaKeypairDeriver,
            UnexpectedStorage,
            UnexpectedStorage,
        );
        assert!(matches!(
            creator.create_test_account(),
            Err(MnemonicAccountCreatorError::MnemonicGeneration(
                MnemonicGeneratorError::Randomness
            ))
        ));
    }

    #[test]
    fn derivation_errors_stop_creation_before_storage() {
        struct FailingDeriver;

        impl KeypairDeriver for FailingDeriver {
            fn derive(
                &self,
                _: &Mnemonic,
                _: &MnemonicPassphrase,
                _: &DerivationPath,
            ) -> Result<AccountKeypair, KeypairDeriverError> {
                Err(KeypairDeriverError::DerivationFailed)
            }
        }
        let creator = DefaultMnemonicAccountCreator::new(
            Bip39MnemonicGenerator,
            FailingDeriver,
            UnexpectedStorage,
            UnexpectedStorage,
        );
        assert!(matches!(
            creator.create_test_account(),
            Err(MnemonicAccountCreatorError::KeypairDerivation(
                KeypairDeriverError::DerivationFailed
            ))
        ));
    }
}
