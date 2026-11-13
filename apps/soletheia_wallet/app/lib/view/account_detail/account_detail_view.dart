import 'package:application/account.dart';
import 'package:bs58/bs58.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../account.dart';
import '../../l10n.dart';
import '../../responsive.dart';
import '../../routing/root.dart';
import 'account_detail_hero.dart';
import 'account_detail_menu_button.dart';
import 'account_detail_view_model.dart';

class AccountDetailView extends ConsumerWidget {
  static const _contentPadding = EdgeInsets.symmetric(horizontal: 24);

  static const _paneRadius = BorderRadius.all(Radius.circular(16));

  const AccountDetailView({super.key, required this.address});

  final String address;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final accounts = ref.watch(accountsProvider);
    final provider = accountDetailViewModelProvider(address);
    final deleting = ref.watch(provider) == AccountDeletionStatus.deleting;
    final account = accounts.asData?.value
        .where((item) => base58.encode(item.address.bytes) == address)
        .firstOrNull;
    ref.listen(provider, (_, status) {
      if (status == AccountDeletionStatus.failed) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.accountDeletionFailure)));
      } else if (status == AccountDeletionStatus.deleted ||
          status == AccountDeletionStatus.emptied) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.accountDeleted)));
        if (status == AccountDeletionStatus.emptied) {
          const OnboardingRoute().go(context);
        } else if (ModalRoute.of(context)?.isCurrent == true) {
          Navigator.pop(context);
        }
      }
    });
    final isTwoPane = Bp.of(context).isAtLeast(Bp.expanded);
    final surface = Theme.of(context).colorScheme.surfaceContainer;
    final appBar = AppBar(
      backgroundColor: surface,
      title: Text(l10n.accountDetailTitle),
      actions: [
        AccountDetailMenuButton(
          onDelete: account == null || deleting
              ? null
              : () async {
                  final confirmed = await _confirmDeletion(context);
                  if (confirmed == true && context.mounted) {
                    await ref
                        .read(provider.notifier)
                        .deleteAccount(account.address);
                  }
                },
        ),
      ],
    );
    final body = SafeArea(
      child: Padding(
        padding: isTwoPane ? EdgeInsets.zero : _contentPadding,
        child: switch (accounts) {
          AsyncData() => _buildDetails(context, account, isTwoPane),
          AsyncError() => Center(child: Text(l10n.accountsLoadFailure)),
          AsyncLoading() => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
    if (!isTwoPane) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: AccountDetailHero(
          address: address,
          child: Material(
            color: surface,
            child: Column(
              children: [
                SizedBox(
                  height:
                      AppBar.preferredHeightFor(context, appBar.preferredSize) +
                      MediaQuery.paddingOf(context).top,
                  child: appBar,
                ),
                Expanded(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: body,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Material(
      color: surface,
      borderRadius: _paneRadius,
      clipBehavior: Clip.antiAlias,
      child: Scaffold(backgroundColor: surface, appBar: appBar, body: body),
    );
  }

  Future<bool?> _confirmDeletion(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.accountDeletionTitle),
          content: Text(l10n.accountDeletionConfirmation(address)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                MaterialLocalizations.of(dialogContext).cancelButtonLabel,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(dialogContext).colorScheme.error,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.accountDetailDeleteLabel),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetails(BuildContext context, Account? account, bool isTwoPane) {
    final l10n = AppLocalizations.of(context);
    if (account == null) {
      return Center(child: Text(l10n.accountDetailNotFound));
    }
    return ListView(
      // The detail route has its own primary scroll controller.
      controller: isTwoPane
          ? context
                .findAncestorStateOfType<NestedScrollViewState>()
                ?.innerController
          : null,
      children: [
        ListTile(
          title: Text(l10n.accountDetailAddress),
          subtitle: SelectableText(address),
        ),
        if (account.mnemonicDerivation case final derivation?)
          ListTile(
            title: Text(l10n.mnemonicAccountCreationDerivationPathLabel),
            subtitle: Text(derivation.derivationPath.value),
          ),
      ],
    );
  }
}
