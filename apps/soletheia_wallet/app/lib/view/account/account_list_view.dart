import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';

class AccountListView extends StatelessWidget {
  const AccountListView({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        AppLocalizations.of(context).accountsEmpty,
        style: Theme.of(context).textTheme.bodyMedium
            ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    ),
  );
}
