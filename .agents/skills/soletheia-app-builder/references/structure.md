# Structure

Use for Flutter module boundaries, public exports, file naming, and provider definitions.

### DO use adjacent, same-name barrel files

Keep `routing`, `theme`, `view`, `shell`, and `responsive` focused on their existing roles.
Expose a module through its adjacent barrel, including feature submodules. Use singular feature
names such as `account`; preserve naturally plural names such as `settings`. Distinguish list and
detail screens by role rather than naming both AccountView.

**Good**

```text
view.dart -> view/account.dart
view/account.dart -> account/account_list_view.dart
view/account/account_list_view.dart -> AccountListView
```

**Bad**

```text
view/accounts/index.dart
view/accounts/account_view.dart -> ambiguous list/detail responsibility
```

### DO define Riverpod providers with code generation

Name the source file and annotated function for the concept. The generator supplies the Provider
suffix. Keep lifecycle ownership explicit when a provider creates a disposable object.

**Good**

```dart
// routing/router.dart (excerpt)
part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final router = GoRouter(routes: $appRoutes);
  ref.onDispose(router.dispose);
  return router;
}
// Consumer: ref.watch(routerProvider)
```

**Bad**

```dart
// A second, manually maintained provider for the same generated router.
final routerProvider = Provider((ref) => GoRouter(routes: $appRoutes));
```
