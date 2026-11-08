use core_foundation::{
    base::TCFType, boolean::CFBoolean, data::CFData, dictionary::CFDictionary, string::CFString,
};
use security_framework::access_control::{ProtectionMode, SecAccessControl};
use security_framework::base::Error;
use security_framework_sys::{
    base::errSecSuccess as SUCCESS,
    item::{
        kSecAttrAccessControl, kSecAttrAccount, kSecAttrService, kSecClass,
        kSecClassGenericPassword, kSecUseDataProtectionKeychain, kSecValueData,
    },
    keychain_item::SecItemAdd,
};

pub(super) struct KeychainItem;

impl KeychainItem {
    pub(super) fn insert(service: &str, account: &str, data: &[u8]) -> Result<(), Error> {
        let access = SecAccessControl::create_with_protection(
            Some(ProtectionMode::AccessibleWhenUnlockedThisDeviceOnly),
            0,
        )?;

        // These Security.framework constants are immutable CFStrings owned by the OS.
        let query = unsafe {
            let key = |ptr| CFString::wrap_under_get_rule(ptr);
            CFDictionary::from_CFType_pairs(&[
                (key(kSecClass), key(kSecClassGenericPassword).as_CFType()),
                (key(kSecAttrService), CFString::from(service).as_CFType()),
                (key(kSecAttrAccount), CFString::from(account).as_CFType()),
                (key(kSecAttrAccessControl), access.as_CFType()),
                (
                    key(kSecUseDataProtectionKeychain),
                    CFBoolean::true_value().as_CFType(),
                ),
                (key(kSecValueData), CFData::from_buffer(data).as_CFType()),
            ])
        };

        // The query owns all of its values. A null result pointer requests no output.
        match unsafe { SecItemAdd(query.as_concrete_TypeRef(), std::ptr::null_mut()) } {
            SUCCESS => Ok(()),
            status => Err(Error::from_code(status)),
        }
    }
}
