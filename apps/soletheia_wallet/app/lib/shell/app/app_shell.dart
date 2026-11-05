import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'app_layout.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => AppLayout(
    selectedIndex: navigationShell.currentIndex,
    onDestinationSelected: (index) => navigationShell.goBranch(index),
    child: navigationShell,
  );
}
