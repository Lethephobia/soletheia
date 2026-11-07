import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import 'seed_phrase_generation_view_model.dart';

class CustomEntropyField extends ConsumerWidget {
  const CustomEntropyField({super.key});

  static const double _fieldSpacing = 24;
  static const int _entropyLines = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(seedPhraseGenerationViewModelProvider);
    final viewModel = ref.read(seedPhraseGenerationViewModelProvider.notifier);
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: _fieldSpacing,
      children: [
        SwitchListTile(
          title: Text(l10n.seedGenerationCustomEntropyLabel),
          value: form.customEntropy,
          onChanged: viewModel.setCustomEntropy,
        ),
        if (form.customEntropy)
          TextFormField(
            initialValue: form.entropy,
            onChanged: viewModel.setEntropy,
            minLines: _entropyLines,
            maxLines: _entropyLines,
            autocorrect: false,
            enableSuggestions: false,
            spellCheckConfiguration: const SpellCheckConfiguration.disabled(),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: l10n.seedGenerationEntropyLabel,
              helperText: l10n.seedGenerationEntropyHint(
                form.entropyBits,
                form.hexLength,
              ),
            ),
            validator: (value) {
              if (!form.isValidEntropy(value)) {
                return l10n.seedGenerationEntropyError(form.hexLength);
              }
              return null;
            },
          ),
      ],
    );
  }
}
