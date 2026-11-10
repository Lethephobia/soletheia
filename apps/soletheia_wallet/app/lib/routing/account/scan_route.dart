part of '../router.dart';

class ScanRoute extends GoRouteData with $ScanRoute {
  const ScanRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ScanView();
  }
}
