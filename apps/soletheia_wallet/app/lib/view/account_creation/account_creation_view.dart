import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import '../../responsive.dart';
import '../../routing.dart';
import 'account_creation_status.dart';
import 'account_creation_view_model.dart';
import 'account_derivation_path_field.dart';
import 'mnemonic_custom_entropy_field.dart';
import 'mnemonic_passphrase_field.dart';
import 'mnemonic_word_count_field.dart';
import 'mnemonic_wordlist_field.dart';

class AccountCreationView extends ConsumerWidget {
  const AccountCreationView({super.key});

  static const double _maxContentWidth = 560;
  static const double _maxDialogHeight = 620;
  static const double _contentPadding = 24;
  static const double _fieldSpacing = 12;
  static const double _sectionSpacing = 24;
  static const double _wordCountWidth = 144;
  static const double _progressHeight = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(accountCreationViewModelProvider);
    final l10n = AppLocalizations.of(context);
    ref.listen(accountCreationViewModelProvider.select((form) => form.status), (
      _,
      next,
    ) {
      final message = switch (next) {
        AccountCreationSucceeded() => l10n.accountCreationSuccess,
        AccountCreationFailed() => l10n.accountCreationFailure,
        AccountSaveFailed() => l10n.accountCreationSaveFailure,
        _ => null,
      };
      if (message == null) return;
      final messengerContext = next is AccountCreationSucceeded
          ? Navigator.of(context, rootNavigator: true).context
          : context;
      ScaffoldMessenger.of(messengerContext)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
      if (next is AccountCreationSucceeded) {
        const TokenRoute().go(context);
      }
    });
    final surface = Theme.of(context).colorScheme.surfaceContainer;
    final isWide = Bp.of(context).isAtLeast(Bp.expanded);
    final material = MaterialLocalizations.of(context);
    final cancel = form.isFormLocked ? null : () => Navigator.of(context).pop();
    final onCreate = form.canSubmit
        ? ref.read(accountCreationViewModelProvider.notifier).createAccount
        : null;
    final createButton = TextButton(
      onPressed: onCreate,
      child: Text(
        form.status is AccountSaveFailed
            ? l10n.accountCreationSaveRetry
            : l10n.accountCreationSubmitLabel,
      ),
    );
    final content = Scaffold(
      backgroundColor: surface,
      appBar: AppBar(
        backgroundColor: surface,
        automaticallyImplyLeading: false,
        leading: isWide
            ? null
            : IconButton(
                tooltip: material.closeButtonTooltip,
                icon: const Icon(Icons.close),
                onPressed: cancel,
              ),
        title: Text(l10n.accountCreationTitle),
        actions: isWide ? null : [createButton],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(_progressHeight),
          child: SizedBox(
            width: double.infinity,
            height: _progressHeight,
            child: switch (form.status) {
              AccountCreating() ||
              AccountSaving() => const LinearProgressIndicator(),
              _ => null,
            },
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: _maxContentWidth,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(_contentPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: _sectionSpacing,
                        children: [
                          Row(
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
                          MnemonicCustomEntropyField(),
                          MnemonicPassphraseField(),
                          AccountDerivationPathField(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (isWide)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  _contentPadding,
                  0,
                  _contentPadding,
                  _contentPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: _fieldSpacing,
                  children: [
                    TextButton(
                      onPressed: cancel,
                      child: Text(material.cancelButtonLabel),
                    ),
                    createButton,
                  ],
                ),
              ),
          ],
        ),
      ),
    );
    return PopScope(
      canPop: !form.isFormLocked,
      child: isWide
          ? SafeArea(
              child: Dialog(
                constraints: const BoxConstraints(
                  maxWidth: _maxContentWidth,
                  maxHeight: _maxDialogHeight,
                ),
                clipBehavior: Clip.antiAlias,
                child: content,
              ),
            )
          : Dialog.fullscreen(child: content),
    );
  }
}
