import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../account.dart';
import '../../l10n.dart';

class AccountListView extends ConsumerWidget {
  static const double _contentPadding = 24;

  const AccountListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(accountCatalogProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).accountListTitle),
      ),
      body: SafeArea(
        child: records.isNotEmpty
            ? ListView(
                children: [
                  for (final record in records)
                    ListTile(
                      title: SelectableText(record.address),
                      subtitle: Text(record.derivationPath.value),
                    ),
                ],
              )
            : Center(
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
      ),
    );
  }
}
