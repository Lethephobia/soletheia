part of '../router.dart';

class TradeRoute extends GoRouteData with $TradeRoute {
  const TradeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SwapView();
  }
}
