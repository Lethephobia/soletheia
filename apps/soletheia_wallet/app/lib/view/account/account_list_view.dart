import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';

class AccountListView extends StatelessWidget {
  static const double _contentPadding = 24;

  const AccountListView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(AppLocalizations.of(context).accountListTitle)),
    body: SafeArea(
      child: Center(
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
