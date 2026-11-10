import 'package:application/account.dart';
import 'package:bs58/bs58.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../account.dart';
import '../../account/account_avatar.dart';
import '../../l10n.dart';

class AccountListView extends ConsumerWidget {
  const AccountListView({super.key, this.onSelect});

  final ValueChanged<AccountAddress>? onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);
    final current = ref.watch(currentAccountAddressProvider).value;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.accountsTitle)),
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
                  onTap: onSelect == null
                      ? null
                      : () => onSelect!(account.address),
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
