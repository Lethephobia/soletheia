part of '../router.dart';

@TypedGoRoute<OnboardingRoute>(
  path: '/onboarding',
  routes: [
    _mnemonicAccountCreationRoute,
    _mnemonicAccountImportRoute,
    _licensesRoute,
  ],
)
class OnboardingRoute extends GoRouteData with $OnboardingRoute {
  const OnboardingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const OnboardingView();
  }
}
