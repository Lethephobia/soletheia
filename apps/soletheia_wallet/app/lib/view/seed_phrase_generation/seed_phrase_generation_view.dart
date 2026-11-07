import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import '../../responsive.dart';

class SeedPhraseGenerationView extends StatefulWidget {
  const SeedPhraseGenerationView({super.key});

  @override
  State<SeedPhraseGenerationView> createState() {
    return _SeedPhraseGenerationViewState();
  }
}

class _SeedPhraseGenerationViewState extends State<SeedPhraseGenerationView> {
  static const double _maxContentWidth = 560;
  static const double _contentPadding = 24;
  static const double _wideTopPadding = 48;
  static const double _fieldSpacing = 12;
  static const double _sectionSpacing = 24;
  static const double _wordCountWidth = 128;
  static const int _entropyLines = 3;
  static const _wordCounts = [12, 15, 18, 21, 24];

  final _entropyController = TextEditingController();
  int _wordCount = 12;
  bool _customEntropy = false;

  int get _entropyBits => _wordCount ~/ 3 * 32;
  int get _hexLength => _entropyBits ~/ 4;

  @override
  void dispose() {
    _entropyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                            initialSelection: 'en',
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
                            initialSelection: _wordCount,
                            expandedInsets: EdgeInsets.zero,
                            selectOnly: true,
                            label: Text(l10n.seedGenerationWordCountLabel),
                            dropdownMenuEntries: [
                              for (final count in _wordCounts)
                                DropdownMenuEntry(
                                  value: count,
                                  label: '$count',
                                ),
                            ],
                            onSelected: (value) {
                              if (value != null) {
                                setState(() => _wordCount = value);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SwitchListTile(
                      title: Text(l10n.seedGenerationCustomEntropyLabel),
                      value: _customEntropy,
                      onChanged: (value) {
                        setState(() => _customEntropy = value);
                      },
                    ),
                    if (_customEntropy)
                      TextFormField(
                        controller: _entropyController,
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
                            _entropyBits,
                            _hexLength,
                          ),
                        ),
                        validator: (value) {
                          final hex = value?.trim() ?? '';
                          if (hex.length != _hexLength ||
                              !RegExp(r'^[0-9a-fA-F]+$').hasMatch(hex)) {
                            return l10n.seedGenerationEntropyError(_hexLength);
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
