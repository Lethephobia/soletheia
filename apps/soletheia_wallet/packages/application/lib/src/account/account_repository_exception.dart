sealed class AccountRepositoryException implements Exception {
  const AccountRepositoryException();
}

final class AccountNotFoundException extends AccountRepositoryException {
  const AccountNotFoundException();
}
