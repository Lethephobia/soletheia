import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';

class AccountSetupView extends StatelessWidget {
  const AccountSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.onboardingTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Text(l10n.onboardingPlaceholderMessage, textAlign: TextAlign.center),
      ],
    );
  }
}
