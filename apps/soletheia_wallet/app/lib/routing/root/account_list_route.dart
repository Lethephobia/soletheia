part of '../router.dart';

class AccountListRoute extends RelativeGoRouteData with $AccountListRoute {
  const AccountListRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AccountListView();
  }
}
