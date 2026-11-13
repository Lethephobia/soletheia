import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoRouteTransitionMixin;
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../account.dart';
import '../l10n.dart';
import '../responsive.dart';
import '../shell/account.dart';
import '../shell/account_list.dart';
import '../view/mnemonic_account_creation.dart';
import '../view/account_detail.dart';
import '../view/account_list.dart';
import '../view/account_switch.dart';
import '../view/mnemonic_account_import.dart';
import '../view/private_key_account_import.dart';
import '../view/onboarding.dart';
import '../view/scan.dart';
import '../view/settings.dart';
import '../view/swap.dart';
import '../view/token.dart';

part 'account/account_shell_route.dart';
part 'account/scan_branch.dart';
part 'account/scan_route.dart';
part 'account/token_branch.dart';
part 'account/token_route.dart';
part 'account/trade_branch.dart';
part 'account/trade_route.dart';
part 'account_list/account_detail_route.dart';
part 'account_list/account_list_route.dart';
part 'account_list/account_list_shell_route.dart';
part 'root/mnemonic_account_creation_route.dart';
part 'root/account_switch_route.dart';
part 'root/add_account_route.dart';
part 'root/licenses_route.dart';
part 'root/mnemonic_account_import_route.dart';
part 'root/private_key_account_import_route.dart';
part 'root/onboarding_route.dart';
part 'root/settings_route.dart';
part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: ref.read(accountsProvider).requireValue.isEmpty
        ? const OnboardingRoute().location
        : const TokenRoute().location,
    routes: $appRoutes,
  );
  ref.onDispose(router.dispose);
  return router;
}
