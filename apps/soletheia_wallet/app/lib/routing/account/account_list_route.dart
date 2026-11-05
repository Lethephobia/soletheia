import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../view/account.dart';
import '../app/app_shell_route.dart' show $AccountListRoute;

class AccountListRoute extends GoRouteData with $AccountListRoute {
  const AccountListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AccountListView();
}
