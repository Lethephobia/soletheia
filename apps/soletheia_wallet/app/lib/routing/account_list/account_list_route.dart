part of '../router.dart';

class AccountListRoute extends RelativeGoRouteData with $AccountListRoute {
  const AccountListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    if (Bp.of(context).isAtLeast(Bp.expanded)) {
      return Center(
        child: Text(AppLocalizations.of(context).accountListSelectPrompt),
      );
    }
    return const AccountListView();
  }
}

const _accountListRoute = TypedRelativeGoRoute<AccountListRoute>(
  path: 'accounts',
  routes: [_accountDetailRoute],
);
