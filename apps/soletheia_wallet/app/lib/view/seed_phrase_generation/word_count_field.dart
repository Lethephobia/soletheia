import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import 'seed_phrase_generation_view_model.dart';

class WordCountField extends ConsumerWidget {
  const WordCountField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordCount = ref.watch(
      seedPhraseGenerationViewModelProvider.select((state) => state.wordCount),
    );
    final viewModel = ref.read(seedPhraseGenerationViewModelProvider.notifier);
    final l10n = AppLocalizations.of(context);
    return DropdownMenuFormField<int>(
      initialSelection: wordCount,
      expandedInsets: EdgeInsets.zero,
      selectOnly: true,
      label: Text(l10n.seedGenerationWordCountLabel),
      dropdownMenuEntries: [
        for (final count in SeedPhraseGenerationViewModel.wordCounts)
          DropdownMenuEntry(value: count, label: '$count'),
      ],
      onSelected: viewModel.selectWordCount,
    );
  }
}
