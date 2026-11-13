import '../mnemonic/mnemonic_passphrase.dart';
import '../unit_of_work/unit_of_work_factory.dart';
import 'account.dart';
import 'account_repository.dart';
import 'account_save_exception.dart';
import 'derivation_path.dart';
import 'mnemonic_account_importer.dart';
import 'mnemonic_account_key_importer.dart';
import 'mnemonic_derivation.dart';

final class DefaultMnemonicAccountImporter implements MnemonicAccountImporter {
  const DefaultMnemonicAccountImporter(
    this._keys,
    this._repository,
    this._unitOfWorkFactory,
  );

  final MnemonicAccountKeyImporter _keys;
  final AccountRepository _repository;
  final UnitOfWorkFactory _unitOfWorkFactory;

  @override
  @override
  Future<Account> import({
    required String phrase,
    required MnemonicPassphrase passphrase,
    required DerivationPath derivationPath,
  }) async {
    final keys = await _keys.import(
      phrase: phrase,
      passphrase: passphrase,
      derivationPath: derivationPath,
    );
    final account = Account(
      address: keys.address,
      mnemonicDerivation: MnemonicDerivation(
        mnemonicId: keys.mnemonicId,
        derivationPath: derivationPath,
      ),
    );
    await retrySave(account);
    return account;
  }

  @override
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
