import 'package:application/account.dart';
import 'package:infrastructure/rust.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'account_repository.dart';

part 'account_deleter.g.dart';

@riverpod
AccountDeleter accountDeleter(Ref ref) {
  return DefaultAccountDeleter(
    const RustAccountKeyDeleter(),
    ref.watch(accountRepositoryProvider),
    ref.watch(unitOfWorkFactoryProvider),
  );
}
