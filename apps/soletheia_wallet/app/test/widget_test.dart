import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:soletheia/app.dart';
import 'package:soletheia/routing.dart';
import 'package:soletheia/view.dart';

void main() {
  testWidgets(
    'switches branches and preserves them across responsive layouts',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(390, 844);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      await tester.pumpWidget(const ProviderScope(child: App()));
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
      expect(find.text('No accounts'), findsOneWidget);
      final accountsElement = tester.element(find.byType(AccountListView));

      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsView), findsOneWidget);
      expect(find.byType(AccountListView), findsNothing);
      expect(accountsElement.mounted, isTrue);
      final settingsElement = tester.element(find.byType(SettingsView));

      tester.view.physicalSize = const Size(1024, 768);
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(tester.element(find.byType(SettingsView)), same(settingsElement));
      expect(
        tester
            .widget<NavigationRail>(find.byType(NavigationRail))
            .selectedIndex,
        1,
      );

      await tester.tap(find.byIcon(Icons.account_circle_outlined));
      await tester.pumpAndSettle();
      expect(
        tester.element(find.byType(AccountListView)),
        same(accountsElement),
      );

      tester.view.physicalSize = const Size(390, 844);
      await tester.pumpAndSettle();
      expect(
        tester.element(find.byType(AccountListView)),
        same(accountsElement),
      );
      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        0,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('typed settings route selects the settings branch', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final router = container.read(routerProvider);
    router.go(const SettingsRoute().location);
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SettingsView), findsOneWidget);
    expect(
      tester.widget<NavigationRail>(find.byType(NavigationRail)).selectedIndex,
      1,
    );
    expect(router.routeInformationProvider.value.uri.path, '/settings');
  });

  testWidgets('follows system language and falls back to English', (
    tester,
  ) async {
    final dispatcher = tester.binding.platformDispatcher;
    addTearDown(dispatcher.clearLocalesTestValue);
    dispatcher.localesTestValue = [const Locale('ja', 'JP')];
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();
    expect(find.text('アカウントはありません'), findsOneWidget);
    expect(find.text('設定'), findsOneWidget);
    expect(
      MaterialLocalizations.of(tester.element(find.byType(Scaffold)))
          .backButtonTooltip,
      '戻る',
    );

    dispatcher.localesTestValue = [const Locale('en', 'US')];
    await tester.pumpAndSettle();
    expect(find.text('No accounts'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    dispatcher.localesTestValue = [const Locale('fr', 'FR')];
    await tester.pumpAndSettle();
    expect(find.text('No accounts'), findsOneWidget);
    expect(
      Localizations.localeOf(tester.element(find.byType(Scaffold)))
          .languageCode,
      'en',
    );
  });
}
