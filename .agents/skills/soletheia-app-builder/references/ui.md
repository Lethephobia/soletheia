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

### DO verify designs against current official Material 3 guidance

For both mockups and implementation, read the relevant component's current guidelines, specs,
and accessibility guidance on [Material Design 3](https://m3.material.io/). Check applicable
Expressive updates before choosing a component or pattern. Do not base new designs on archived
Material 2 examples or use patterns the current official guidance deprecates or advises against.
Verify usage, anatomy, interaction states, color, typography, shape, spacing, and adaptive behavior;
rounded corners alone do not establish Material 3 conformity.

Use the [cards guidelines](https://m3.material.io/components/cards/guidelines) when designing cards.
Keep each card focused on one subject and its related actions. Do not force content into cards when
spacing or another simpler hierarchy is sufficient. Choose elevated, filled, or outlined cards
deliberately; all three remain documented variants. Only the container is required, so do not add
images or supporting copy merely to imitate a sample. On compact screens, cards may become lists
while preserving their actions; on wide screens, use suitable columns rather than stretching them.
Consult the corresponding component guidance for lists rather than assuming card rules apply.

Distinguish an official deprecation from a design preference or an implementation limitation.
Do not declare an existing M3 component deprecated merely because it has no Expressive-specific
replacement. Check the installed Flutter package separately: API availability does not prove design
conformity. If official guidance cannot be read or a required feature is unavailable, state the gap
and use a verified supported M3 option instead of silently falling back to M2 or inventing an
Expressive substitute.

**Good**

```text
Check Cards guidelines, Specs, and Accessibility before proposing a card layout.
Preserve the same actions when wide-screen cards become compact-screen list rows.
Identify the official replacement when avoiding a deprecated component.
```

**Bad**

```text
Copy an M2 example and label it Expressive after increasing its corner radius.
Treat every M3 component without an Expressive update as deprecated.
Add explanatory copy solely because a sample card includes supporting text.
```

### DO keep onboarding choices concise and responsive

The selected onboarding design offers three actions: generate a mnemonic, import a mnemonic,
or import a private key. Present these as one grouped vertical list on both mobile and desktop,
with a constrained, centered width on desktop. Preserve their order and meaning across layouts. Do not
ask for an account name in this initial choice screen or add a logo, setup caption, progress caption,
or decorative explanatory copy. Keep accessible labels even when visual text is minimal.
Use [domain terminology](localization.md) for action labels and concise technical supporting text:
BIP-39 mnemonic for the phrase flows and Ed25519 private key for key import. Keypair JSON loading
belongs inside private-key import, not a fourth entry. The entry screen is implemented; its three
callbacks remain disconnected and disabled until the corresponding flows are implemented.

**Good**

```text
Compact: three grouped rows with operation labels and technical supporting text
Wide: the same list, centered with a constrained width
```

**Bad**

```text
Ask for an account name before letting the user choose key material.
Add "Setup", "Preview", and "Get started" captions around the choice controls.
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
