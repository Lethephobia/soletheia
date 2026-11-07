part of '../router.dart';

class SeedPhraseGenerationRoute extends RelativeGoRouteData
    with $SeedPhraseGenerationRoute {
  const SeedPhraseGenerationRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SeedPhraseGenerationView();
  }
}
