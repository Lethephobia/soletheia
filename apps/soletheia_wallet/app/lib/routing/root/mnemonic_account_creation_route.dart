part of '../router.dart';

class MnemonicAccountCreationRoute extends RelativeGoRouteData
    with $MnemonicAccountCreationRoute {
  const MnemonicAccountCreationRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _MnemonicAccountCreationPage(
      key: state.pageKey,
      restorationId: state.pageKey.value,
    );
  }
}

class _MnemonicAccountCreationPage extends Page<void> {
  const _MnemonicAccountCreationPage({
    required super.key,
    required super.restorationId,
  });

  @override
  Route<void> createRoute(BuildContext context) {
    return DialogRoute<void>(
      context: context,
      settings: this,
      useSafeArea: false,
      builder: (_) =>
          const ScaffoldMessenger(child: MnemonicAccountCreationView()),
    );
  }
}

const _mnemonicAccountCreationRoute =
    TypedRelativeGoRoute<MnemonicAccountCreationRoute>(path: 'create-account');
