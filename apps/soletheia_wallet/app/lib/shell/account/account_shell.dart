import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import 'account_layout.dart';

class AccountShell extends StatelessWidget {
  const AccountShell({
    super.key,
    required this.navigationShell,
    required this.onAddAccount,
  });
  final StatefulNavigationShell navigationShell;
  final VoidCallback? onAddAccount;

  @override
  Widget build(BuildContext context) {
    return AccountLayout(
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (index) => navigationShell.goBranch(index),
      primaryAction: onAddAccount != null
          ? FloatingActionButton(
              onPressed: onAddAccount,
              tooltip: AppLocalizations.of(context).accountAddLabel,
              child: const Icon(Icons.add),
            )
          : null,
      child: navigationShell,
    );
  }
}
