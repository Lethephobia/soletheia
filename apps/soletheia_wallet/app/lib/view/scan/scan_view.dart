import 'package:material_ui/material_ui.dart';

import '../../account/account_menu_button.dart';
import '../../l10n.dart';

class ScanView extends StatelessWidget {
  const ScanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [AccountMenuButton()],
        title: Text(AppLocalizations.of(context).scanLabel),
      ),
    );
  }
}
