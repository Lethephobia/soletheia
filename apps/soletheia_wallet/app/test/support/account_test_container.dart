import 'dart:async';

import 'package:application/account.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soletheia/account.dart';

class TestAccountRepository implements AccountRepository {
  final _changes = StreamController<List<Account>>.broadcast();
  final _accounts = <AccountAddress, Account>{};

  @override
  Stream<List<Account>> watchAll() async* {
    yield _accounts.values.toList();
    yield* _changes.stream;
  }

  @override
  Future<void> save(Account account) async {
    _accounts[account.address] = account;
    _changes.add(_accounts.values.toList());
  }

  AccountAddress? _selected;

  @override
  Stream<AccountAddress?> watchCurrentAddress() {
    return watchAll().map(
      (accounts) => _selected ?? accounts.firstOrNull?.address,
    );
  }

  @override
  Future<void> selectAccount(AccountAddress address) async {
    if (!_accounts.containsKey(address)) {
      throw StateError('Account does not exist');
    }
    _selected = address;
    _changes.add(_accounts.values.toList());
  }

  Future<void> close() => _changes.close();
}

Future<ProviderContainer> accountTestContainer({
  AccountCreator? creator,
  TestAccountRepository? repository,
}) async {
  final store = repository ?? TestAccountRepository();
  addTearDown(store.close);
  final container = ProviderContainer.test(
    overrides: [
      accountRepositoryProvider.overrideWithValue(store),
      if (creator != null) accountCreatorProvider.overrideWithValue(creator),
    ],
  );
  final subscription = container.listen(accountsProvider.future, (_, _) {});
  await subscription.read();
  subscription.close();
  return container;
}
