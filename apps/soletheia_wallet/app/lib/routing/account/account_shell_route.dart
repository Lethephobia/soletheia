part of '../router.dart';

@TypedStatefulShellRoute<AccountShellRoute>(
  branches: [
    TypedStatefulShellBranch<TokenBranch>(
      routes: [
        TypedGoRoute<TokenRoute>(
          path: '/tokens',
          routes: [
            TypedRelativeGoRoute<AccountSwitchRoute>(path: 'accounts'),
            TypedRelativeGoRoute<AddAccountRoute>(
              path: 'add-account',
              routes: [
                TypedRelativeGoRoute<AccountCreationRoute>(
                  path: 'create-account',
                ),
                TypedRelativeGoRoute<LicensesRoute>(path: 'licenses'),
              ],
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<SettingsBranch>(
      routes: [
        TypedGoRoute<SettingsRoute>(
          path: '/settings',
          routes: [
            TypedRelativeGoRoute<LicensesRoute>(path: 'licenses'),
            TypedRelativeGoRoute<AccountSwitchRoute>(path: 'accounts'),
            TypedRelativeGoRoute<AddAccountRoute>(
              path: 'add-account',
              routes: [
                TypedRelativeGoRoute<AccountCreationRoute>(
                  path: 'create-account',
                ),
                TypedRelativeGoRoute<LicensesRoute>(path: 'licenses'),
              ],
            ),
          ],
        ),
      ],
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
  ) {
    return AccountShell(navigationShell: navigationShell);
  }
}
