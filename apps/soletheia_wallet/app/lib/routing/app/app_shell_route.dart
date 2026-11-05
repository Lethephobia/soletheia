import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../shell/app.dart';
import '../account.dart';
import '../settings.dart';

part 'app_shell_route.g.dart';

@TypedStatefulShellRoute<AppShellRoute>(
  branches: [
    TypedStatefulShellBranch<AccountBranch>(
      routes: [TypedGoRoute<AccountListRoute>(path: '/accounts')],
    ),
    TypedStatefulShellBranch<SettingsBranch>(
      routes: [TypedGoRoute<SettingsRoute>(path: '/settings')],
    ),
  ],
)
class AppShellRoute extends StatefulShellRouteData {
  const AppShellRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) => AppShell(navigationShell: navigationShell);
}
