import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../shell/onboarding.dart';
import 'account_setup_route.dart';
part 'onboarding_shell_route.g.dart';

@TypedShellRoute<OnboardingShellRoute>(
  routes: [TypedGoRoute<AccountSetupRoute>(path: '/onboarding')],
)
class OnboardingShellRoute extends ShellRouteData {
  const OnboardingShellRoute();
  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) =>
      OnboardingShell(child: navigator);
}
