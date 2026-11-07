import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.onLicenses});

  final VoidCallback onLicenses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).settingsTitle)),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: Text(MaterialLocalizations.of(context).licensesPageTitle),
              onTap: onLicenses,
            ),
          ],
        ),
      ),
    );
  }
}
