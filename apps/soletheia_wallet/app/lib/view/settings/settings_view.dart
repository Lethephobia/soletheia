import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(AppLocalizations.of(context).settingsTitle)),
    body: const SafeArea(child: SizedBox.expand()),
  );
}
