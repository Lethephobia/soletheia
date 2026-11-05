// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:soletheia/app.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: App()));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
  testWidgets('Follows system language and falls back to English', (
    tester,
  ) async {
    final dispatcher = tester.binding.platformDispatcher;
    addTearDown(dispatcher.clearLocalesTestValue);
    dispatcher.localesTestValue = [const Locale('ja', 'JP')];

    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();
    expect(find.text('ホーム'), findsOneWidget);
    expect(find.byTooltip('増やす'), findsOneWidget);
    expect(
      MaterialLocalizations.of(tester.element(find.byType(Scaffold)))
          .backButtonTooltip,
      '戻る',
    );

    dispatcher.localesTestValue = [const Locale('en', 'US')];
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
    expect(find.byTooltip('Increment'), findsOneWidget);

    dispatcher.localesTestValue = [const Locale('fr', 'FR')];
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
    expect(
      Localizations.localeOf(tester.element(find.byType(Scaffold)))
          .languageCode,
      'en',
    );
  });
}
