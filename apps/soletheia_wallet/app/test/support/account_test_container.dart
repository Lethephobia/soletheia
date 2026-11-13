import 'dart:async';

import 'package:application/application.dart';
import 'package:infrastructure/rust.dart';
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

  @override
  Future<T> transaction<T>(Future<T> Function() operation) => operation();

  @override
  Future<({MnemonicId? unusedMnemonic, bool isEmpty})> delete(
    AccountAddress address,
  ) async {
    final removed = _accounts.remove(address);
    if (removed == null) throw const AccountNotFoundException();
    final id = removed.mnemonicDerivation?.mnemonicId;
    if (_selected == address) _selected = null;
    _changes.add(_accounts.values.toList());
    final shared = _accounts.values.any(
      (account) => account.mnemonicDerivation?.mnemonicId == id,
    );
    return (unusedMnemonic: shared ? null : id, isEmpty: _accounts.isEmpty);
  }

  AccountAddress? _selected;

  @override
  Stream<AccountAddress?> watchCurrentAddress() {
    return watchAll().map(
      (accounts) => _selected ?? accounts.firstOrNull?.address,
    );
  }

  @override
  Future<void> select(AccountAddress address) async {
    if (!_accounts.containsKey(address)) {
      throw const AccountNotFoundException();
    }
    _selected = address;
    _changes.add(_accounts.values.toList());
  }

  Future<void> close() => _changes.close();
}

Future<ProviderContainer> accountTestContainer({
  MnemonicAccountCreator? creator,
  TestAccountRepository? repository,
}) async {
  final store = repository ?? TestAccountRepository();
  addTearDown(store.close);
  final container = ProviderContainer.test(
    overrides: [
      accountRepositoryProvider.overrideWithValue(store),
      accountDeleterProvider.overrideWithValue(
        RustAccountDeleter(store, deleteKeys: (_, {unusedMnemonic}) async {}),
      ),
      if (creator != null) mnemonicAccountCreatorProvider.overrideWithValue(creator),
    ],
  );
  final subscription = container.listen(accountsProvider.future, (_, _) {});
  await subscription.read();
  subscription.close();
  return container;
}
