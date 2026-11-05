import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../shell/main.dart';
import '../account.dart';
import '../settings.dart';

part 'main_shell_route.g.dart';

@TypedStatefulShellRoute<MainShellRoute>(
  branches: [
    TypedStatefulShellBranch<AccountBranch>(
      routes: [TypedGoRoute<AccountListRoute>(path: '/accounts')],
    ),
    TypedStatefulShellBranch<SettingsBranch>(
      routes: [TypedGoRoute<SettingsRoute>(path: '/settings')],
    ),
  ],
)
class MainShellRoute extends StatefulShellRouteData {
  const MainShellRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) => MainShell(navigationShell: navigationShell);
}
