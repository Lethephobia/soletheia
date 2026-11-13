part of '../router.dart';

class SettingsRoute extends RelativeGoRouteData with $SettingsRoute {
  const SettingsRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsView();
  }
}

const _settingsRoute = TypedRelativeGoRoute<SettingsRoute>(
  path: 'settings',
  routes: [_accountListShellRoute, _licensesRoute],
);
