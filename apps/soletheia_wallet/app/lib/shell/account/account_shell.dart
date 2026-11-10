import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'account_layout.dart';

class AccountShell extends StatelessWidget {
  const AccountShell({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return AccountLayout(
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (index) => navigationShell.goBranch(index),
      child: navigationShell,
    );
  }
}
