sealed class AccountAddressException implements Exception {
  const AccountAddressException();
}

final class InvalidAccountAddressLengthException
    extends AccountAddressException {
  const InvalidAccountAddressLengthException(this.actualBytes);

  final int actualBytes;
}
