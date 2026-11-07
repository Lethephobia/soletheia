import 'package:flutter/services.dart' show MaxLengthEnforcement;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import 'mnemonic_generation_view_model.dart';

class MnemonicCustomEntropyField extends ConsumerWidget {
  const MnemonicCustomEntropyField({super.key});

  static const double _fieldSpacing = 24;
  static const _animationDuration = Duration(milliseconds: 200);
  static const int _entropyLines = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(mnemonicGenerationViewModelProvider);
    final viewModel = ref.read(mnemonicGenerationViewModelProvider.notifier);
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.tune),
          title: Text(l10n.mnemonicGenerationCustomEntropyLabel),
          value: form.customEntropy,
          onChanged: form.isGenerating ? null : viewModel.setCustomEntropy,
        ),
        AnimatedSize(
          duration: _animationDuration,
          alignment: Alignment.topCenter,
          child: form.customEntropy
              ? Padding(
                  padding: const EdgeInsets.only(top: _fieldSpacing),
                  child: TextFormField(
                    initialValue: form.entropy,
                    enabled: !form.isGenerating,
                    onChanged: viewModel.setEntropy,
                    minLines: _entropyLines,
                    maxLines: _entropyLines,
                    maxLength: form.hexLength,
                    maxLengthEnforcement: MaxLengthEnforcement.none,
                    autocorrect: false,
                    enableSuggestions: false,
                    spellCheckConfiguration:
                        const SpellCheckConfiguration.disabled(),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: l10n.mnemonicGenerationEntropyLabel,
                      helperText: l10n.mnemonicGenerationEntropyHint(
                        form.entropyBits,
                      ),
                    ),
                    validator: (value) {
                      if (!form.isValidEntropy(value)) {
                        return l10n.mnemonicGenerationEntropyError(
                          form.hexLength,
                        );
                      }
                      return null;
                    },
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
