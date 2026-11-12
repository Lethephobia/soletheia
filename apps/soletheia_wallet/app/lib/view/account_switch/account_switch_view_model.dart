import 'package:application/account.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../account.dart';

part 'account_switch_view_model.g.dart';

enum AccountSwitchStatus { idle, selecting, selected, failed }

@riverpod
class AccountSwitchViewModel extends _$AccountSwitchViewModel {
  @override
  AccountSwitchStatus build() => AccountSwitchStatus.idle;

  Future<void> selectAccount(AccountAddress address) async {
    if (state == AccountSwitchStatus.selecting) return;
    state = AccountSwitchStatus.selecting;
    try {
      await ref.read(accountRepositoryProvider).selectAccount(address);
    } on Exception {
      if (ref.mounted) state = AccountSwitchStatus.failed;
      return;
    }
    if (ref.mounted) state = AccountSwitchStatus.selected;
  }
}
