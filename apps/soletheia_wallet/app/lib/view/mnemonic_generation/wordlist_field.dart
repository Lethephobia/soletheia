import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import 'mnemonic_generation_view_model.dart';

class WordlistField extends ConsumerWidget {
  const WordlistField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordlist = ref.watch(
      mnemonicGenerationViewModelProvider.select((state) => state.wordlist),
    );
    final viewModel = ref.read(mnemonicGenerationViewModelProvider.notifier);
    final l10n = AppLocalizations.of(context);
    return DropdownMenuFormField<String>(
      initialSelection: wordlist,
      onSelected: viewModel.selectWordlist,
      expandedInsets: EdgeInsets.zero,
      selectOnly: true,
      label: Text(l10n.mnemonicGenerationWordlistLabel),
      dropdownMenuEntries: [
        DropdownMenuEntry(value: 'en', label: l10n.mnemonicWordlistEnglish),
        DropdownMenuEntry(value: 'ja', label: l10n.mnemonicWordlistJapanese),
        DropdownMenuEntry(value: 'ko', label: l10n.mnemonicWordlistKorean),
        DropdownMenuEntry(
          value: 'zh-Hans',
          label: l10n.mnemonicWordlistSimplifiedChinese,
        ),
        DropdownMenuEntry(
          value: 'zh-Hant',
          label: l10n.mnemonicWordlistTraditionalChinese,
        ),
        DropdownMenuEntry(value: 'fr', label: l10n.mnemonicWordlistFrench),
        DropdownMenuEntry(value: 'it', label: l10n.mnemonicWordlistItalian),
        DropdownMenuEntry(value: 'es', label: l10n.mnemonicWordlistSpanish),
        DropdownMenuEntry(value: 'cs', label: l10n.mnemonicWordlistCzech),
        DropdownMenuEntry(value: 'pt', label: l10n.mnemonicWordlistPortuguese),
      ],
    );
  }
}
