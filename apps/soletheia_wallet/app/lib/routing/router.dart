import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'onboarding.dart' show AccountSetupRoute;
import 'account/account_shell_route.dart' as account;
import 'onboarding/onboarding_shell_route.dart' as onboarding;

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final router = GoRouter(
    initialLocation: const AccountSetupRoute().location,
    routes: [...account.$appRoutes, ...onboarding.$appRoutes],
  );
  ref.onDispose(router.dispose);
  return router;
}
