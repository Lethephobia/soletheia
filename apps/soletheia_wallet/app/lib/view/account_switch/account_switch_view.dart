import 'package:application/account.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../account.dart';
import '../account_list.dart';
import '../../l10n.dart';

class AccountSwitchView extends ConsumerStatefulWidget {
  const AccountSwitchView({super.key});

  @override
  ConsumerState<AccountSwitchView> createState() => _AccountSwitchViewState();
}

class _AccountSwitchViewState extends ConsumerState<AccountSwitchView> {
  bool _isSelecting = false;

  Future<void> _selectAccount(AccountAddress address) async {
    if (_isSelecting) return;
    setState(() => _isSelecting = true);
    try {
      await ref.read(accountRepositoryProvider).selectAccount(address);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSelecting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).accountSwitchFailure),
        ),
      );
      return;
    }
    if (mounted && ModalRoute.of(context)?.isCurrent == true) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AccountListView(onSelect: _isSelecting ? null : _selectAccount);
  }
}
