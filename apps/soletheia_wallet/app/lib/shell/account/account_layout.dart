import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import '../../responsive.dart';

class AccountLayout extends StatefulWidget {
  const AccountLayout({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.child,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;

  @override
  State<AccountLayout> createState() => _AccountLayoutState();
}

class _AccountLayoutState extends State<AccountLayout> {
  static const _collapsedRailWidth = 80.0;

  bool _isExtended = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final showsNavigationRail = Bp.of(context).isAtLeast(Bp.medium);
    return Scaffold(
      bottomNavigationBar: showsNavigationRail
          ? null
          : NavigationBar(
              selectedIndex: widget.selectedIndex,
              onDestinationSelected: widget.onDestinationSelected,
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.token_outlined),
                  selectedIcon: const Icon(Icons.token),
                  label: l10n.navigationTokenLabel,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.swap_vert),
                  label: l10n.navigationTradeLabel,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.qr_code_scanner),
                  label: l10n.scanLabel,
                ),
              ],
            ),
      body: Row(
        children: [
          if (showsNavigationRail)
            SafeArea(
              child: IntrinsicWidth(
                child: NavigationRail(
                  minWidth: _collapsedRailWidth,
                  extended: _isExtended,
                  labelType: _isExtended
                      ? NavigationRailLabelType.none
                      : NavigationRailLabelType.all,
                  selectedIndex: widget.selectedIndex,
                  onDestinationSelected: widget.onDestinationSelected,
                  leading: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: SizedBox(
                          width: _collapsedRailWidth,
                          child: Center(
                            child: IconButton(
                              tooltip: _isExtended
                                  ? l10n.navigationCollapseLabel
                                  : l10n.navigationExpandLabel,
                              onPressed: () =>
                                  setState(() => _isExtended = !_isExtended),
                              icon: Icon(
                                _isExtended ? Icons.menu_open : Icons.menu,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  destinations: [
                    NavigationRailDestination(
                      icon: const Icon(Icons.token_outlined),
                      selectedIcon: const Icon(Icons.token),
                      label: Text(l10n.navigationTokenLabel, softWrap: false),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.swap_vert),
                      label: Text(l10n.navigationTradeLabel, softWrap: false),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.qr_code_scanner),
                      label: Text(l10n.scanLabel, softWrap: false),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(key: const ValueKey('account-content'), child: widget.child),
        ],
      ),
    );
  }
}
