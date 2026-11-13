import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import '../../routing/account_list.dart';
import '../../routing/root.dart';
import 'settings_section.dart';

class SettingsView extends StatelessWidget {
  static const double _maxContentWidth = 560;
  static const double _contentPadding = 24;
  static const double _sectionSpacing = 24;

  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxContentWidth),
            child: ListView(
              padding: const EdgeInsets.all(_contentPadding),
              children: [
                SettingsSection(
                  title: l10n.settingsWalletSection,
                  tiles: [
                    ListTile(
                      leading: const Icon(
                        Icons.account_balance_wallet_outlined,
                      ),
                      title: Text(l10n.settingsAccountsLabel),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => const AccountListRoute().goRelative(context),
                    ),
                  ],
                ),
                const SizedBox(height: _sectionSpacing),
                SettingsSection(
                  title: l10n.settingsNetworkSection,
                  tiles: [
                    ListTile(
                      enabled: false,
                      leading: const Icon(Icons.hub_outlined),
                      title: Text(l10n.settingsClusterLabel),
                    ),
                    ListTile(
                      enabled: false,
                      leading: const Icon(Icons.dns_outlined),
                      title: Text(l10n.settingsRpcEndpointsLabel),
                    ),
                  ],
                ),
                const SizedBox(height: _sectionSpacing),
                SettingsSection(
                  title: l10n.settingsAboutSection,
                  tiles: [
                    ListTile(
                      leading: const Icon(Icons.description_outlined),
                      title: Text(
                        MaterialLocalizations.of(context).licensesPageTitle,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => const LicensesRoute().goRelative(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
