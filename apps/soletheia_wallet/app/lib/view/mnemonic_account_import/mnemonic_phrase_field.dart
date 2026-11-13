import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';

class MnemonicPhraseField extends StatefulWidget {
  const MnemonicPhraseField({
    super.key,
    required this.phrase,
    required this.enabled,
    required this.hasError,
    required this.onChanged,
  });

  final String phrase;
  final bool enabled;
  final bool hasError;
  final ValueChanged<String> onChanged;

  @override
  State<MnemonicPhraseField> createState() => _MnemonicPhraseFieldState();
}

class _MnemonicPhraseFieldState extends State<MnemonicPhraseField> {
  static final _separator = RegExp(r'\s+');
  // Gives software keyboards one character to delete when the draft is empty.
  static const _backspaceAnchor = '\u200B';
  static const _editorWidth = 120.0;
  static const _spacing = 4.0;

  final _controller = TextEditingController();
  final _focus = FocusNode();
  final _words = <String>[];
  int _index = 0;
  bool _updating = false;
  bool _hadAnchor = false;

  String get _draft => _controller.text.replaceAll(_backspaceAnchor, '');

  String get _phrase {
    return [
      ..._words.take(_index),
      _draft,
      ..._words.skip(_index),
    ].where((word) => word.isNotEmpty).join(' ');
  }

  @override
  void initState() {
    super.initState();
    _load(widget.phrase);
    _controller.addListener(_onEdit);
    _focus.addListener(_onFocus);
  }

  void _load(String phrase) {
    _words
      ..clear()
      ..addAll(phrase.split(_separator).where((word) => word.isNotEmpty));
    _index = _words.length;
    _setDraft('');
  }

  @override
  void didUpdateWidget(MnemonicPhraseField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.phrase != oldWidget.phrase && widget.phrase != _phrase) {
      _load(widget.phrase);
    }
  }

  void _setDraft(String text) {
    final value = text.isEmpty && _index > 0 ? _backspaceAnchor : text;
    _hadAnchor = value == _backspaceAnchor;
    _updating = true;
    _controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
    _updating = false;
  }

  void _onFocus() {
    if (!_focus.hasFocus && _draft.isNotEmpty) {
      _commitDraft();
      _index = _words.length;
      _setDraft('');
      if (_phrase != widget.phrase) widget.onChanged(_phrase);
    }
    setState(() {});
  }

  void _onEdit() {
    if (_updating || !widget.enabled) return;
    final value = _controller.value;
    if (value.text.isEmpty && _index > 0 && _hadAnchor) {
      _editWord(_index - 1);
      return;
    }
    if (value.composing.isCollapsed || !value.composing.isValid) {
      final parts = _draft.split(_separator);
      if (parts.length > 1) {
        // A multi-word edit (such as a pasted phrase) completes the last word too.
        _index += _commitDraft();
        _setDraft('');
      } else if (_draft.isEmpty && _index > 0 && value.text.isEmpty) {
        _setDraft('');
      }
    }
    _hadAnchor = _controller.text == _backspaceAnchor;
    setState(() {});
    if (_phrase != widget.phrase) widget.onChanged(_phrase);
  }

  int _commitDraft() {
    final draftWords = _draft
        .split(_separator)
        .where((word) => word.isNotEmpty)
        .toList();
    _words.insertAll(_index, draftWords);
    return draftWords.length;
  }

  void _startNewWord() {
    _commitDraft();
    _index = _words.length;
    _setDraft('');
    _focus.requestFocus();
    setState(() {});
    if (_phrase != widget.phrase) widget.onChanged(_phrase);
  }

  void _editWord(int index) {
    final word = _words[index];
    final inserted = _commitDraft();
    if (index >= _index) index += inserted;
    _words.removeAt(index);
    _index = index;
    _setDraft(word);
    _focus.requestFocus();
    setState(() {});
    if (_phrase != widget.phrase) widget.onChanged(_phrase);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final draftWordCount = _draft
        .split(_separator)
        .where((word) => word.isNotEmpty)
        .length;
    final numberStyle = Theme.of(context).textTheme.labelSmall;
    final editor = SizedBox(
      key: const ValueKey('mnemonic-word-editor'),
      width: _editorWidth,
      child: Semantics(
        label: l10n.mnemonicAccountImportPhraseLabel,
        child: TextField(
          controller: _controller,
          focusNode: _focus,
          enabled: widget.enabled,
          autocorrect: false,
          enableSuggestions: false,
          enableIMEPersonalizedLearning: false,
          spellCheckConfiguration: const SpellCheckConfiguration.disabled(),
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          maxLines: null,
          decoration: const InputDecoration.collapsed(hintText: ''),
        ),
      ),
    );
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.enabled ? _startNewWord : null,
      child: InputDecorator(
        isFocused: _focus.hasFocus,
        isEmpty: _words.isEmpty && _draft.isEmpty,
        decoration: InputDecoration(
          enabled: widget.enabled,
          labelText: l10n.mnemonicAccountImportPhraseLabel,
          helperText: l10n.mnemonicAccountCreationRequiredHelper,
          errorText: widget.hasError
              ? l10n.mnemonicAccountImportInvalidPhrase
              : null,
        ),
        child: Wrap(
          spacing: _spacing,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (var i = 0; i <= _words.length; i++) ...[
              if (i == _index) editor,
              if (i < _words.length)
                InputChip(
                  avatar: Text(
                    '${i + 1 + (i >= _index ? draftWordCount : 0)}.',
                    style: numberStyle,
                  ),
                  label: Text(_words[i]),
                  onPressed: widget.enabled ? () => _editWord(i) : null,
                ),
            ],
            if (_index < _words.length)
              const SizedBox(
                width: _editorWidth,
                height: kMinInteractiveDimension,
              ),
          ],
        ),
      ),
    );
  }
}
