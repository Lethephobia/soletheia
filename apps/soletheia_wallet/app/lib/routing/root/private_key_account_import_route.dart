part of '../router.dart';

class PrivateKeyAccountImportRoute extends RelativeGoRouteData
    with $PrivateKeyAccountImportRoute {
  const PrivateKeyAccountImportRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _PrivateKeyAccountImportPage(
      key: state.pageKey,
      restorationId: state.pageKey.value,
    );
  }
}

class _PrivateKeyAccountImportPage extends Page<void> {
  const _PrivateKeyAccountImportPage({
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
          const ScaffoldMessenger(child: PrivateKeyAccountImportView()),
    );
  }
}

const _privateKeyAccountImportRoute =
    TypedRelativeGoRoute<PrivateKeyAccountImportRoute>(
      path: 'import-private-key',
    );
