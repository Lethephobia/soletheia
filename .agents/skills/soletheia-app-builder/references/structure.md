# Structure

Use for Flutter module boundaries, public exports, file naming, Dart and Rust method names, provider definitions, and Dart application exceptions.

### PREFER short verbs when the receiver identifies the object

For Dart and Rust services, stores, and repositories, read the method name with its
receiver. Use verbs such as `generate`, `parse`, `derive`, `create`, `save`, `select`,
and `delete` when the type already identifies the object. Keep qualifiers that
distinguish operations or results, such as `watchAll` and `watchCurrentAddress`.
For standalone Rust bridge functions, include the object so the name also reads
clearly when imported directly.

**Good**

```rust
mnemonic_parser.parse(phrase)
mnemonic_store.save(&mnemonic)
create_account(wordlist, source, passphrase, derivation_path)
```

```dart
await accountRepository.select(address);
final addresses = accountRepository.watchCurrentAddress();
```

**Bad**

```rust
mnemonic_parser.parse_mnemonic(phrase)
mnemonic_store.save_mnemonic(&mnemonic)
create(wordlist, source, passphrase, derivation_path)
```

```dart
await accountRepository.selectAccount(address);
final addresses = accountRepository.watch();
```

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

### DO use block bodies for multiline Dart functions

In hand-written Dart, reserve `=>` for functions that fit on one line after formatting.
Use a block for multiline methods, factories, getters, and callbacks. Return the value
explicitly when the function produces one.

**Good**

```dart
bool isAtLeast(Bp other) => minWidth >= other.minWidth;

Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text(title)),
    body: content,
  );
}
```

**Bad**

```dart
Widget build(BuildContext context) => Scaffold(
  appBar: AppBar(title: Text(title)),
  body: content,
);
```

### DO model expected application failures as sealed exception families

Group related failures under a feature-specific sealed class that implements `Exception`.
Define each failure as a final subclass and keep the family together in the same
`*_exception.dart` file. Callers can catch the base type and use an exhaustive switch
when each variant needs different handling. Give variants only the data needed for
recovery or display, such as a byte count. Keep entropy, seed words, and private keys
out of exception fields and messages.

**Good**

```dart
// mnemonic_entropy_exception.dart
sealed class MnemonicEntropyException implements Exception {
  const MnemonicEntropyException();
}

final class InvalidEntropyLengthException extends MnemonicEntropyException {
  const InvalidEntropyLengthException(this.actualBytes);

  final int actualBytes;
}

// At the validation site: throw InvalidEntropyLengthException(bytes.length);
```

**Bad**

```dart
// Callers must interpret the message to identify this input failure.
throw ArgumentError('Invalid entropy length.');
```

### DO name the exception type when handling failures

Use an `on` clause in hand-written Dart. Catch the specific recoverable exception when the
interface exposes one. At a UI operation boundary that offers the same recovery for all
operational exceptions, use `on Exception` so programming errors still surface.

**Good**

```dart
try {
  await save();
} on Exception {
  showSaveFailure();
}
```

**Bad**

```dart
try {
  await save();
} catch (_) {
  showSaveFailure();
}
```
