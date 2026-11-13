import 'dart:async';
import 'dart:typed_data';

import 'package:application/account.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soletheia/view/account_switch/account_switch_view_model.dart';

import '../../support/account_test_container.dart';

class _PendingRepository extends TestAccountRepository {
  final requests = <Completer<void>>[];

  @override
  Future<void> select(AccountAddress address) {
    final request = Completer<void>();
    requests.add(request);
    return request.future;
  }
}

void main() {
  test(
    'ignores repeated selections while saving and allows retry after failure',
    () async {
      final repository = _PendingRepository();
      final container = await accountTestContainer(repository: repository);
      final status = container.listen(
        accountSwitchViewModelProvider,
        (_, _) {},
      );
      final model = container.read(accountSwitchViewModelProvider.notifier);
      final address = AccountAddress(Uint8List(32));

      final first = model.selectAccount(address);
      expect(status.read(), AccountSwitchStatus.selecting);
      await model.selectAccount(address);
      expect(repository.requests, hasLength(1));
      repository.requests.single.completeError(
        const AccountNotFoundException(),
      );
      await first;
      expect(status.read(), AccountSwitchStatus.failed);

      final retry = model.selectAccount(address);
      repository.requests.last.complete();
      await retry;
      expect(status.read(), AccountSwitchStatus.selected);
    },
  );
}
