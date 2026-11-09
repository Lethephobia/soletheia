import 'package:application/account.dart';
import 'package:infrastructure/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_repository.g.dart';

@Riverpod(keepAlive: true)
AccountRepository accountRepository(Ref ref) {
  final repository = DriftAccountRepository();
  ref.onDispose(repository.close);
  return repository;
}

@Riverpod(keepAlive: true)
Stream<List<Account>> accounts(Ref ref) {
  return ref.watch(accountRepositoryProvider).watchAll();
}
