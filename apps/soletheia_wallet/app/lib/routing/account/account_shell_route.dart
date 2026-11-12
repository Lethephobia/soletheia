part of '../router.dart';

@TypedStatefulShellRoute<AccountShellRoute>(
  branches: [
    TypedStatefulShellBranch<TokenBranch>(
      routes: [
        TypedGoRoute<TokenRoute>(
          path: '/tokens',
          routes: [_settingsRoute, _accountSwitchRoute, _addAccountRoute],
        ),
      ],
    ),
    TypedStatefulShellBranch<TradeBranch>(
      routes: [
        TypedGoRoute<TradeRoute>(
          path: '/trade',
          routes: [_settingsRoute, _accountSwitchRoute],
        ),
      ],
    ),
    TypedStatefulShellBranch<ScanBranch>(
      routes: [
        TypedGoRoute<ScanRoute>(
          path: '/scan',
          routes: [_settingsRoute, _accountSwitchRoute],
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
