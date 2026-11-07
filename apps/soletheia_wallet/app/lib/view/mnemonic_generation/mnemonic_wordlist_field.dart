import 'package:application/mnemonic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import 'mnemonic_generation_view_model.dart';

class MnemonicWordlistField extends ConsumerWidget {
  const MnemonicWordlistField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordlist = ref.watch(
      mnemonicGenerationViewModelProvider.select((state) => state.wordlist),
    );
    final viewModel = ref.read(mnemonicGenerationViewModelProvider.notifier);
    final l10n = AppLocalizations.of(context);
    return DropdownMenuFormField<MnemonicWordlist>(
      initialSelection: wordlist,
      onSelected: viewModel.selectWordlist,
      expandedInsets: EdgeInsets.zero,
      selectOnly: true,
      label: Text(l10n.mnemonicGenerationWordlistLabel),
      dropdownMenuEntries: [
        DropdownMenuEntry(
          value: MnemonicWordlist.english,
          label: l10n.mnemonicWordlistEnglish,
        ),
        DropdownMenuEntry(
          value: MnemonicWordlist.japanese,
          label: l10n.mnemonicWordlistJapanese,
        ),
        DropdownMenuEntry(
          value: MnemonicWordlist.korean,
          label: l10n.mnemonicWordlistKorean,
        ),
        DropdownMenuEntry(
          value: MnemonicWordlist.simplifiedChinese,
          label: l10n.mnemonicWordlistSimplifiedChinese,
        ),
        DropdownMenuEntry(
          value: MnemonicWordlist.traditionalChinese,
          label: l10n.mnemonicWordlistTraditionalChinese,
        ),
        DropdownMenuEntry(
          value: MnemonicWordlist.french,
          label: l10n.mnemonicWordlistFrench,
        ),
        DropdownMenuEntry(
          value: MnemonicWordlist.italian,
          label: l10n.mnemonicWordlistItalian,
        ),
        DropdownMenuEntry(
          value: MnemonicWordlist.spanish,
          label: l10n.mnemonicWordlistSpanish,
        ),
        DropdownMenuEntry(
          value: MnemonicWordlist.czech,
          label: l10n.mnemonicWordlistCzech,
        ),
        DropdownMenuEntry(
          value: MnemonicWordlist.portuguese,
          label: l10n.mnemonicWordlistPortuguese,
        ),
      ],
    );
  }
}
