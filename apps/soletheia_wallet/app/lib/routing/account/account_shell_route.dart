part of '../router.dart';

@TypedStatefulShellRoute<AccountShellRoute>(
  branches: [
    TypedStatefulShellBranch<AccountBranch>(
      routes: [
        TypedGoRoute<AccountListRoute>(
          path: '/accounts',
          routes: [
            TypedRelativeGoRoute<MnemonicGenerationRoute>(
              path: 'generate-mnemonic',
            ),
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
      onAddAccount: state.uri.path == const AccountListRoute().location
          ? () => const MnemonicGenerationRoute().goRelative(context)
          : null,
    );
  }
}
