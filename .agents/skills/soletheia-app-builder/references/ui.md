# UI

Use for developer-wallet screen design, layout ownership, themes, and responsive behavior.

### DO let each View own its AppBar and page scaffold

MainLayout owns shared navigation and the content region. Views own page titles, actions, body,
and any page-specific FAB or scrolling app bar. An outer navigation Scaffold can remain; account
for SafeArea and inset ownership instead of padding the same region twice.

**Good**

```text
MainLayout: NavigationRail / NavigationBar + child
AccountListView: Scaffold(appBar: account list title, body: account list)
SettingsView: Scaffold(appBar: settings title, body: settings)
```

**Bad**

```text
MainLayout chooses every page's title/actions from selectedIndex.
Each View also adds a second AppBar below it.
```

### PREFER official Material components for developer workflows

Use the official `material_ui` package already adopted by the app. Design with Material 3 and
Expressive in mind, using hierarchy, spacing, color, and supported component options. Verify the
installed API and current official support before relying on Expressive features. Use custom
widgets when they have a concrete purpose, not to recreate standard controls.

An empty account list is still the account list screen. Do not replace it with mandatory onboarding
or invent portfolio balances and charts merely because this is a wallet.

**Good**

```text
Account list: normal navigation, page title, localized empty-state message.
Add an account action when that workflow is requested, using a Material control.
```

**Bad**

```text
No accounts -> hide navigation behind mandatory creation.
Build bespoke animated buttons solely to imitate an unsupported Expressive demo.
```

### DO centralize theme and breakpoint decisions

The current product is dark-only. Keep Google Fonts configuration and license registration in
the theme module, use bundled Noto Sans JP assets with runtime fetching disabled, and retain OFL.
Use the Bp enum for compact/medium/expanded/large/extraLarge classification. Use available layout
constraints when sizing a bounded region, and MediaQuery for viewport-level navigation decisions.

**Good**

```dart
// Viewport-level navigation choice.
final useRail = Bp.of(context).isAtLeast(Bp.medium);
// Text styling comes from the theme.
final textStyle = Theme.of(context).textTheme.bodyMedium;
```

**Bad**

```text
Each View invents different width thresholds and font-loading configuration.
A new screen silently introduces a light theme despite the dark-only direction.
```
