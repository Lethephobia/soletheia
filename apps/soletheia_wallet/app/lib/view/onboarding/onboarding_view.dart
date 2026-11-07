import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import '../../routing/root.dart';
import 'onboarding_option_tile.dart';

class OnboardingView extends StatelessWidget {
  static const double _maxContentWidth = 560;
  static const double _contentPadding = 24;
  static const double _optionSpacing = 2;

  const OnboardingView({super.key});

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
                      title: l10n.onboardingGenerateMnemonicLabel,
                      subtitle: l10n.onboardingGenerateMnemonicDescription,
                      onTap: () {
                        const MnemonicGenerationRoute().goRelative(context);
                      },
                      isFirst: true,
                    ),
                    OnboardingOptionTile(
                      icon: Icons.text_snippet_outlined,
                      title: l10n.onboardingImportMnemonicLabel,
                      subtitle: l10n.onboardingImportMnemonicDescription,
                    ),
                    OnboardingOptionTile(
                      icon: Icons.key_outlined,
                      title: l10n.onboardingImportPrivateKeyLabel,
                      subtitle: l10n.onboardingImportPrivateKeyDescription,
                      isLast: true,
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: () =>
                            const LicensesRoute().goRelative(context),
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
