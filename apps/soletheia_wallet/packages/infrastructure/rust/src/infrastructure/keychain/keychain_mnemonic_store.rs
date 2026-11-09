use super::keychain_item::KeychainItem;
use crate::application::{
    mnemonic::{Mnemonic, MnemonicWordlist},
    storage::{MnemonicId, MnemonicStore, MnemonicStoreError},
};
use security_framework::passwords::{delete_generic_password_options, PasswordOptions};
use zeroize::Zeroizing;

pub struct KeychainMnemonicStore;

impl KeychainMnemonicStore {
    const SERVICE: &str = "soletheia.wallet.mnemonic";

    fn account_name(id: MnemonicId) -> String {
        u128::from_be_bytes(*id.value()).to_string()
    }

    // v1: version, wordlist code, space-separated UTF-8 words.
    fn encode_mnemonic(mnemonic: &Mnemonic) -> Zeroizing<Vec<u8>> {
        use MnemonicWordlist::*;
        let code = match mnemonic.wordlist() {
            English => 0,
            Japanese => 1,
            Korean => 2,
            SimplifiedChinese => 3,
            TraditionalChinese => 4,
            French => 5,
            Italian => 6,
            Spanish => 7,
            Czech => 8,
            Portuguese => 9,
        };
        let phrase = mnemonic.to_phrase();
        let mut data = Zeroizing::new(Vec::with_capacity(2 + phrase.len()));
        data.extend_from_slice(&[1, code]);
        data.extend_from_slice(phrase.as_bytes());
        data
    }

    fn map_insert_error(error: security_framework::base::Error) -> MnemonicStoreError {
        match error.code() {
            security_framework_sys::base::errSecDuplicateItem => MnemonicStoreError::AlreadyExists,
            status => MnemonicStoreError::Keychain(status),
        }
    }
}

impl MnemonicStore for KeychainMnemonicStore {
    fn save_mnemonic(&self, mnemonic: &Mnemonic) -> Result<MnemonicId, MnemonicStoreError> {
        let id = MnemonicId::new();
        KeychainItem::insert(
            Self::SERVICE,
            &Self::account_name(id),
            &Self::encode_mnemonic(mnemonic),
        )
        .map_err(Self::map_insert_error)?;
        Ok(id)
    }

    fn delete_mnemonic(&self, id: MnemonicId) -> Result<(), MnemonicStoreError> {
        let mut options =
            PasswordOptions::new_generic_password(Self::SERVICE, &Self::account_name(id));
        options.use_protected_keychain();
        delete_generic_password_options(options)
            .map_err(|error| MnemonicStoreError::Keychain(error.code()))
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::application::mnemonic::{MnemonicGenerationSource, MnemonicGenerator};
    use crate::infrastructure::bip39::Bip39MnemonicGenerator;

    #[test]
    fn stores_original_utf8_words_with_their_wordlist() {
        let mnemonic = Bip39MnemonicGenerator
            .generate_mnemonic(
                MnemonicWordlist::Japanese,
                MnemonicGenerationSource::Entropy(vec![0; 16].try_into().unwrap()),
            )
            .unwrap();
        let record = KeychainMnemonicStore::encode_mnemonic(&mnemonic);
        let expected = ["あいこくしん"; 11].join(" ") + " あおぞら";

        assert_eq!(&record[..2], &[1, 1]);
        assert!(&record[2..] == expected.as_bytes());
    }
}
