import 'package:application/account.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import 'mnemonic_account_creation_view_model.dart';

class AccountDerivationPathField extends ConsumerWidget {
  const AccountDerivationPathField({super.key});

  static const _accountIndices = [0, 1, 2];
  static final _paths = [
    for (final index in _accountIndices)
      DerivationPath.bip44(
        account: Bip44AccountIndex(index),
        change: Bip44ChangeIndex(0),
      ).value,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(mnemonicAccountCreationViewModelProvider);
    final viewModel = ref.read(
      mnemonicAccountCreationViewModelProvider.notifier,
    );
    final l10n = AppLocalizations.of(context);
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: form.path),
      optionsBuilder: (value) {
        if (form.isFormLocked) return const [];
        final prefix = value.text.replaceAll("'", '');
        if (_paths.any((path) => path.replaceAll("'", '') == prefix)) {
          return _paths;
        }
        return _paths.where(
          (path) => path.replaceAll("'", '').startsWith(prefix),
        );
      },
      onSelected: viewModel.setPath,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          enabled: !form.isFormLocked,
          keyboardType: TextInputType.visiblePassword,
          autocorrect: false,
          enableSuggestions: false,
          onChanged: viewModel.setPath,
          onFieldSubmitted: (_) => onFieldSubmitted(),
          decoration: InputDecoration(
            labelText: l10n.mnemonicAccountCreationDerivationPathLabel,
            helperText: l10n.mnemonicAccountCreationRequiredHelper,
            errorText: form.pathError != null
                ? l10n.mnemonicAccountCreationInvalidPath
                : null,
          ),
        );
      },
    );
  }
}
