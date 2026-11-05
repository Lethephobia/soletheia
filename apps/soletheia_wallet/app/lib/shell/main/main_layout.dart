import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import '../../responsive.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.child,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final useRail = Bp.of(context).isAtLeast(Bp.medium);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedIndex == 0 ? l10n.accountsTitle : l10n.settingsTitle,
        ),
      ),
      body: SafeArea(
        child: Row(
          children: [
            if (useRail) ...[
              NavigationRail(
                selectedIndex: selectedIndex,
                onDestinationSelected: onDestinationSelected,
                labelType: NavigationRailLabelType.all,
                destinations: [
                  NavigationRailDestination(
                    icon: const Icon(Icons.account_circle_outlined),
                    selectedIcon: const Icon(Icons.account_circle),
                    label: Text(l10n.accountsTitle),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.settings_outlined),
                    selectedIcon: const Icon(Icons.settings),
                    label: Text(l10n.settingsTitle),
                  ),
                ],
              ),
              const VerticalDivider(width: 1),
            ],
            Expanded(key: const ValueKey('main-content'), child: child),
          ],
        ),
      ),
      bottomNavigationBar: useRail
          ? null
          : NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.account_circle_outlined),
                  selectedIcon: const Icon(Icons.account_circle),
                  label: l10n.accountsTitle,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.settings_outlined),
                  selectedIcon: const Icon(Icons.settings),
                  label: l10n.settingsTitle,
                ),
              ],
            ),
    );
  }
}
