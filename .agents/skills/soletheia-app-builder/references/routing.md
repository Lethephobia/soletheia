# Routing

Use for the onboarding flow and normal account navigation.

### DO separate onboarding from the normal account shell

OnboardingShellRoute is a typed ShellRoute with AccountSetupRoute at /onboarding.
AccountShellRoute is a typed StatefulShellRoute; current scaffold branches are the existing
account list (/accounts) and settings (/settings). Each feature owns its branch and page routes.
Each shell route owns its generated route list; router.dart composes the lists with import prefixes.

The skeleton starts at /onboarding. Account persistence, creation, loading, and route guards are
not implemented. When connecting them, distinguish loading from zero accounts; redirect zero
accounts to onboarding and existing accounts to the normal shell. Completing setup must replace
onboarding rather than leave it in the back stack. Do not treat the initial route as an account guard.

**Good**

```text
OnboardingShellRoute -> AccountSetupRoute
AccountShellRoute -> AccountBranch / SettingsBranch
Future: resolved account state -> redirect; setup completion -> normal shell
```

**Bad**

```text
Hard-code zero accounts in a fake repository and claim automatic gating works.
A setup completion button navigates without creating or persisting an account.
```

### DO keep router mechanics in Shell and presentation in Layout

Use goBranch to preserve branch locations. Keep content mounted across responsive changes.
Shell can supply a branch-specific action to Layout; Layout must not inspect child View types.
Keep generated route parts with their shell definition and import the generated mixins in page
routes. Regenerate bindings rather than editing generated files.

**Good**

```text
AccountShell: currentIndex, goBranch, current branch action
AccountLayout: navigation presentation, rail expansion, responsive action placement
```

**Bad**

```text
AccountLayout reads a child's runtimeType to choose a route or callback.
Resizing reconstructs a new navigation stack and loses the selected branch state.
```
