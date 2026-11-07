part of '../router.dart';

class AccountListRoute extends GoRouteData with $AccountListRoute {
  const AccountListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AccountListView();
  }
}
