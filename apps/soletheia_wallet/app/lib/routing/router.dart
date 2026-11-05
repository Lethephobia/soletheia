import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'account.dart';
import 'app.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final router = GoRouter(
    initialLocation: const AccountListRoute().location,
    routes: $appRoutes,
  );
  ref.onDispose(router.dispose);
  return router;
}
