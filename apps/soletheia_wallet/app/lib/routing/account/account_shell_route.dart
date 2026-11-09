part of '../router.dart';

@TypedStatefulShellRoute<AccountShellRoute>(
  branches: [
    TypedStatefulShellBranch<TokenBranch>(
      routes: [
        TypedGoRoute<TokenRoute>(
          path: '/tokens',
          routes: [
            TypedRelativeGoRoute<AccountCreationRoute>(path: 'create-account'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<SettingsBranch>(
      routes: [
        TypedGoRoute<SettingsRoute>(
          path: '/settings',
          routes: [TypedRelativeGoRoute<LicensesRoute>(path: 'licenses')],
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
    return AccountShell(
      navigationShell: navigationShell,
      onAddAccount: state.uri.path == const TokenRoute().location
          ? () => const AccountCreationRoute().goRelative(context)
          : null,
    );
  }
}
