part of '../router.dart';

class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SettingsView(
      onLicenses: () => const LicensesRoute().goRelative(context),
    );
  }
}
