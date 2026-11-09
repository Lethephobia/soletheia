part of '../router.dart';

class TokenRoute extends GoRouteData with $TokenRoute {
  const TokenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TokenView();
  }
}
