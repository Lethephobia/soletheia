import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import 'account_creation_view_model.dart';

class MnemonicPassphraseField extends ConsumerWidget {
  const MnemonicPassphraseField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(accountCreationViewModelProvider);
    final viewModel = ref.read(accountCreationViewModelProvider.notifier);
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
        labelText: l10n.accountCreationPassphraseLabel,
      ),
    );
  }
}
