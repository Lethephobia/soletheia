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
    final label = AppLocalizations.of(context).accountAddLabel;
    return AccountLayout(
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (index) => navigationShell.goBranch(index),
      primaryActionBuilder: onAddAccount != null
          ? ({required extended}) {
              if (extended) {
                return FloatingActionButton.extended(
                  onPressed: onAddAccount,
                  tooltip: label,
                  icon: const Icon(Icons.add),
                  label: Text(label),
                );
              }
              return FloatingActionButton(
                onPressed: onAddAccount,
                tooltip: label,
                child: const Icon(Icons.add),
              );
            }
          : null,
      child: navigationShell,
    );
  }
}
