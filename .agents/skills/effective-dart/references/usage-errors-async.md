# Errors, futures and streams

Use these examples when writing or reviewing errors, futures and streams. Adapted from [Effective Dart: Usage](https://dart.dev/effective-dart/usage). Examples are excerpts.

## Error handling

### AVOID catches without `on` clauses

Catch a type that the operation can handle. A broad catch is useful at a deliberate reporting or propagation boundary.

**Bad**

```dart
try { await read(); } catch (_) { recover(); }
```

**Good**

```dart
try { await read(); } on FormatException { recover(); }
```

### DON'T discard errors from catches without `on` clauses

If a broad catch must run cleanup or diagnostics, propagate the failure or handle it deliberately.

**Bad**

```dart
try { await save(); } catch (_) {}
```

**Good**

```dart
try { await save(); } catch (e) { logFailure(e); rethrow; }
```

### DO throw objects that implement `Error` only for programmatic errors

Use Error for a caller or implementation contract violation. Represent an expected operational failure with an exception.

**Good**

```dart
throw FormatException('Invalid encoded input');
```

**Bad**

```dart
throw StateError('Invalid encoded input'); // Recoverable input error.
```

### DON'T explicitly catch `Error` or types that implement it

Catching Error can hide a programming defect. Recover from the specific exceptions the operation expects.

**Bad**

```dart
try { parse(text); } on Error { showInvalidInput(); }
```

**Good**

```dart
try { parse(text); } on FormatException { showInvalidInput(); }
```

### DO use `rethrow` to rethrow a caught exception

Use rethrow within the catch clause to retain the original stack trace.

**Good**

```dart
try {
  somethingRisky();
} catch (e) {
  if (!canHandle(e)) [!rethrow!];
  handle(e);
}
```

**Bad**

```dart
try {
  somethingRisky();
} catch (e) {
  if (!canHandle(e)) throw e;
  handle(e);
}
```

## Asynchrony

### PREFER async/await over using raw futures

Use await to express sequencing and exception handling in ordinary control flow.

**Good**

```dart
Future<int> countActivePlayers(String teamName) [!async!] {
  try {
    var team = [!await!] downloadTeam(teamName);
    if (team == null) return 0;

    var players = [!await!] team.roster;
    return players.where((player) => player.isActive).length;
  } on DownloadException catch (e) {
    log.error(e);
    return 0;
  }
}
```

**Bad**

```dart
Future<int> countActivePlayers(String teamName) {
  return downloadTeam(teamName)
      .then((team) {
        if (team == null) return Future.value(0);

        return team.roster.then((players) {
          return players.where((player) => player.isActive).length;
        });
      })
      .onError<DownloadException>((e, _) {
        log.error(e);
        return 0;
      });
}
```

### DON'T use `async` when it has no useful effect

A direct return often suffices when forwarding a future. Keep await where a local try/catch or finally must observe completion.

**Bad**

```dart
Future<int> fastestBranch(Future<int> left, Future<int> right) async {
  return Future.any([left, right]);
}
```

**Good**

```dart
Future<int> fastestBranch(Future<int> left, Future<int> right) {
  return Future.any([left, right]);
}
```

### CONSIDER using higher-order methods to transform a stream

Use a stream transformation when the output is a straightforward mapping or filtering of events.

**Good**

```dart
Stream<int> counts(Stream<List<int>> rows) => rows.map((row) => row.length);
```

**Bad**

```dart
Stream<int> counts(Stream<List<int>> rows) async* {
  await for (final row in rows) { yield row.length; }
}
```

### AVOID using Completer directly

Use the existing future or an async function when possible. A Completer is useful for bridging some callback APIs.

**Bad**

```dart
Future<bool> fileContainsBear(String path) {
  var completer = Completer<bool>();

  File(path).readAsString().then((contents) {
    completer.complete(contents.contains('bear'));
  });

  return completer.future;
}
```

**Good**

```dart
Future<bool> fileContainsBear(String path) {
  return File(path).readAsString().then((contents) {
    return contents.contains('bear');
  });
}
```

### DO test for `Future<T>` when disambiguating a `FutureOr<T>` whose type argument could be `Object`

Check for Future<T> first when T may accept Object, since a future may also pass the test for T.

**Good**

```dart
Future<T> logValue<T>(FutureOr<T> value) async {
  if (value is Future<T>) {
    var result = await value;
    print(result);
    return result;
  } else {
    print(value);
    return value;
  }
}
```

**Bad**

```dart
Future<T> logValue<T>(FutureOr<T> value) async {
  if (value is T) {
    print(value);
    return value;
  } else {
    var result = await value;
    print(result);
    return result;
  }
}
```
