import 'package:bs58/bs58.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../account.dart';
import '../../account/account_avatar.dart';
import '../../l10n.dart';
import 'account_switch_view_model.dart';

class AccountSwitchView extends ConsumerWidget {
  const AccountSwitchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(accountSwitchViewModelProvider);
    ref.listen(accountSwitchViewModelProvider, (_, next) {
      if (next == AccountSwitchStatus.failed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).accountSwitchFailure),
          ),
        );
      } else if (next == AccountSwitchStatus.selected &&
          ModalRoute.of(context)?.isCurrent == true) {
        Navigator.pop(context);
      }
    });
    final accounts = ref.watch(accountsProvider);
    final current = ref.watch(currentAccountAddressProvider).value;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.accountSwitchTitle)),
      body: SafeArea(
        child: switch (accounts) {
          AsyncData(:final value) => ListView(
            children: [
              for (final account in value)
                ListTile(
                  leading: AccountAvatar(address: account.address),
                  title: Text(base58.encode(account.address.bytes)),
                  selected: account.address == current,
                  trailing: account.address == current
                      ? const Icon(Icons.check)
                      : null,
                  onTap: status == AccountSwitchStatus.selecting
                      ? null
                      : () {
                          ref
                              .read(accountSwitchViewModelProvider.notifier)
                              .selectAccount(account.address);
                        },
                ),
            ],
          ),
          AsyncError() => Center(child: Text(l10n.accountsLoadFailure)),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}
