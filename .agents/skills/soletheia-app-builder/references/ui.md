# UI

Use for developer-wallet screen design, layout ownership, themes, and responsive behavior.

### DO let each View own its AppBar and page scaffold

OnboardingShell/OnboardingLayout host the first-account creation flow without branch navigation.
AccountShell/AccountLayout host normal account functionality with responsive NavigationBar/Rail
and a menu button to expand the rail. Page-specific AppBars remain in Views inside that shell.
Nested Scaffolds are allowed for this separation; verify insets and overlay ownership.
The shell supplies the current branch's primaryAction; the layout places it as a floating action
on compact screens or in the rail on wider screens. A branch without an implemented action has
no FAB. Do not make the layout inspect concrete View types or local View state.

**Good**

```text
OnboardingLayout: safe, constrained content region for setup steps
AccountShell: branch selection and branch-specific action
AccountLayout: navigation, rail expansion, placement of the supplied action
AccountListView: page AppBar and body
```

**Bad**

```text
AccountLayout checks child is AccountListView to invent an action.
A disabled or no-op FAB pretends an unimplemented workflow exists.
```

### PREFER official Material components for developer workflows

Use the official `material_ui` package already adopted by the app. Design with Material 3 and
Expressive in mind, using hierarchy, spacing, color, and supported component options. Verify the
installed API and current official support before relying on Expressive features. Use custom
widgets when they have a concrete purpose, not to recreate standard controls.

The agreed product flow sends users with zero accounts through creation of their first account.
Existing accounts lead to AccountShell. Keep loading distinct from an empty result. The current
skeleton starts at onboarding; persistence and automatic redirects are not implemented yet.

**Good**

```text
Onboarding: localized first-account setup content; normal shell after creation.
Add an account action when that workflow is requested, using a Material control.
```

**Bad**

```text
Treat loading as zero accounts and briefly show onboarding to an existing user.
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
