import '../unit_of_work/unit_of_work_factory.dart';
import 'account.dart';
import 'account_repository.dart';
import 'account_save_exception.dart';
import 'private_key_account_importer.dart';
import 'private_key_account_key_importer.dart';

final class DefaultPrivateKeyAccountImporter
    implements PrivateKeyAccountImporter {
  const DefaultPrivateKeyAccountImporter(
    this._keyImporter,
    this._repository,
    this._unitOfWorkFactory,
  );

  final PrivateKeyAccountKeyImporter _keyImporter;
  final AccountRepository _repository;
  final UnitOfWorkFactory _unitOfWorkFactory;

  @override
  Future<Account> import({required String privateKey}) async {
    final address = await _keyImporter.import(privateKey: privateKey);
    final account = Account(address: address);
    await retrySave(account);
    return account;
  }

  @override
  Future<void> retrySave(Account account) async {
    try {
      await _unitOfWorkFactory.run((uow) async {
        await _repository.save(uow, account);
        await _repository.select(uow, account.address);
      });
    } on Exception catch (error) {
      throw AccountSaveException(account, error);
    }
  }
}
