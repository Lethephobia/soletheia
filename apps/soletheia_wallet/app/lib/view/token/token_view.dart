import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import '../../account/account_menu_button.dart';

class TokenView extends StatelessWidget {
  const TokenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [AccountMenuButton()],
        title: Text(AppLocalizations.of(context).tokenTitle),
      ),
    );
  }
}
