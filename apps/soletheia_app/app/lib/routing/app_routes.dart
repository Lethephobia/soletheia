import 'package:material_ui/material_ui.dart';

import '../view.dart';

abstract final class AppRoutes {
  static const home = '/';

  static final Map<String, WidgetBuilder> routes = {
    home: (_) => const HomeView(),
  };
}
