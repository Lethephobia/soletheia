import 'package:application/account.dart';
import 'package:infrastructure/rust.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'account_repository.dart';

part 'mnemonic_account_importer.g.dart';

@riverpod
MnemonicAccountImporter mnemonicAccountImporter(Ref ref) {
  return DefaultMnemonicAccountImporter(
    const RustMnemonicAccountKeyImporter(),
    ref.watch(accountRepositoryProvider),
    ref.watch(unitOfWorkFactoryProvider),
  );
}
