import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import 'account_setup_option_tile.dart';

class AccountSetupView extends StatelessWidget {
  static const double _optionSpacing = 2;

  const AccountSetupView({
    super.key,
    this.onGenerateSeedPhrase,
    this.onImportSeedPhrase,
    this.onImportPrivateKey,
  });

  final VoidCallback? onGenerateSeedPhrase;
  final VoidCallback? onImportSeedPhrase;
  final VoidCallback? onImportPrivateKey;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: _optionSpacing,
          children: [
            AccountSetupOptionTile(
              icon: Icons.add,
              title: l10n.onboardingGenerateSeedPhraseLabel,
              subtitle: l10n.onboardingGenerateSeedPhraseDescription,
              onTap: onGenerateSeedPhrase,
              isFirst: true,
            ),
            AccountSetupOptionTile(
              icon: Icons.text_snippet_outlined,
              title: l10n.onboardingImportSeedPhraseLabel,
              subtitle: l10n.onboardingImportSeedPhraseDescription,
              onTap: onImportSeedPhrase,
            ),
            AccountSetupOptionTile(
              icon: Icons.key_outlined,
              title: l10n.onboardingImportPrivateKeyLabel,
              subtitle: l10n.onboardingImportPrivateKeyDescription,
              onTap: onImportPrivateKey,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}
