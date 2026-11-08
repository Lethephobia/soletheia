import 'package:application/mnemonic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import 'account_creation_view_model.dart';

class MnemonicWordCountField extends ConsumerWidget {
  const MnemonicWordCountField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(accountCreationViewModelProvider);
    final viewModel = ref.read(accountCreationViewModelProvider.notifier);
    final l10n = AppLocalizations.of(context);
    return DropdownMenuFormField<MnemonicWordCount>(
      initialSelection: form.wordCount,
      enabled: !form.isFormLocked,
      expandedInsets: EdgeInsets.zero,
      selectOnly: true,
      label: Text(l10n.accountCreationWordCountLabel),
      dropdownMenuEntries: [
        for (final count in MnemonicWordCount.values)
          DropdownMenuEntry(value: count, label: '${count.words}'),
      ],
      onSelected: viewModel.selectWordCount,
    );
  }
}
