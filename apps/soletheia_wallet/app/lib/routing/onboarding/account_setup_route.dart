import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../view/onboarding.dart';
import 'onboarding_shell_route.dart' show $AccountSetupRoute;

class AccountSetupRoute extends GoRouteData with $AccountSetupRoute {
  const AccountSetupRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AccountSetupView();
}
