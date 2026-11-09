# Parameters, ranges and value equality

Use for parameters, ranges and value equality. Adapted from [Effective Dart: Design](https://dart.dev/effective-dart/design). Examples are excerpts.

## Parameters

### AVOID positional boolean parameters

A named boolean option makes the choice visible where the operation is invoked.

**Bad**

```dart
new Task(true);
new Task(false);
new ListBox(false, true, true);
new Button(false);
```

**Good**

```dart
Task.oneShot();
Task.repeating();
ListBox(scroll: true, showScrollbars: true);
Button(ButtonState.enabled);
```

### AVOID optional positional parameters if the user may want to omit earlier parameters

Named options allow a caller to omit earlier optional arguments.

**Bad**

```dart
query(null, 10); // Must fill the earlier optional slot.
```

**Good**

```dart
query(limit: 10);
```

### AVOID mandatory parameters that accept a special "no argument" value

Represent absence as an optional argument when callers should not have to pass a sentinel.

**Bad**

```dart
var rest = string.substring(start, null);
```

**Good**

```dart
var rest = string.substring(start);
```

### DO use inclusive start and exclusive end parameters to accept a range

Use a half-open interval so empty and adjacent ranges compose naturally.

**Good**

```dart
words.sublist(start, end); // Length is end - start.
```

**Bad**

```dart
slice(start, lastIncluded); // Caller must subtract one to split adjacent ranges.
```

## Equality

### DO override `hashCode` if you override `==`

Objects equal under == must have equal hash codes.

**Good**

```dart
@override
int get hashCode => value.hashCode; // Equality compares value.
```

**Bad**

```dart
// Equality compares value; hashCode is inherited from Object.
```

### DO make your `==` operator obey the mathematical rules of equality

Equality must be reflexive, symmetric, transitive, and stable while compared values are unchanged.

**Good**

```dart
bool operator ==(Object other) => other is Slot && value == other.value;
```

**Bad**

```dart
bool operator ==(Object other) => other is Slot && value <= other.value;
```

### AVOID defining custom equality for mutable classes

Mutation of equality-relevant fields invalidates assumptions in sets and maps.

**Bad**

```dart
class Slot { int value; Slot(this.value); /* Hash and equality change when value changes. */ }
```

**Good**

```dart
final class Slot { final int value; const Slot(this.value); /* Equality uses value. */ }
```

### DON'T make the parameter to `==` nullable

Declare the equality parameter as Object; the language handles null comparisons separately.

**Bad**

```dart
class Person {
  final String name;

  // ···

  bool operator ==([!Object?!] other) =>
      other != null && other is Person && name == other.name;
}
```

**Good**

```dart
class Person {
  final String name;

  // ···

  bool operator ==(Object other) => other is Person && name == other.name;
}
```
