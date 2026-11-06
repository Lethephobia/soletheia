import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../shell/account.dart';
import 'account_branch.dart';
import 'account_list_route.dart';
import '../settings/settings_branch.dart';
import '../settings/settings_route.dart';
part 'account_shell_route.g.dart';

@TypedStatefulShellRoute<AccountShellRoute>(
  branches: [
    TypedStatefulShellBranch<AccountBranch>(
      routes: [TypedGoRoute<AccountListRoute>(path: '/accounts')],
    ),
    TypedStatefulShellBranch<SettingsBranch>(
      routes: [TypedGoRoute<SettingsRoute>(path: '/settings')],
    ),
  ],
)
class AccountShellRoute extends StatefulShellRouteData {
  const AccountShellRoute();
  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) => AccountShell(navigationShell: navigationShell);
}
