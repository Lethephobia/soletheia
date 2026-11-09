import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import '../../responsive.dart';
import '../../routing.dart';
import 'account_creation_view_model.dart';
import 'account_derivation_path_field.dart';
import 'mnemonic_custom_entropy_field.dart';
import 'mnemonic_passphrase_field.dart';
import 'mnemonic_word_count_field.dart';
import 'mnemonic_wordlist_field.dart';

class AccountCreationView extends ConsumerWidget {
  const AccountCreationView({super.key});

  static const double _maxContentWidth = 560;
  static const double _contentPadding = 24;
  static const double _wideTopPadding = 48;
  static const double _fieldSpacing = 12;
  static const double _sectionSpacing = 24;
  static const double _wordCountWidth = 144;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(accountCreationViewModelProvider);
    final l10n = AppLocalizations.of(context);
    ref.listen(
      accountCreationViewModelProvider.select((form) => form.creation),
      (_, next) {
        if (next is AsyncData) {
          const AccountListRoute().go(context);
        }
      },
    );
    return PopScope(
      canPop: !form.isFormLocked,
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.accountCreationTitle)),
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
                      const AccountDerivationPathField(),
                      const MnemonicPassphraseField(),
                      const MnemonicCustomEntropyField(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton(
                          onPressed: form.canSubmit
                              ? ref
                                    .read(
                                      accountCreationViewModelProvider.notifier,
                                    )
                                    .createAccount
                              : null,
                          child: Text(
                            form.created == null
                                ? l10n.accountCreationSubmitLabel
                                : l10n.accountCreationSaveRetry,
                          ),
                        ),
                      ),
                      if (form.creation case AsyncLoading())
                        const LinearProgressIndicator(),
                      if (form.creation case AsyncError())
                        Text(
                          form.created == null
                              ? l10n.accountCreationFailure
                              : l10n.accountCreationSaveFailure,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
