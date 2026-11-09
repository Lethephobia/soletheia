import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import 'account_creation_view_model.dart';

class AccountDerivationPathField extends ConsumerWidget {
  const AccountDerivationPathField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(accountCreationViewModelProvider);
    final viewModel = ref.read(accountCreationViewModelProvider.notifier);
    final l10n = AppLocalizations.of(context);
    return TextFormField(
      initialValue: form.path,
      enabled: !form.isFormLocked,
      keyboardType: TextInputType.visiblePassword,
      autocorrect: false,
      enableSuggestions: false,
      onChanged: viewModel.setPath,
      decoration: InputDecoration(
        labelText: l10n.accountCreationDerivationPathLabel,
        errorText: form.parsedPath == null
            ? l10n.accountCreationInvalidPath
            : null,
      ),
    );
  }
}
