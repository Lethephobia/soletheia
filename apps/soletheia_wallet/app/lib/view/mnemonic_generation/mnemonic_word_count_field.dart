import 'package:application/mnemonic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import 'mnemonic_generation_view_model.dart';

class MnemonicWordCountField extends ConsumerWidget {
  const MnemonicWordCountField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordCount = ref.watch(
      mnemonicGenerationViewModelProvider.select((state) => state.wordCount),
    );
    final viewModel = ref.read(mnemonicGenerationViewModelProvider.notifier);
    final l10n = AppLocalizations.of(context);
    return DropdownMenuFormField<MnemonicWordCount>(
      initialSelection: wordCount,
      expandedInsets: EdgeInsets.zero,
      selectOnly: true,
      label: Text(l10n.mnemonicGenerationWordCountLabel),
      dropdownMenuEntries: [
        for (final count in MnemonicWordCount.values)
          DropdownMenuEntry(value: count, label: '${count.words}'),
      ],
      onSelected: viewModel.selectWordCount,
    );
  }
}
