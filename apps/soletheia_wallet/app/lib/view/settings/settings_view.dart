import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import '../../routing/root.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).settingsTitle)),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: Text(MaterialLocalizations.of(context).licensesPageTitle),
              onTap: () => const LicensesRoute().goRelative(context),
            ),
          ],
        ),
      ),
    );
  }
}
