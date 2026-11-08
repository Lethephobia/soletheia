part of '../router.dart';

class AccountCreationRoute extends RelativeGoRouteData
    with $AccountCreationRoute {
  const AccountCreationRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AccountCreationView();
  }
}
