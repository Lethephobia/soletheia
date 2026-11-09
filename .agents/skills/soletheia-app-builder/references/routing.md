# Routing

Use for the onboarding flow and normal account navigation.

### DO separate onboarding from the normal account shell

`OnboardingRoute` is a standalone root route at `/onboarding`. `AccountShellRoute`
hosts the account list and settings branches. Parent route annotations define the paths.
Share the relative account creation route between onboarding and accounts, and the
relative licenses route between onboarding and settings. Both use the root navigator.

Startup awaits the first list from `AccountRepository.watchAll()` before creating
the router. The router uses that list to choose its initial location. Direct navigation has no
account-count redirect. After account creation and metadata persistence succeed,
navigate to the account list with `go`.

**Good**

```text
Startup with an empty account list -> /onboarding
Startup with stored accounts -> /accounts
/onboarding/create-account or /accounts/create-account -> save -> /accounts
```

**Bad**

```text
Hard-code zero accounts in a fake repository and claim automatic gating works.
A setup completion button navigates without creating or persisting an account.
```

### DO keep router mechanics in Shell and presentation in Layout

Use goBranch to preserve branch locations. Keep content mounted across responsive changes.
Shell can supply a branch-specific action to Layout; Layout must not inspect child View types.
Keep route declarations under routing/root or routing/account as parts of router.dart.
Use the single generated $appRoutes list and regenerate bindings after route changes.

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
