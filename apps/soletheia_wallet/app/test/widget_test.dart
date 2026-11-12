import 'dart:typed_data';

import 'package:application/application.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:soletheia/app.dart';
import 'package:soletheia/routing.dart';
import 'package:soletheia/shell.dart';
import 'package:soletheia/view.dart';

import 'support/account_test_container.dart';
import 'support/pump_wallet_widget.dart';

void main() {
  testWidgets('starts in onboarding without account navigation', (
    tester,
  ) async {
    await tester.pumpWalletWidget(
      UncontrolledProviderScope(
        container: await accountTestContainer(),
        child: const App(),
      ),
    );
    expect(find.byType(OnboardingView), findsOneWidget);
    expect(find.byType(AccountShell), findsNothing);
    expect(find.byType(AppBar), findsNothing);
    expect(find.byTooltip('Back'), findsNothing);
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.text('Create account'), findsOneWidget);
    expect(find.text('Import mnemonic'), findsOneWidget);
    expect(find.text('Import private key'), findsOneWidget);
    expect(find.text('BIP-39 mnemonic'), findsNWidgets(2));
    expect(find.text('Ed25519 private key'), findsOneWidget);
    final tiles = tester.widgetList<ListTile>(find.byType(ListTile)).toList();
    expect(tiles.first.enabled, isTrue);
    expect(tiles.skip(1).every((tile) => !tile.enabled), isTrue);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 240);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Import private key'));
    await tester.ensureVisible(find.text('Licenses'));
    await tester.pumpAndSettle();
    final router = ProviderScope.containerOf(
      tester.element(find.byType(OnboardingView)),
    ).read(routerProvider);
    await tester.tap(find.text('Licenses'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(LicensePage), findsOneWidget);
    expect(router.state.uri.path, '/onboarding/licenses');
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingView), findsOneWidget);
    expect(router.state.uri.path, '/onboarding');
    expect(tester.takeException(), isNull);
  });

  testWidgets('seed form adapts, retains inputs and returns to setup', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWalletWidget(
      UncontrolledProviderScope(
        container: await accountTestContainer(),
        child: const App(),
      ),
    );
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();
    expect(find.byType(AccountCreationView), findsOneWidget);
    expect(tester.getSize(find.byType(AppBar)).width, 390);
    final wordlist = find.byType(DropdownMenuFormField<MnemonicWordlist>);
    final count = find.byType(DropdownMenuFormField<MnemonicWordCount>);
    expect(tester.getTopLeft(wordlist).dy, tester.getTopLeft(count).dy);
    final label = tester.renderObject<RenderParagraph>(find.text('Word count'));
    final boxes = label.getBoxesForSelection(
      const TextSelection(baseOffset: 0, extentOffset: 10),
    );
    expect(boxes.map((box) => box.top).toSet(), hasLength(1));
    expect(
      find.text('Leave blank for random entropy, or enter 32 hex digits.'),
      findsOneWidget,
    );
    expect(find.text('0/32'), findsOneWidget);
    final entropy = 'a' * 33;
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Custom entropy (optional)'),
      entropy,
    );
    await tester.pumpAndSettle();
    expect(find.text('33/32'), findsOneWidget);
    expect(find.text('Enter exactly 32 hexadecimal characters.'), findsNothing);
    await tester.tap(
      find.descendant(of: count, matching: find.byType(TextField)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('24').last);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextField>(
            find.widgetWithText(TextField, 'Custom entropy (optional)'),
          )
          .decoration
          ?.helperText,
      'Leave blank for random entropy, or enter 64 hex digits.',
    );
    expect(find.text('Enter exactly 64 hexadecimal characters.'), findsNothing);
    tester.view.physicalSize = const Size(1280, 800);
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(AppBar)).width, 1280);
    expect(tester.getTopLeft(wordlist).dx, greaterThan(300));
    expect(
      tester
          .widget<TextField>(
            find.widgetWithText(TextField, 'Custom entropy (optional)'),
          )
          .decoration
          ?.helperText,
      'Leave blank for random entropy, or enter 64 hex digits.',
    );
    expect(find.text(entropy), findsOneWidget);
    expect(find.text('33/64'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNotNull,
    );
    tester.view.physicalSize = const Size(320, 568);
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(wordlist).dy, tester.getTopLeft(count).dy);
    expect(tester.takeException(), isNull);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingView), findsOneWidget);
  });

  testWidgets(
    'avatar menu opens settings and account switch above the token screen',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(390, 844);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      final repository = TestAccountRepository();
      await repository.save(Account(address: AccountAddress(Uint8List(32))));
      final second = Account(address: AccountAddress(Uint8List(32)..[31] = 1));
      await repository.save(second);
      final container = await accountTestContainer(repository: repository);
      await tester.pumpWalletWidget(
        UncontrolledProviderScope(container: container, child: const App()),
      );
      expect(find.byType(AccountShell), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
      await tester.tap(find.text('Scan'));
      await tester.pumpAndSettle();
      expect(container.read(routerProvider).state.uri.path, '/scan');
      await tester.tap(find.text('Trade'));
      await tester.pumpAndSettle();
      expect(container.read(routerProvider).state.uri.path, '/trade');
      expect(find.text('Swap'), findsOneWidget);
      await tester.tap(find.text('Token'));
      await tester.pumpAndSettle();
      expect(find.text('Accounts'), findsNothing);
      final token = tester.element(find.byType(TokenView));
      expect(find.text('Settings'), findsNothing);
      await tester.tap(find.byTooltip('Account menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      final settings = tester.element(find.byType(SettingsView));
      await tester.tap(find.text('Accounts'));
      await tester.pumpAndSettle();
      expect(
        container.read(routerProvider).state.uri.path,
        '/tokens/settings/accounts',
      );
      expect(find.byType(ListTile), findsNWidgets(2));
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(tester.element(find.byType(SettingsView)), same(settings));
      final router = container.read(routerProvider);
      await tester.tap(find.text('Licenses'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(router.state.uri.path, '/tokens/settings/licenses');
      expect(find.byType(LicensePage), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(router.state.uri.path, '/tokens/settings');
      expect(tester.element(find.byType(SettingsView)), same(settings));
      tester.view.physicalSize = const Size(1024, 768);
      await tester.pumpAndSettle();
      expect(tester.element(find.byType(SettingsView)), same(settings));
      expect(find.byType(NavigationRail), findsNothing);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(tester.element(find.byType(TokenView)), same(token));
      expect(find.byType(NavigationRail), findsOneWidget);
      await tester.tap(find.text('Trade'));
      await tester.pumpAndSettle();
      expect(router.state.uri.path, '/trade');
      expect(find.text('Swap'), findsOneWidget);
      await tester.tap(find.text('Token'));
      await tester.pumpAndSettle();
      final menuCenter = tester.getCenter(find.byTooltip('Expand navigation'));
      await tester.tap(find.byTooltip('Expand navigation'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));
      expect(
        tester.getCenter(find.byTooltip('Collapse navigation')),
        menuCenter,
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget<NavigationRail>(find.byType(NavigationRail)).extended,
        isTrue,
      );
      expect(
        tester.getCenter(find.byTooltip('Collapse navigation')),
        menuCenter,
      );
      await tester.tap(find.byTooltip('Collapse navigation'));
      await tester.pumpAndSettle();
      expect(
        find
            .descendant(
              of: find.byType(NavigationRail),
              matching: find.text('Token'),
            )
            .hitTestable(),
        findsOneWidget,
      );
      await tester.tap(find.byTooltip('Account menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Switch account'));
      await tester.pumpAndSettle();
      expect(find.byType(NavigationRail), findsNothing);
      expect(
        tester.widget<ListTile>(find.byType(ListTile).first).selected,
        isTrue,
      );
      await tester.tap(find.byType(ListTile).last);
      await tester.pumpAndSettle();
      expect(tester.element(find.byType(TokenView)), same(token));
      expect(await repository.watchCurrentAddress().first, second.address);
      await tester.tap(find.byTooltip('Account menu'));
      await tester.pumpAndSettle();
      expect(find.text('Add account'), findsNothing);
      await tester.tap(find.text('Switch account'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<ListTile>(find.byType(ListTile).last).selected,
        isTrue,
      );
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(tester.element(find.byType(TokenView)), same(token));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('uses English for all system languages', (tester) async {
    final dispatcher = tester.binding.platformDispatcher;
    addTearDown(dispatcher.clearLocalesTestValue);
    dispatcher.localesTestValue = [const Locale('ja', 'JP')];
    await tester.pumpWalletWidget(
      UncontrolledProviderScope(
        container: await accountTestContainer(),
        child: const App(),
      ),
    );
    expect(find.text('Create account'), findsOneWidget);
    expect(
      Localizations.localeOf(tester.element(find.byType(OnboardingView))),
      const Locale('en'),
    );
    expect(
      MaterialLocalizations.of(tester.element(find.byType(OnboardingView)))
          .backButtonTooltip,
      'Back',
    );
    for (final locale in [const Locale('en', 'US'), const Locale('fr', 'FR')]) {
      dispatcher.localesTestValue = [locale];
      await tester.pumpAndSettle();
      expect(find.text('Create account'), findsOneWidget);
    }
  });
}
