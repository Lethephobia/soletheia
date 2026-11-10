import 'package:application/account.dart';
import 'package:bs58/bs58.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../account.dart';
import '../../account/account_avatar.dart';
import '../../l10n.dart';

class AccountSwitchView extends ConsumerStatefulWidget {
  const AccountSwitchView({super.key});

  @override
  ConsumerState<AccountSwitchView> createState() => _AccountSwitchViewState();
}

class _AccountSwitchViewState extends ConsumerState<AccountSwitchView> {
  bool _isSelecting = false;

  Future<void> _selectAccount(AccountAddress address) async {
    if (_isSelecting) return;
    setState(() => _isSelecting = true);
    try {
      await ref.read(accountRepositoryProvider).selectAccount(address);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSelecting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).accountSwitchFailure),
        ),
      );
      return;
    }
    if (mounted && ModalRoute.of(context)?.isCurrent == true) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  onTap: _isSelecting
                      ? null
                      : () => _selectAccount(account.address),
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
