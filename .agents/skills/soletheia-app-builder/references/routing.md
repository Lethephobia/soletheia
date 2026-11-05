# Routing

Use for typed navigation, branch placement, and shell integration.

### DO keep feature routes and branches in their feature module

Use go_router_builder typed routes and StatefulShellRoute for the existing account/settings
navigation. The app route composes branches; each feature owns its branch and routes. URL paths
may be plural even when the module is singular.

**Good**

```text
routing/account/account_branch.dart -> AccountBranch
routing/account/account_list_route.dart -> AccountListRoute, /accounts
routing/settings/settings_branch.dart -> SettingsBranch
routing/app/app_shell_route.dart -> composes the branches
Navigation to settings: const SettingsRoute().go(context)
```

**Bad**

```text
routing/app/account_branch.dart -> account-specific definition owned by app
Account view: context.go('/settings') -> duplicates a typed route's path
```

### DO keep router mechanics in the shell and presentation in the layout

AppShell adapts StatefulNavigationShell to AppLayout's selected index, selection callback,
and content. Switch branches with goBranch and preserve their state when the responsive navigation
changes. Keep the content's parent structure stable across breakpoints.

**Good**

```text
AppShell: navigationShell.goBranch(index)
AppLayout: selectedIndex + onDestinationSelected + child
Resize: same content subtree, NavigationBar switches to NavigationRail
```

**Bad**

```text
AppLayout directly constructs GoRouter and pushes a new route for each tab click.
Resize replaces the entire branch subtree with a new navigation stack.
```
