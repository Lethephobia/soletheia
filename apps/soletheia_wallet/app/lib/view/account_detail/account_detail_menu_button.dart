import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';

class AccountDetailMenuButton extends StatelessWidget {
  const AccountDetailMenuButton({super.key, required this.onDelete});

  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          onPressed: onDelete,
          leadingIcon: const Icon(Icons.delete_outline),
          child: Text(AppLocalizations.of(context).accountDetailDeleteLabel),
        ),
      ],
      builder: (context, controller, _) {
        return IconButton(
          tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
          icon: const Icon(Icons.more_vert),
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
