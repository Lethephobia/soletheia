import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import 'account_creation_view_model.dart';
import 'entropy_validation_error.dart';

class MnemonicCustomEntropyField extends ConsumerWidget {
  const MnemonicCustomEntropyField({super.key});

  static const int _entropyLines = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(accountCreationViewModelProvider);
    final viewModel = ref.read(accountCreationViewModelProvider.notifier);
    final l10n = AppLocalizations.of(context);
    return TextFormField(
      initialValue: form.entropy,
      enabled: !form.isFormLocked,
      onChanged: viewModel.setEntropy,
      minLines: _entropyLines,
      maxLines: _entropyLines,
      keyboardType: TextInputType.visiblePassword,
      autocorrect: false,
      enableSuggestions: false,
      spellCheckConfiguration: const SpellCheckConfiguration.disabled(),
      decoration: InputDecoration(
        labelText: l10n.accountCreationCustomEntropyLabel,
        counterText: l10n.accountCreationEntropyCounter(
          form.entropy.characters.length,
          form.hexLength,
        ),
        errorText: switch (form.entropyError) {
          InvalidEntropyHex() => l10n.accountCreationEntropyInvalidHex,
          InvalidEntropyLength(:final expectedLength) =>
            l10n.accountCreationEntropyInvalidLength(expectedLength),
          null => null,
        },
        helperMaxLines: 3,
        helperText: l10n.accountCreationEntropyHint(form.hexLength),
      ),
    );
  }
}
