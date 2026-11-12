import 'package:application/account.dart';
import 'package:infrastructure/rust.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'account_repository.dart';

part 'account_deleter.g.dart';

@riverpod
AccountDeleter accountDeleter(Ref ref) {
  return RustAccountDeleter(ref.watch(accountRepositoryProvider));
}
