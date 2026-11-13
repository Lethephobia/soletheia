part of '../router.dart';

class AddAccountRoute extends RelativeGoRouteData with $AddAccountRoute {
  const AddAccountRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const OnboardingView(isAddingAccount: true);
  }
}

const _addAccountRoute = TypedRelativeGoRoute<AddAccountRoute>(
  path: 'add-account',
  routes: [
    _mnemonicAccountCreationRoute,
    _mnemonicAccountImportRoute,
    _privateKeyAccountImportRoute,
    _licensesRoute,
  ],
);
