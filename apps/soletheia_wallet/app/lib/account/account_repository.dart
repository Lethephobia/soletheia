import 'package:application/application.dart';
import 'package:infrastructure/sqlite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_repository.g.dart';

@Riverpod(keepAlive: true)
WalletDatabase walletDatabase(Ref ref) {
  final database = WalletDatabase();
  ref.onDispose(database.close);
  return database;
}

@Riverpod(keepAlive: true)
UnitOfWorkFactory unitOfWorkFactory(Ref ref) {
  return SqliteUnitOfWorkFactory(ref.watch(walletDatabaseProvider));
}

@Riverpod(keepAlive: true)
AccountRepository accountRepository(Ref ref) {
  return SqliteAccountRepository(ref.watch(walletDatabaseProvider));
}

@Riverpod(keepAlive: true)
Stream<List<Account>> accounts(Ref ref) {
  return ref.watch(accountRepositoryProvider).watchAll();
}

@Riverpod(keepAlive: true)
Stream<AccountAddress?> currentAccountAddress(Ref ref) {
  return ref.watch(accountRepositoryProvider).watchCurrentAddress();
}
