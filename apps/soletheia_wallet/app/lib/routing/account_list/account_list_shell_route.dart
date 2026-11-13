part of '../router.dart';

class AccountListShellRoute extends ShellRouteData {
  const AccountListShellRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return AccountListLayout(
      navigator: navigator,
      list: AccountListView(selectedAddress: state.pathParameters['address']),
    );
  }
}

const _accountListShellRoute = TypedShellRoute<AccountListShellRoute>(
  routes: [_accountListRoute],
);
