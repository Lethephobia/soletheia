import 'package:bs58/bs58.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../account.dart';
import '../../l10n.dart';
import '../../responsive.dart';
import '../../routing/account_list.dart';
import 'account_list_tile.dart';

class AccountListView extends ConsumerWidget {
  static const _contentPadding = EdgeInsets.symmetric(horizontal: 24);
  static const _tileSpacing = 2.0;

  const AccountListView({super.key, this.selectedAddress});

  final String? selectedAddress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);
    final current = ref.watch(currentAccountAddressProvider).value;
    final l10n = AppLocalizations.of(context);
    final isTwoPane = Bp.of(context).isAtLeast(Bp.expanded);
    return Scaffold(
      appBar: isTwoPane
          ? null
          : AppBar(
              leading: BackButton(onPressed: () => context.pop()),
              title: Text(l10n.accountListTitle),
            ),
      body: SafeArea(
        child: Padding(
          padding: isTwoPane ? EdgeInsets.zero : _contentPadding,
          child: switch (accounts) {
            AsyncData(:final value) => ListView.separated(
              separatorBuilder: (_, _) => const SizedBox(height: _tileSpacing),
              itemCount: value.length,
              itemBuilder: (context, index) {
                final account = value[index];
                final address = base58.encode(account.address.bytes);
                return AccountListTile(
                  address: account.address,
                  addressText: address,
                  isFirst: index == 0,
                  isLast: index == value.length - 1,
                  isCurrent: account.address == current,
                  isSelected: address == selectedAddress,
                  onTap: () {
                    final detail = AccountDetailRoute(address: address);
                    if (selectedAddress == null) {
                      detail.goRelative(context);
                    } else {
                      context.go(
                        GoRouterState.of(context).uri
                            .resolve(detail.relativeLocation)
                            .toString(),
                      );
                    }
                  },
                );
              },
            ),
            AsyncError() => Center(child: Text(l10n.accountsLoadFailure)),
            AsyncLoading() => const Center(child: CircularProgressIndicator()),
          },
        ),
      ),
    );
  }
}
