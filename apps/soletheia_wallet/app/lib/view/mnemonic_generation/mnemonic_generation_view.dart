import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import '../../responsive.dart';
import 'mnemonic_custom_entropy_field.dart';
import 'mnemonic_generation_view_model.dart';
import 'mnemonic_word_count_field.dart';
import 'mnemonic_wordlist_field.dart';

class MnemonicGenerationView extends ConsumerWidget {
  const MnemonicGenerationView({super.key});

  static const double _maxContentWidth = 560;
  static const double _contentPadding = 24;
  static const double _wideTopPadding = 48;
  static const double _fieldSpacing = 12;
  static const double _sectionSpacing = 24;
  static const double _wordCountWidth = 128;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(mnemonicGenerationViewModelProvider);
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
                        Expanded(child: MnemonicWordlistField()),
                        SizedBox(
                          width: _wordCountWidth,
                          child: MnemonicWordCountField(),
                        ),
                      ],
                    ),
                    const MnemonicCustomEntropyField(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton(
                        onPressed: form.canGenerate
                            ? ref
                                  .read(
                                    mnemonicGenerationViewModelProvider
                                        .notifier,
                                  )
                                  .generate
                            : null,
                        child: Text(l10n.mnemonicGenerationGenerateLabel),
                      ),
                    ),
                    if (form.generation case AsyncLoading())
                      const LinearProgressIndicator(),
                    if (form.generation case AsyncError())
                      Text(l10n.mnemonicGenerationFailure),
                    if (form.generation case AsyncData(:final value))
                      Text(value.words.map((word) => word.value).join(' ')),
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
