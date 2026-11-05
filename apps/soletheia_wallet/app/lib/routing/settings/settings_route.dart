import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../view/settings.dart';
import '../main/main_shell_route.dart' show $SettingsRoute;

class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsView();
}
