part of '../router.dart';

class LicensesRoute extends RelativeGoRouteData with $LicensesRoute {
  const LicensesRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LicensePage();
  }
}

const _licensesRoute = TypedRelativeGoRoute<LicensesRoute>(path: 'licenses');
