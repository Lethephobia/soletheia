part of '../router.dart';

class AccountDetailRoute extends RelativeGoRouteData with $AccountDetailRoute {
  const AccountDetailRoute({required this.address});

  final String address;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    if (Bp.of(context).isAtLeast(Bp.expanded)) {
      return super.buildPage(context, state);
    }
    return CustomTransitionPage<void>(
      key: state.pageKey,
      restorationId: state.pageKey.value,
      transitionsBuilder: (context, _, _, child) {
        if (Theme.of(context).platform != TargetPlatform.iOS) return child;
        // Keep the page stationary while the gesture drives the route and Hero.
        return CupertinoRouteTransitionMixin.buildPageTransitions<void>(
          ModalRoute.of<void>(context)! as PageRoute<void>,
          context,
          kAlwaysCompleteAnimation,
          kAlwaysDismissedAnimation,
          child,
        );
      },
      child: build(context, state),
    );
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AccountDetailView(address: address);
  }
}

const _accountDetailRoute = TypedRelativeGoRoute<AccountDetailRoute>(
  path: ':address',
);
