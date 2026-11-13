import '../unit_of_work/unit_of_work_factory.dart';
import 'account_address.dart';
import 'account_deleter.dart';
import 'account_key_deleter.dart';
import 'account_repository.dart';

final class DefaultAccountDeleter implements AccountDeleter {
  const DefaultAccountDeleter(
    this._keys,
    this._repository,
    this._unitOfWorkFactory,
  );

  final AccountKeyDeleter _keys;
  final AccountRepository _repository;
  final UnitOfWorkFactory _unitOfWorkFactory;

  @override
  Future<bool> delete(AccountAddress address) {
    return _unitOfWorkFactory.run((uow) async {
      final result = await _repository.delete(uow, address);
      await _keys.delete(address, unusedMnemonic: result.unusedMnemonic);
      return result.isEmpty;
    });
  }
}
