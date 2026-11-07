import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import 'onboarding_option_tile.dart';

class OnboardingView extends StatelessWidget {
  static const double _maxContentWidth = 560;
  static const double _contentPadding = 24;
  static const double _optionSpacing = 2;

  const OnboardingView({
    super.key,
    required this.onLicenses,
    this.onGenerateSeedPhrase,
    this.onImportSeedPhrase,
    this.onImportPrivateKey,
  });

  final VoidCallback onLicenses;
  final VoidCallback? onGenerateSeedPhrase;
  final VoidCallback? onImportSeedPhrase;
  final VoidCallback? onImportPrivateKey;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxContentWidth),
              child: Padding(
                padding: const EdgeInsets.all(_contentPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: _optionSpacing,
                  children: [
                    OnboardingOptionTile(
                      icon: Icons.add,
                      title: l10n.onboardingGenerateSeedPhraseLabel,
                      subtitle: l10n.onboardingGenerateSeedPhraseDescription,
                      onTap: onGenerateSeedPhrase,
                      isFirst: true,
                    ),
                    OnboardingOptionTile(
                      icon: Icons.text_snippet_outlined,
                      title: l10n.onboardingImportSeedPhraseLabel,
                      subtitle: l10n.onboardingImportSeedPhraseDescription,
                      onTap: onImportSeedPhrase,
                    ),
                    OnboardingOptionTile(
                      icon: Icons.key_outlined,
                      title: l10n.onboardingImportPrivateKeyLabel,
                      subtitle: l10n.onboardingImportPrivateKeyDescription,
                      onTap: onImportPrivateKey,
                      isLast: true,
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: onLicenses,
                        child: Text(
                          MaterialLocalizations.of(context).licensesPageTitle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
