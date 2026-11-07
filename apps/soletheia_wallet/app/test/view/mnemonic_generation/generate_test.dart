import 'dart:async';

import 'package:application/mnemonic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:soletheia/app.dart';
import 'package:soletheia/mnemonic.dart';

class _Generator implements MnemonicGenerator {
  final calls = <(MnemonicWordlist, MnemonicGenerationSource)>[];
  late Completer<Mnemonic> response;

  @override
  Future<Mnemonic> generate({
    required MnemonicWordlist wordlist,
    required MnemonicGenerationSource source,
  }) {
    calls.add((wordlist, source));
    response = Completer<Mnemonic>();
    return response.future;
  }
}

void main() {
  testWidgets('reopening the generation screen resets its form', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Generate mnemonic'));
    await tester.pumpAndSettle();
    final toggle = find.byType(SwitchListTile);
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).last, 'abcd');

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Generate mnemonic'));
    await tester.pumpAndSettle();
    expect(tester.widget<SwitchListTile>(toggle).value, isFalse);
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField).last).controller!.text,
      isEmpty,
    );
  });

  testWidgets('closing a generating screen discards its pending result', (
    tester,
  ) async {
    final generator = _Generator();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [mnemonicGeneratorProvider.overrideWithValue(generator)],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Generate mnemonic'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Generate'));
    await tester.pump();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Generate mnemonic'));
    await tester.pumpAndSettle();
    generator.response.complete(Mnemonic([const MnemonicWord('discarded')]));
    await tester.pumpAndSettle();
    expect(find.text('discarded'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Generate uses the selected options and displays returned words',
    (tester) async {
      final generator = _Generator();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [mnemonicGeneratorProvider.overrideWithValue(generator)],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Generate mnemonic'));
      await tester.pumpAndSettle();
      final generate = find.widgetWithText(FilledButton, 'Generate');
      await tester.tap(generate);
      await tester.pump();
      expect(generator.calls.single, (
        MnemonicWordlist.english,
        const MnemonicGenerationSource.random(MnemonicWordCount.words12),
      ));
      expect(tester.widget<FilledButton>(generate).onPressed, isNull);
      generator.response.completeError(StateError('test failure'));
      await tester.pumpAndSettle();
      expect(
        find.text('Could not generate the mnemonic. Try again.'),
        findsOneWidget,
      );

      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(generate).onPressed, isNull);
      await tester.enterText(
        find.byType(TextFormField).last,
        '0102030405060708090A0b0c0d0e0f10',
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(generate);
      await tester.tap(generate);
      await tester.pump();
      void expectFormEnabled(bool enabled) {
        final menus = tester.widgetList<DropdownMenu<dynamic>>(
          find.byWidgetPredicate((widget) => widget is DropdownMenu<dynamic>),
        );
        expect(menus.map((menu) => menu.enabled), [enabled, enabled]);
        final toggle = tester.widget<SwitchListTile>(
          find.byType(SwitchListTile),
        );
        expect(toggle.onChanged != null, enabled);
        final entropy = tester.widget<TextField>(find.byType(TextField).last);
        expect(entropy.enabled, enabled);
        expect(
          tester.widget<FilledButton>(generate).onPressed != null,
          enabled,
        );
      }

      expectFormEnabled(false);
      final source = generator.calls.last.$2 as EntropyMnemonicGenerationSource;
      expect(source.entropy.bytes, List.generate(16, (i) => i + 1));
      generator.response.complete(
        Mnemonic([const MnemonicWord('first'), const MnemonicWord('second')]),
      );
      await tester.pumpAndSettle();
      expect(find.text('first second'), findsOneWidget);
      expectFormEnabled(true);
    },
  );
}
