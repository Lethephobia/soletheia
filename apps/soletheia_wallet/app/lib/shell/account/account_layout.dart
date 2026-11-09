import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import '../../responsive.dart';

class AccountLayout extends StatefulWidget {
  const AccountLayout({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.child,
    this.primaryActionBuilder,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;
  final Widget Function({required bool extended})? primaryActionBuilder;

  @override
  State<AccountLayout> createState() => _AccountLayoutState();
}

class _AccountLayoutState extends State<AccountLayout> {
  static const _collapsedRailWidth = 80.0;
  static const _railFabInset = 12.0;

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
                      if (widget.primaryActionBuilder case final buildAction?)
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                              start: _railFabInset,
                            ),
                            child: buildAction(extended: _isExtended),
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
                      icon: const Icon(Icons.settings_outlined),
                      selectedIcon: const Icon(Icons.settings),
                      label: Text(
                        l10n.navigationSettingsLabel,
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(key: const ValueKey('account-content'), child: widget.child),
        ],
      ),
      floatingActionButton: showsNavigationRail
          ? null
          : widget.primaryActionBuilder?.call(extended: false),
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
                  icon: const Icon(Icons.settings_outlined),
                  selectedIcon: const Icon(Icons.settings),
                  label: l10n.navigationSettingsLabel,
                ),
              ],
            ),
    );
  }
}
