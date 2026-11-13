part of '../router.dart';

class MnemonicAccountImportRoute extends RelativeGoRouteData
    with $MnemonicAccountImportRoute {
  const MnemonicAccountImportRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _MnemonicAccountImportPage(
      key: state.pageKey,
      restorationId: state.pageKey.value,
    );
  }
}

class _MnemonicAccountImportPage extends Page<void> {
  const _MnemonicAccountImportPage({
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
          const ScaffoldMessenger(child: MnemonicAccountImportView()),
    );
  }
}

const _mnemonicAccountImportRoute =
    TypedRelativeGoRoute<MnemonicAccountImportRoute>(path: 'import-mnemonic');
