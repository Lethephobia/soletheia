import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import 'mnemonic_account_import_view_model.dart';

class MnemonicAccountImportPassphraseField extends ConsumerWidget {
  const MnemonicAccountImportPassphraseField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(mnemonicAccountImportViewModelProvider);
    final viewModel = ref.read(mnemonicAccountImportViewModelProvider.notifier);
    final l10n = AppLocalizations.of(context);
    return TextFormField(
      initialValue: form.passphrase,
      enabled: !form.isFormLocked,
      keyboardType: TextInputType.visiblePassword,
      autocorrect: false,
      enableSuggestions: false,
      obscureText: true,
      onChanged: viewModel.setPassphrase,
      decoration: InputDecoration(
        labelText: l10n.mnemonicAccountCreationPassphraseLabel,
      ),
    );
  }
}
