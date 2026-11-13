import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import '../../responsive.dart';
import '../../routing.dart';
import 'private_key_account_import_status.dart';
import 'private_key_account_import_view_model.dart';

class PrivateKeyAccountImportView extends ConsumerWidget {
  const PrivateKeyAccountImportView({super.key});

  static const double _maxContentWidth = 560;
  static const double _contentPadding = 24;
  static const double _fieldSpacing = 12;
  static const double _progressHeight = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(privateKeyAccountImportViewModelProvider);
    final l10n = AppLocalizations.of(context);
    ref.listen(
      privateKeyAccountImportViewModelProvider.select((form) => form.status),
      (_, next) {
        final message = switch (next) {
          PrivateKeyAccountImportSucceeded() =>
            l10n.mnemonicAccountImportSuccess,
          PrivateKeyAccountImportFailed() => l10n.mnemonicAccountImportFailure,
          PrivateKeyAccountImportSaveFailed() =>
            l10n.mnemonicAccountCreationSaveFailure,
          _ => null,
        };
        if (message == null) return;
        final messengerContext = next is PrivateKeyAccountImportSucceeded
            ? Navigator.of(context, rootNavigator: true).context
            : context;
        ScaffoldMessenger.of(messengerContext)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
        if (next is PrivateKeyAccountImportSucceeded) {
          const TokenRoute().go(context);
        }
      },
    );
    final surface = Theme.of(context).colorScheme.surfaceContainer;
    final isWide = Bp.of(context).isAtLeast(Bp.expanded);
    final material = MaterialLocalizations.of(context);
    final cancel = form.isFormLocked ? null : () => Navigator.of(context).pop();
    final onImport = form.canSubmit
        ? ref
              .read(privateKeyAccountImportViewModelProvider.notifier)
              .importPrivateKey
        : null;
    final importButton = TextButton(
      onPressed: onImport,
      child: Text(
        form.status is PrivateKeyAccountImportSaveFailed
            ? l10n.mnemonicAccountCreationSaveRetry
            : l10n.mnemonicAccountImportSubmitLabel,
      ),
    );
    final appBar = AppBar(
      backgroundColor: surface,
      automaticallyImplyLeading: false,
      leading: isWide
          ? null
          : IconButton(
              tooltip: material.closeButtonTooltip,
              icon: const Icon(Icons.close),
              onPressed: cancel,
            ),
      title: Text(l10n.onboardingImportPrivateKeyLabel),
      titleSpacing: isWide ? _contentPadding : null,
      actions: isWide ? null : [importButton],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(_progressHeight),
        child: SizedBox(
          width: double.infinity,
          height: _progressHeight,
          child: switch (form.status) {
            PrivateKeyAccountImporting() ||
            PrivateKeyAccountImportSaving() => const LinearProgressIndicator(),
            _ => null,
          },
        ),
      ),
    );
    final fields = SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxContentWidth),
        child: Padding(
          padding: const EdgeInsets.all(_contentPadding),
          child: form.keysImported
              ? const SizedBox.shrink()
              : TextField(
                  enabled: !form.isFormLocked,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  enableIMEPersonalizedLearning: false,
                  spellCheckConfiguration:
                      const SpellCheckConfiguration.disabled(),
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    labelText: l10n.privateKeyAccountImportKeyLabel,
                    helperText: l10n.privateKeyAccountImportKeyHelper,
                    helperMaxLines: 2,
                    errorText: form.hasPrivateKeyError
                        ? l10n.privateKeyAccountImportInvalidKey
                        : null,
                  ),
                  onChanged: ref
                      .read(privateKeyAccountImportViewModelProvider.notifier)
                      .setPrivateKey,
                ),
        ),
      ),
    );
    final actions = Padding(
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
          importButton,
        ],
      ),
    );
    return PopScope(
      canPop: !form.isFormLocked,
      child: isWide
          ? SafeArea(
              child: Dialog(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                clipBehavior: Clip.antiAlias,
                backgroundColor: surface,
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: appBar.preferredSize.height,
                          child: appBar,
                        ),
                        Flexible(child: fields),
                        actions,
                      ],
                    ),
                    // The dialog has its own messenger for status SnackBars.
                    const Positioned.fill(
                      child: IgnorePointer(
                        child: Scaffold(backgroundColor: Colors.transparent),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Dialog.fullscreen(
              child: Scaffold(
                backgroundColor: surface,
                appBar: appBar,
                body: SafeArea(
                  top: false,
                  child: Align(alignment: Alignment.topCenter, child: fields),
                ),
              ),
            ),
    );
  }
}
