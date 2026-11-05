import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:soletheia/app.dart';

void main() {
  testWidgets('stays dark regardless of system brightness', (tester) async {
    final allowRuntimeFetching = GoogleFonts.config.allowRuntimeFetching;
    GoogleFonts.config.allowRuntimeFetching = false;
    addTearDown(() {
      GoogleFonts.config.allowRuntimeFetching = allowRuntimeFetching;
    });
    final dispatcher = tester.binding.platformDispatcher;
    addTearDown(dispatcher.clearPlatformBrightnessTestValue);
    dispatcher.platformBrightnessTestValue = Brightness.light;

    await tester.pumpWidget(const App());
    await tester.runAsync(() => GoogleFonts.pendingFonts());
    await tester.pumpAndSettle();

    final theme = Theme.of(tester.element(find.byType(Scaffold)));
    expect(theme.textTheme.bodyMedium?.fontFamily, startsWith('NotoSansJP'));
    expect(
      theme.primaryTextTheme.bodyMedium?.fontFamily,
      startsWith('NotoSansJP'),
    );

    Brightness brightness() =>
        Theme.of(tester.element(find.byType(Scaffold))).brightness;
    expect(brightness(), Brightness.dark);

    dispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpAndSettle();
    expect(brightness(), Brightness.dark);

    dispatcher.platformBrightnessTestValue = Brightness.light;
    await tester.pumpAndSettle();
    expect(brightness(), Brightness.dark);
  });
}
