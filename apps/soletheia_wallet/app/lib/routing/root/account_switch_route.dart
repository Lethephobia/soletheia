part of '../router.dart';

class AccountSwitchRoute extends RelativeGoRouteData with $AccountSwitchRoute {
  const AccountSwitchRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AccountSwitchView();
  }
}
