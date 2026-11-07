part of '../router.dart';

class MnemonicGenerationRoute extends RelativeGoRouteData
    with $MnemonicGenerationRoute {
  const MnemonicGenerationRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MnemonicGenerationView();
  }
}
