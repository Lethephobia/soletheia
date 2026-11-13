import 'package:application/account.dart';
import 'package:infrastructure/rust.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'account_repository.dart';

part 'mnemonic_account_creator.g.dart';

@riverpod
MnemonicAccountCreator mnemonicAccountCreator(Ref ref) {
  return DefaultMnemonicAccountCreator(
    const RustMnemonicAccountKeyCreator(),
    ref.watch(accountRepositoryProvider),
    ref.watch(unitOfWorkFactoryProvider),
  );
}
