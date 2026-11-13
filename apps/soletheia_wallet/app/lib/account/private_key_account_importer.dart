import 'package:application/account.dart';
import 'package:infrastructure/rust.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'account_repository.dart';

part 'private_key_account_importer.g.dart';

@riverpod
PrivateKeyAccountImporter privateKeyAccountImporter(Ref ref) {
  return DefaultPrivateKeyAccountImporter(
    const RustPrivateKeyAccountKeyImporter(),
    ref.watch(accountRepositoryProvider),
    ref.watch(unitOfWorkFactoryProvider),
  );
}
