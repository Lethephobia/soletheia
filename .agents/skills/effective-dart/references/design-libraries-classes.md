# Library visibility, classes, mixins and constructors

Use for library visibility, classes, mixins and constructors. Adapted from [Effective Dart: Design](https://dart.dev/effective-dart/design). Examples are excerpts.

## Libraries

### PREFER making declarations private

Expose only the API clients need so implementation details can evolve independently.

**Good**

```dart
class _CacheEntry {} // Internal to this library.
```

**Bad**

```dart
class CacheEntry {} // Used only by this implementation.
```

### CONSIDER declaring multiple classes in the same library

Related types can share a library when that permits a private implementation or a cohesive public API.

**Good**

```dart
// In account.dart, next to Account:
class _AccountCache {}
```

**Bad**

```dart
// In account_cache.dart, exported only so Account can use it:
class AccountCache {}
```

## Classes and mixins

### AVOID defining a one-member abstract class when a simple function will do

Use a function type when the whole contract is a single callable operation and object identity adds no value.

**Bad**

```dart
abstract class Predicate<E> {
  bool test(E element);
}
```

**Good**

```dart
typedef Predicate<E> = bool Function(E element);
```

### AVOID defining a class that contains only static members

Top-level declarations suffice when there is no instance or class contract.

**Bad**

```dart
class DateUtils {
  static DateTime mostRecent(List<DateTime> dates) {
    return dates.reduce((a, b) => a.isAfter(b) ? a : b);
  }
}

class _Favorites {
  static const mammal = 'weasel';
}
```

**Good**

```dart
DateTime mostRecent(List<DateTime> dates) {
  return dates.reduce((a, b) => a.isAfter(b) ? a : b);
}

const _favoriteMammal = 'weasel';
```

### AVOID extending a class that isn't intended to be subclassed

Inherit only from types designed to preserve their contract under subclassing.

**Bad**

```dart
class LoggedStore extends Store {} // Store has no subclass contract.
```

**Good**

```dart
class LoggedStore { final Store delegate; LoggedStore(this.delegate); }
```

### DO use class modifiers to control if your class can be extended

Express the supported subclassing contract with a class modifier such as final, base or interface.

**Good**

```dart
final class LocalCache {} // No external subtypes intended.
```

**Bad**

```dart
class LocalCache {} // External subtypes would violate its invariants.
```

### AVOID implementing a class that isn't intended to be an interface

Only implement a type when its interface is intended for independent implementations.

**Bad**

```dart
class Session implements Client {} // Client has no interface contract.
```

**Good**

```dart
class Session { final Client client; Session(this.client); }
```

### DO use class modifiers to control if your class can be an interface

Use interface or other appropriate modifiers to communicate the implementation contract to consumers.

**Good**

```dart
abstract interface class AccountStore { Future<void> save(Account value); }
```

**Bad**

```dart
abstract class AccountStore { Future<void> save(Account value); } // Unintentionally allows external extension.
```

### PREFER defining a pure `mixin` or pure `class` to a `mixin class`

A dedicated mixin or class conveys the intended use. Choose a mixin class when both usages are deliberately supported.

**Good**

```dart
mixin Timestamped { DateTime get createdAt; }
```

**Bad**

```dart
mixin class Timestamped { DateTime get createdAt => DateTime.now(); } // Only mixing in is intended.
```

## Constructors

### CONSIDER making your constructor `const` if the class supports it

A const constructor allows callers to create constant instances when the type and its invariants support it.

**Good**

```dart
class Slot { const Slot(this.value); final int value; }
```

**Bad**

```dart
class Slot { Slot(this.value); final int value; } // Intended for const use.
```
