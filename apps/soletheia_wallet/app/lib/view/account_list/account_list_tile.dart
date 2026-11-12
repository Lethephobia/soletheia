import 'package:application/account.dart';
import 'package:material_ui/material_ui.dart';

import '../../account/account_avatar.dart';
import '../account_detail/account_detail_hero.dart';

class AccountListTile extends StatelessWidget {
  static const _outerRadius = Radius.circular(16);
  static const _innerRadius = Radius.circular(4);

  const AccountListTile({
    super.key,
    required this.address,
    required this.addressText,
    required this.isFirst,
    required this.isLast,
    required this.isSelected,
    required this.isCurrent,
    required this.onTap,
  });

  final AccountAddress address;
  final String addressText;
  final bool isFirst;
  final bool isLast;
  final bool isSelected;
  final bool isCurrent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final radius = BorderRadius.vertical(
      top: isFirst ? _outerRadius : _innerRadius,
      bottom: isLast ? _outerRadius : _innerRadius,
    );
    return AccountDetailHero(
      address: addressText,
      tileRadius: radius,
      child: Material(
        color: colors.surfaceContainer,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          selectedTileColor: colors.secondaryContainer,
          selectedColor: colors.onSecondaryContainer,
          leading: AccountAvatar(address: address),
          title: Text(addressText),
          selected: isSelected,
          trailing: isCurrent ? const Icon(Icons.check) : null,
          onTap: onTap,
        ),
      ),
    );
  }
}
