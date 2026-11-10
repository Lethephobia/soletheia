import 'package:bs58/bs58.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n.dart';
import '../routing/root.dart';
import 'account_avatar.dart';
import 'account_repository.dart';

class AccountMenuButton extends ConsumerWidget {
  const AccountMenuButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final address = ref.watch(currentAccountAddressProvider).value;
    if (address == null) return const SizedBox.shrink();
    final encoded = base58.encode(address.bytes);
    final l10n = AppLocalizations.of(context);
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          onPressed: null,
          child: Text(
            '${encoded.substring(0, 6)}…${encoded.substring(encoded.length - 6)}',
          ),
        ),
        MenuItemButton(
          onPressed: () => const AccountSwitchRoute().goRelative(context),
          leadingIcon: const Icon(Icons.swap_horiz),
          child: Text(l10n.switchAccountLabel),
        ),
      ],
      builder: (context, controller, child) {
        return IconButton(
          tooltip: l10n.accountMenuLabel,
          icon: AccountAvatar(address: address),
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
    );
  }
}
