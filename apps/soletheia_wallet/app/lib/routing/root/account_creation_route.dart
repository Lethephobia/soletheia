part of '../router.dart';

class AccountCreationRoute extends RelativeGoRouteData
    with $AccountCreationRoute {
  const AccountCreationRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _AccountCreationPage(
      key: state.pageKey,
      restorationId: state.pageKey.value,
    );
  }
}

class _AccountCreationPage extends Page<void> {
  const _AccountCreationPage({
    required super.key,
    required super.restorationId,
  });

  @override
  Route<void> createRoute(BuildContext context) {
    return DialogRoute<void>(
      context: context,
      settings: this,
      useSafeArea: false,
      builder: (_) => const ScaffoldMessenger(child: AccountCreationView()),
    );
  }
}

const _accountCreationRoute = TypedRelativeGoRoute<AccountCreationRoute>(
  path: 'create-account',
);
