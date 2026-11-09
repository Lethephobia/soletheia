# Imports, nullability, strings and collections

Use these examples when writing or reviewing imports, nullability, strings and collections. Adapted from [Effective Dart: Usage](https://dart.dev/effective-dart/usage). Examples are excerpts.

## Libraries

### DO use strings in `part of` directives

A file URI identifies the owner of a part even when the library has no explicit name.

**Good**

```dart
part of '../../my_library.dart';
```

**Bad**

```dart
part of my_library;
```

### DON'T import libraries that are inside the `src` directory of another package

Consumers should depend on another package's public exports so internal layout can change.

**Bad**

```dart
import 'package:wallet/src/account.dart';
```

**Good**

```dart
import 'package:wallet/wallet.dart';
```

### DON'T allow an import path to reach into or out of `lib`

Use a package URI when accessing lib from tests or another package. Paths that cross lib can give one source multiple identities.

**Bad**

```dart
import 'package:my_package/api.dart';
import '../lib/api.dart';
```

**Good**

```dart
import 'package:my_package/api.dart';
```

### PREFER relative import paths

Prefer relative imports between files within the same lib tree; crossing into lib from outside requires a package URI.

**Good**

```dart
import 'account.dart'; // From the same lib directory.
```

**Bad**

```dart
import 'package:wallet/account.dart'; // From the same lib directory.
```

## Null

### DON'T explicitly initialize variables to `null`

An uninitialized nullable variable already has the value null.

**Bad**

```dart
Item? bestDeal(List<Item> cart) {
  Item? bestItem[! = null!];

  for (final item in cart) {
    if (bestItem == null || item.price < bestItem.price) {
      bestItem = item;
    }
  }

  return bestItem;
}
```

**Good**

```dart
Item? bestDeal(List<Item> cart) {
  Item? bestItem;

  for (final item in cart) {
    if (bestItem == null || item.price < bestItem.price) {
      bestItem = item;
    }
  }

  return bestItem;
}
```

### DON'T use an explicit default value of `null`

An optional nullable parameter already defaults to null.

**Bad**

```dart
void error([String? message = null]) {
  stderr.write(message ?? '\n');
}
```

**Good**

```dart
void error([String? message]) {
  stderr.write(message ?? '\n');
}
```

### DON'T use `true` or `false` in equality operations

Test a non-nullable predicate directly. If a nullable flag needs a policy for null, express that policy explicitly.

**Bad**

```dart
if (nonNullableBool == true) {
   ...
}

if (nonNullableBool == false) {
   ...
}
```

**Good**

```dart
if (nonNullableBool) {
   ...
}

if (!nonNullableBool) {
   ...
}
```

### AVOID `late` variables if you need to check whether they are initialized

If code needs to inspect whether a value exists, represent that state with a nullable value.

**Bad**

```dart
late Account current;
bool currentInitialized = false;
```

**Good**

```dart
Account? current;
if (current != null) show(current);
```

### CONSIDER type promotion or null-check patterns for using nullable types

Use flow analysis or a null-check pattern to bind the non-null value once.

**Good**

```dart
class UploadException {
  final Response? response;

  UploadException([this.response]);

  @override
  String toString() {
    if (this.response case var response?) {
      return 'Could not complete upload to ${response.url} '
          '(error code ${response.errorCode}): ${response.reason}.';
    }
    return 'Could not upload (no response).';
  }
}
```

**Bad**

```dart
class UploadException {
  final Response? response;

  UploadException([this.response]);

  @override
  String toString() {
    if (response != null) {
      return 'Could not complete upload to ${response[!!!].url} '
          '(error code ${response[!!!].errorCode}): ${response[!!!].reason}.';
    }

    return 'Could not upload (no response).';
  }
}
```

## Strings

### DO use adjacent strings to concatenate string literals

Adjacent string literals join at compile time and can wrap naturally.

**Good**

```dart
raiseAlarm(
  'ERROR: Parts of the spaceship are on fire. Other '
  'parts are overrun by martians. Unclear which are which.',
);
```

**Bad**

```dart
raiseAlarm(
  'ERROR: Parts of the spaceship are on fire. Other ' +
      'parts are overrun by martians. Unclear which are which.',
);
```

### PREFER using interpolation to compose strings and values

Use interpolation to place a value inside text without manual conversions.

**Good**

```dart
'Hello, $name! You are ${year - birth} years old.';
```

**Bad**

```dart
'Hello, ' + name + '! You are ' + (year - birth).toString() + ' y...';
```

### AVOID using curly braces in interpolation when not needed

A simple identifier needs no braces unless adjoining text would change the parsed name.

**Bad**

```dart
var greeting = 'Hi, ${name}! I love your ${decade}s costume.';
```

**Good**

```dart
var greeting = 'Hi, $name! I love your ${decade}s costume.';
```

## Collections

### DO use collection literals when possible

Literals express collection contents and allow type inference.

**Good**

```dart
var points = <Point>[];
var addresses = <String, Address>{};
var counts = <int>{};
```

**Bad**

```dart
var addresses = Map<String, Address>();
var counts = Set<int>();
```

### DON'T use `.length` to see if a collection is empty

Use isEmpty or isNotEmpty to express intent and avoid traversing lazy iterables just to count them.

**Bad**

```dart
if (lunchBox.length == 0) return 'so hungry...';
if (!words.isEmpty) return words.join(' ');
```

**Good**

```dart
if (lunchBox.isEmpty) return 'so hungry...';
if (words.isNotEmpty) return words.join(' ');
```

### AVOID using `Iterable.forEach()` with a function literal

Prefer a for loop for a callback body so return, break and continue follow familiar control flow.

**Bad**

```dart
people.forEach((person) {
  ...
});
```

**Good**

```dart
for (final person in people) {
  ...
}
```

### DON'T use `List.from()` unless you intend to change the type of the result

Use toList when copying without changing element type; a List.from conversion can defer type failures.

**Bad**

```dart
// Creates a List<int>:
var iterable = [1, 2, 3];

// Prints "List<dynamic>":
print(List.from(iterable).runtimeType);
```

**Good**

```dart
// Creates a List<int>:
var iterable = [1, 2, 3];

// Prints "List<int>":
print(iterable.toList().runtimeType);
```

### DO use `whereType()` to filter a collection by type

Use whereType<T>() when the operation is meant to keep elements of a particular type.

**Good**

```dart
var objects = [1, 'a', 2, 'b', 3];
var ints = objects.whereType<int>();
```

**Bad**

```dart
var objects = [1, 'a', 2, 'b', 3];
var ints = objects.where((e) => e is int);
```

### DON'T use `cast()` when a nearby operation will do

Supply a type argument to the operation that creates the collection when possible.

**Bad**

```dart
var stuff = <dynamic>[1, 2];
var ints = stuff.toList().cast<int>();
```

**Good**

```dart
var stuff = <dynamic>[1, 2];
var ints = List<int>.from(stuff);
```

### AVOID using `cast()`

Prefer typed construction, validation or filtering when a cast would defer surprises until iteration.

**Bad**

```dart
List<int> singletonList(int value) {
  var list = []; // List<dynamic>.
  list.add(value);
  return list.cast<int>();
}
```

**Good**

```dart
List<int> singletonList(int value) {
  var list = <int>[];
  list.add(value);
  return list;
}
```
