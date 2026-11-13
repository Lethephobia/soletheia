use super::{AccountAddress, PrivateKeyAccountKeyImporterError};

pub trait PrivateKeyAccountKeyImporter {
    fn import(
        &self,
        private_key: &str,
    ) -> Result<AccountAddress, PrivateKeyAccountKeyImporterError>;
}
