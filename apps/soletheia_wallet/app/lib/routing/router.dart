import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:material_ui/material_ui.dart';

import '../shell/account.dart';
import '../view/account_list.dart';
import '../view/onboarding.dart';
import '../view/seed_phrase_generation.dart';
import '../view/settings.dart';

part 'account/account_branch.dart';
part 'account/account_list_route.dart';
part 'account/account_shell_route.dart';
part 'account/settings_branch.dart';
part 'account/settings_route.dart';
part 'root/licenses_route.dart';
part 'root/onboarding_route.dart';
part 'root/seed_phrase_generation_route.dart';
part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: const OnboardingRoute().location,
    routes: $appRoutes,
  );
  ref.onDispose(router.dispose);
  return router;
}
