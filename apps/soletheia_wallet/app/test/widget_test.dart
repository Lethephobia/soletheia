import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:soletheia/app.dart';
import 'package:soletheia/routing.dart';
import 'package:soletheia/shell.dart';
import 'package:soletheia/view.dart';

void main() {
  testWidgets('starts in onboarding without account navigation', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingShell), findsOneWidget);
    expect(find.byType(AccountSetupView), findsOneWidget);
    expect(find.byType(AccountShell), findsNothing);
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.text('Generate seed phrase'), findsOneWidget);
    expect(find.text('Import seed phrase'), findsOneWidget);
    expect(find.text('Import private key'), findsOneWidget);
    expect(find.text('BIP-39 mnemonic'), findsNWidgets(2));
    expect(find.text('Ed25519 private key'), findsOneWidget);
    expect(
      tester
          .widgetList<ListTile>(find.byType(ListTile))
          .every((tile) => !tile.enabled && tile.onTap == null),
      isTrue,
    );
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 240);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Import private key'));
    expect(tester.takeException(), isNull);
  });

  testWidgets('account shell preserves branches and toggles the rail', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(routerProvider).go(const AccountListRoute().location);
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AccountShell), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    final account = tester.element(find.byType(AccountListView));
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    final settings = tester.element(find.byType(SettingsView));
    tester.view.physicalSize = const Size(1024, 768);
    await tester.pumpAndSettle();
    expect(tester.element(find.byType(SettingsView)), same(settings));
    expect(find.byType(NavigationRail), findsOneWidget);
    await tester.tap(find.byTooltip('Expand navigation'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<NavigationRail>(find.byType(NavigationRail)).extended,
      isTrue,
    );
    await tester.tap(find.byTooltip('Collapse navigation'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<NavigationRail>(find.byType(NavigationRail)).extended,
      isFalse,
    );
    await tester.tap(find.byIcon(Icons.account_circle_outlined));
    await tester.pumpAndSettle();
    expect(tester.element(find.byType(AccountListView)), same(account));
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses English for all system languages', (tester) async {
    final dispatcher = tester.binding.platformDispatcher;
    addTearDown(dispatcher.clearLocalesTestValue);
    dispatcher.localesTestValue = [const Locale('ja', 'JP')];
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();
    expect(find.text('Generate seed phrase'), findsOneWidget);
    expect(
      Localizations.localeOf(tester.element(find.byType(AccountSetupView))),
      const Locale('en'),
    );
    expect(
      MaterialLocalizations.of(tester.element(find.byType(AccountSetupView)))
          .backButtonTooltip,
      'Back',
    );
    for (final locale in [const Locale('en', 'US'), const Locale('fr', 'FR')]) {
      dispatcher.localesTestValue = [locale];
      await tester.pumpAndSettle();
      expect(find.text('Generate seed phrase'), findsOneWidget);
    }
  });
}
