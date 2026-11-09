import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import '../../responsive.dart';

class AccountLayout extends StatefulWidget {
  const AccountLayout({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.child,
    this.primaryAction,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;
  final Widget? primaryAction;

  @override
  State<AccountLayout> createState() => _AccountLayoutState();
}

class _AccountLayoutState extends State<AccountLayout> {
  bool _isExtended = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final showsNavigationRail = Bp.of(context).isAtLeast(Bp.medium);
    return Scaffold(
      body: Row(
        children: [
          if (showsNavigationRail)
            SafeArea(
              child: NavigationRail(
                extended: _isExtended,
                labelType: NavigationRailLabelType.none,
                selectedIndex: widget.selectedIndex,
                onDestinationSelected: widget.onDestinationSelected,
                leading: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: _isExtended
                          ? l10n.navigationCollapseLabel
                          : l10n.navigationExpandLabel,
                      onPressed: () =>
                          setState(() => _isExtended = !_isExtended),
                      icon: Icon(_isExtended ? Icons.menu_open : Icons.menu),
                    ),
                    if (widget.primaryAction != null) widget.primaryAction!,
                  ],
                ),
                destinations: [
                  NavigationRailDestination(
                    icon: const Icon(Icons.account_circle_outlined),
                    selectedIcon: const Icon(Icons.account_circle),
                    label: Text(l10n.navigationAccountLabel),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.settings_outlined),
                    selectedIcon: const Icon(Icons.settings),
                    label: Text(l10n.navigationSettingsLabel),
                  ),
                ],
              ),
            ),
          Expanded(key: const ValueKey('account-content'), child: widget.child),
        ],
      ),
      floatingActionButton: showsNavigationRail ? null : widget.primaryAction,
      bottomNavigationBar: showsNavigationRail
          ? null
          : NavigationBar(
              selectedIndex: widget.selectedIndex,
              onDestinationSelected: widget.onDestinationSelected,
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.account_circle_outlined),
                  selectedIcon: const Icon(Icons.account_circle),
                  label: l10n.navigationAccountLabel,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.settings_outlined),
                  selectedIcon: const Icon(Icons.settings),
                  label: l10n.navigationSettingsLabel,
                ),
              ],
            ),
    );
  }
}
