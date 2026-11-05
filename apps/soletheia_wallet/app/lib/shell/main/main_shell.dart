import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'main_layout.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => MainLayout(
    selectedIndex: navigationShell.currentIndex,
    onDestinationSelected: (index) => navigationShell.goBranch(index),
    child: navigationShell,
  );
}
