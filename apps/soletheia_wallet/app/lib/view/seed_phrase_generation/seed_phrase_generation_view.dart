import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import '../../responsive.dart';
import 'seed_phrase_generation_view_model.dart';

class SeedPhraseGenerationView extends ConsumerWidget {
  const SeedPhraseGenerationView({super.key});

  static const double _maxContentWidth = 560;
  static const double _contentPadding = 24;
  static const double _wideTopPadding = 48;
  static const double _fieldSpacing = 12;
  static const double _sectionSpacing = 24;
  static const double _wordCountWidth = 128;
  static const int _entropyLines = 3;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(seedPhraseGenerationViewModelProvider);
    final viewModel = ref.read(seedPhraseGenerationViewModelProvider.notifier);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.seedGenerationTitle)),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxContentWidth),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  _contentPadding,
                  Bp.of(context).isAtLeast(Bp.medium)
                      ? _wideTopPadding
                      : _contentPadding,
                  _contentPadding,
                  _contentPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: _sectionSpacing,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: _fieldSpacing,
                      children: [
                        Expanded(
                          child: DropdownMenuFormField<String>(
                            initialSelection: form.wordlist,
                            onSelected: viewModel.selectWordlist,
                            expandedInsets: EdgeInsets.zero,
                            selectOnly: true,
                            label: Text(l10n.seedGenerationWordlistLabel),
                            dropdownMenuEntries: [
                              DropdownMenuEntry(
                                value: 'en',
                                label: l10n.seedWordlistEnglish,
                              ),
                              DropdownMenuEntry(
                                value: 'ja',
                                label: l10n.seedWordlistJapanese,
                              ),
                              DropdownMenuEntry(
                                value: 'ko',
                                label: l10n.seedWordlistKorean,
                              ),
                              DropdownMenuEntry(
                                value: 'zh-Hans',
                                label: l10n.seedWordlistSimplifiedChinese,
                              ),
                              DropdownMenuEntry(
                                value: 'zh-Hant',
                                label: l10n.seedWordlistTraditionalChinese,
                              ),
                              DropdownMenuEntry(
                                value: 'fr',
                                label: l10n.seedWordlistFrench,
                              ),
                              DropdownMenuEntry(
                                value: 'it',
                                label: l10n.seedWordlistItalian,
                              ),
                              DropdownMenuEntry(
                                value: 'es',
                                label: l10n.seedWordlistSpanish,
                              ),
                              DropdownMenuEntry(
                                value: 'cs',
                                label: l10n.seedWordlistCzech,
                              ),
                              DropdownMenuEntry(
                                value: 'pt',
                                label: l10n.seedWordlistPortuguese,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: _wordCountWidth,
                          child: DropdownMenuFormField<int>(
                            initialSelection: form.wordCount,
                            expandedInsets: EdgeInsets.zero,
                            selectOnly: true,
                            label: Text(l10n.seedGenerationWordCountLabel),
                            dropdownMenuEntries: [
                              for (final count
                                  in SeedPhraseGenerationViewModel.wordCounts)
                                DropdownMenuEntry(
                                  value: count,
                                  label: '$count',
                                ),
                            ],
                            onSelected: viewModel.selectWordCount,
                          ),
                        ),
                      ],
                    ),
                    SwitchListTile(
                      title: Text(l10n.seedGenerationCustomEntropyLabel),
                      value: form.customEntropy,
                      onChanged: viewModel.setCustomEntropy,
                    ),
                    if (form.customEntropy)
                      TextFormField(
                        initialValue: form.entropy,
                        onChanged: viewModel.setEntropy,
                        minLines: _entropyLines,
                        maxLines: _entropyLines,
                        autocorrect: false,
                        enableSuggestions: false,
                        spellCheckConfiguration:
                            const SpellCheckConfiguration.disabled(),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: l10n.seedGenerationEntropyLabel,
                          helperText: l10n.seedGenerationEntropyHint(
                            form.entropyBits,
                            form.hexLength,
                          ),
                        ),
                        validator: (value) {
                          if (!form.isValidEntropy(value)) {
                            return l10n.seedGenerationEntropyError(
                              form.hexLength,
                            );
                          }
                          return null;
                        },
                      ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton(
                        onPressed: null,
                        child: Text(l10n.seedGenerationGenerateLabel),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
