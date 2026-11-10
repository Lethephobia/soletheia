part of '../router.dart';

@TypedStatefulShellRoute<AccountShellRoute>(
  branches: [
    TypedStatefulShellBranch<TokenBranch>(
      routes: [
        TypedGoRoute<TokenRoute>(
          path: '/tokens',
          routes: [
            TypedRelativeGoRoute<SettingsRoute>(
              path: 'settings',
              routes: [
                TypedRelativeGoRoute<AccountListRoute>(path: 'accounts'),
                TypedRelativeGoRoute<LicensesRoute>(path: 'licenses'),
              ],
            ),
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
    TypedStatefulShellBranch<TradeBranch>(
      routes: [
        TypedGoRoute<TradeRoute>(
          path: '/trade',
          routes: [
            TypedRelativeGoRoute<SettingsRoute>(
              path: 'settings',
              routes: [
                TypedRelativeGoRoute<AccountListRoute>(path: 'accounts'),
                TypedRelativeGoRoute<LicensesRoute>(path: 'licenses'),
              ],
            ),
            TypedRelativeGoRoute<AccountSwitchRoute>(path: 'accounts'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<ScanBranch>(
      routes: [
        TypedGoRoute<ScanRoute>(
          path: '/scan',
          routes: [
            TypedRelativeGoRoute<SettingsRoute>(
              path: 'settings',
              routes: [
                TypedRelativeGoRoute<AccountListRoute>(path: 'accounts'),
                TypedRelativeGoRoute<LicensesRoute>(path: 'licenses'),
              ],
            ),
            TypedRelativeGoRoute<AccountSwitchRoute>(path: 'accounts'),
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
