import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';

class MnemonicPhraseField extends StatelessWidget {
  const MnemonicPhraseField({
    super.key,
    required this.phrase,
    required this.enabled,
    required this.hasError,
    required this.onChanged,
  });

  final String phrase;
  final bool enabled;
  final bool hasError;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextFormField(
      initialValue: phrase,
      enabled: enabled,
      minLines: 3,
      maxLines: 5,
      autocorrect: false,
      enableSuggestions: false,
      enableIMEPersonalizedLearning: false,
      spellCheckConfiguration: const SpellCheckConfiguration.disabled(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: l10n.mnemonicAccountImportPhraseLabel,
        helperText: l10n.mnemonicAccountCreationRequiredHelper,
        errorText: hasError ? l10n.mnemonicAccountImportInvalidPhrase : null,
      ),
    );
  }
}
