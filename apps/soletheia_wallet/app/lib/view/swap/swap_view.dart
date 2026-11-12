import 'package:material_ui/material_ui.dart';

import '../../account/account_menu_button.dart';
import '../../l10n.dart';

class SwapView extends StatelessWidget {
  const SwapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [AccountMenuButton()],
        title: Text(AppLocalizations.of(context).swapTitle),
      ),
    );
  }
}
