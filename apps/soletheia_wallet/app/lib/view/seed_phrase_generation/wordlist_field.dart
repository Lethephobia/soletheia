import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import 'seed_phrase_generation_view_model.dart';

class WordlistField extends ConsumerWidget {
  const WordlistField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordlist = ref.watch(
      seedPhraseGenerationViewModelProvider.select((state) => state.wordlist),
    );
    final viewModel = ref.read(seedPhraseGenerationViewModelProvider.notifier);
    final l10n = AppLocalizations.of(context);
    return DropdownMenuFormField<String>(
      initialSelection: wordlist,
      onSelected: viewModel.selectWordlist,
      expandedInsets: EdgeInsets.zero,
      selectOnly: true,
      label: Text(l10n.seedGenerationWordlistLabel),
      dropdownMenuEntries: [
        DropdownMenuEntry(value: 'en', label: l10n.seedWordlistEnglish),
        DropdownMenuEntry(value: 'ja', label: l10n.seedWordlistJapanese),
        DropdownMenuEntry(value: 'ko', label: l10n.seedWordlistKorean),
        DropdownMenuEntry(
          value: 'zh-Hans',
          label: l10n.seedWordlistSimplifiedChinese,
        ),
        DropdownMenuEntry(
          value: 'zh-Hant',
          label: l10n.seedWordlistTraditionalChinese,
        ),
        DropdownMenuEntry(value: 'fr', label: l10n.seedWordlistFrench),
        DropdownMenuEntry(value: 'it', label: l10n.seedWordlistItalian),
        DropdownMenuEntry(value: 'es', label: l10n.seedWordlistSpanish),
        DropdownMenuEntry(value: 'cs', label: l10n.seedWordlistCzech),
        DropdownMenuEntry(value: 'pt', label: l10n.seedWordlistPortuguese),
      ],
    );
  }
}
