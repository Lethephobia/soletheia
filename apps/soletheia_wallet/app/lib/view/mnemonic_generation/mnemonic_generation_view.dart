import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import '../../responsive.dart';
import 'custom_entropy_field.dart';
import 'word_count_field.dart';
import 'wordlist_field.dart';

class MnemonicGenerationView extends StatelessWidget {
  const MnemonicGenerationView({super.key});

  static const double _maxContentWidth = 560;
  static const double _contentPadding = 24;
  static const double _wideTopPadding = 48;
  static const double _fieldSpacing = 12;
  static const double _sectionSpacing = 24;
  static const double _wordCountWidth = 128;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.mnemonicGenerationTitle)),
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
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: _fieldSpacing,
                      children: [
                        Expanded(child: WordlistField()),
                        SizedBox(
                          width: _wordCountWidth,
                          child: WordCountField(),
                        ),
                      ],
                    ),
                    const CustomEntropyField(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton(
                        onPressed: null,
                        child: Text(l10n.mnemonicGenerationGenerateLabel),
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
