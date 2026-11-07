part of '../router.dart';

@TypedGoRoute<OnboardingRoute>(
  path: '/onboarding',
  routes: [
    TypedRelativeGoRoute<SeedPhraseGenerationRoute>(
      path: 'generate-seed-phrase',
    ),
    TypedRelativeGoRoute<LicensesRoute>(path: 'licenses'),
  ],
)
class OnboardingRoute extends GoRouteData with $OnboardingRoute {
  const OnboardingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const OnboardingView();
  }
}
