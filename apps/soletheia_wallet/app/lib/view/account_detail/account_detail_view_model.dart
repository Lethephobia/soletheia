import 'package:application/account.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../account.dart';

part 'account_detail_view_model.g.dart';

enum AccountDeletionStatus { idle, deleting, deleted, emptied, failed }

@riverpod
class AccountDetailViewModel extends _$AccountDetailViewModel {
  @override
  AccountDeletionStatus build(String address) => AccountDeletionStatus.idle;

  Future<void> deleteAccount(AccountAddress target) async {
    if (state == AccountDeletionStatus.deleting) return;
    state = AccountDeletionStatus.deleting;
    try {
      final empty = await ref.read(accountDeleterProvider).delete(target);
      if (ref.mounted) {
        state = empty
            ? AccountDeletionStatus.emptied
            : AccountDeletionStatus.deleted;
      }
    } on Exception {
      if (ref.mounted) state = AccountDeletionStatus.failed;
    }
  }
}
