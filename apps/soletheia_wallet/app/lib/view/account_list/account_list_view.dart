import 'package:bs58/bs58.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../account.dart';
import '../../l10n.dart';

class AccountListView extends ConsumerWidget {
  static const double _contentPadding = 24;

  const AccountListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(accountsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).accountListTitle),
      ),
      body: SafeArea(
        child: switch (records) {
          AsyncLoading() => const Center(child: CircularProgressIndicator()),
          AsyncError() => Center(
            child: Text(AppLocalizations.of(context).accountListLoadFailure),
          ),
          AsyncData(value: final accounts) when accounts.isNotEmpty => ListView(
            children: [
              for (final account in accounts)
                ListTile(
                  title: SelectableText(base58.encode(account.address.bytes)),
                  subtitle: switch (account.mnemonicDerivation) {
                    final derivation? => Text(derivation.derivationPath.value),
                    null => null,
                  },
                ),
            ],
          ),
          AsyncData() => Center(
            child: Padding(
              padding: const EdgeInsets.all(_contentPadding),
              child: Text(
                AppLocalizations.of(context).accountListEmptyMessage,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        },
      ),
    );
  }
}
