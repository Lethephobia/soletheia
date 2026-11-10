import 'package:application/account.dart';
import 'package:infrastructure/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_repository.g.dart';

@Riverpod(keepAlive: true)
AccountRepository accountRepository(Ref ref) {
  final repository = SqliteAccountRepository();
  ref.onDispose(repository.close);
  return repository;
}

@Riverpod(keepAlive: true)
Stream<List<Account>> accounts(Ref ref) {
  return ref.watch(accountRepositoryProvider).watchAll();
}

@Riverpod(keepAlive: true)
Stream<AccountAddress?> currentAccountAddress(Ref ref) {
  return ref.watch(accountRepositoryProvider).watchCurrentAddress();
}
