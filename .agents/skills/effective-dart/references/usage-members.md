# Functions, variables, members and constructors

Use these examples when writing or reviewing functions, variables, members and constructors. Adapted from [Effective Dart: Usage](https://dart.dev/effective-dart/usage). Examples are excerpts.

## Functions

### DO use a function declaration to bind a function to a name

Give a named function a declaration so readers and tools can identify the function directly.

**Good**

```dart
void main() {
  void localFunction() {
    ...
  }
}
```

**Bad**

```dart
void main() {
  var localFunction = () {
    ...
  };
}
```

### DON'T create a lambda when a tear-off will do

Pass the method itself when argument lists and results match. Keep a closure when adapting arguments or capturing extra data.

**Bad**

```dart
var charCodes = [68, 97, 114, 116];
var buffer = StringBuffer();

// Function:
charCodes.forEach((code) {
  print(code);
});

// Method:
charCodes.forEach((code) {
  buffer.write(code);
});

// Named constructor:
var strings = charCodes.map((code) => String.fromCharCode(code));

// Unnamed constructor:
var buffers = charCodes.map((code) => StringBuffer(code));
```

**Good**

```dart
var charCodes = [68, 97, 114, 116];
var buffer = StringBuffer();

// Function:
charCodes.forEach(print);

// Method:
charCodes.forEach(buffer.write);

// Named constructor:
var strings = charCodes.map(String.fromCharCode);

// Unnamed constructor:
var buffers = charCodes.map(StringBuffer.new);
```

## Variables

### DO follow a consistent rule for `var` and `final` on local variables

Use a consistent local convention for var and final; the guide permits different conventions.

**Good**

```dart
final words = readWords();
final addresses = readAddresses();
```

**Bad**

```dart
final words = readWords();
var addresses = readAddresses(); // Also never reassigned.
```

### AVOID storing what you can calculate

Compute inexpensive values from their source to avoid synchronizing duplicate state.

**Bad**

```dart
class Circle {
  double radius;
  double area;
  double circumference;

  Circle(double radius)
    : radius = radius,
      area = pi * radius * radius,
      circumference = pi * 2.0 * radius;
}
```

**Good**

```dart
class Circle {
  double radius;

  Circle(this.radius);

  double get area => pi * radius * radius;
  double get circumference => pi * 2.0 * radius;
}
```

## Members

### DON'T wrap a field in a getter and setter unnecessarily

A public field already exposes accessors. Add explicit accessors when they implement behavior.

**Bad**

```dart
class Box {
  Object? _contents;
  Object? get contents => _contents;
  set contents(Object? value) {
    _contents = value;
  }
}
```

**Good**

```dart
class Box {
  Object? contents;
}
```

### PREFER using a `final` field to make a read-only property

Use final when callers only need to read a stored field.

**Good**

```dart
class Box {
  final contents = [];
}
```

**Bad**

```dart
class Box {
  Object? _contents;
  Object? get contents => _contents;
}
```

### CONSIDER using `=>` for simple members

An expression body can clarify a simple member. In Soletheia, use a block when the formatted implementation needs multiple lines.

**Good**

```dart
double get area => (right - left) * (bottom - top);

String capitalize(String name) =>
    '${name[0].toUpperCase()}${name.substring(1)}';
```

**Bad**

```dart
Treasure? openChest(Chest chest, Point where) => _opened.containsKey(chest)
    ? null
    : _opened[chest] = (Treasure(where)..addAll(chest.contents));
```

### DON'T use `this.` except to redirect to a named constructor or to avoid shadowing

Qualify with this only when resolving shadowing or redirecting to another constructor.

**Bad**

```dart
class Box {
  Object? value;

  void clear() {
    this.update(null);
  }

  void update(Object? value) {
    this.value = value;
  }
}
```

**Good**

```dart
class Box {
  Object? value;

  void clear() {
    update(null);
  }

  void update(Object? value) {
    this.value = value;
  }
}
```

### DO initialize fields at their declaration when possible

Put a shared initial value on the field so constructors use it consistently.

**Good**

```dart
class ProfileMark {
  final String name;
  final DateTime start = DateTime.now();

  ProfileMark(this.name);
  ProfileMark.unnamed() : name = '';
}
```

**Bad**

```dart
class ProfileMark {
  final String name;
  final DateTime start;

  ProfileMark(this.name) : start = DateTime.now();
  ProfileMark.unnamed() : name = '', start = DateTime.now();
}
```

## Constructors

### DO use initializing formals when possible

An initializing formal directly binds the argument to its field.

**Good**

```dart
class Point {
  double x, y;
  Point(this.x, this.y);
}
```

**Bad**

```dart
class Point {
  double x, y;
  Point(double x, double y) : x = x, y = y;
}
```

### DON'T use `late` when a constructor initializer list will do

Initialize fields during construction when possible so their readiness is guaranteed by the type system.

**Bad**

```dart
class Point {
  late double x, y;
  Point.polar(double theta, double radius) {
    x = cos(theta) * radius;
    y = sin(theta) * radius;
  }
}
```

**Good**

```dart
class Point {
  double x, y;
  Point.polar(double theta, double radius)
    : x = cos(theta) * radius,
      y = sin(theta) * radius;
}
```

### DO use `;` instead of `{}` for empty constructor bodies

End a constructor with a semicolon when it has no statements.

**Good**

```dart
class Point {
  double x, y;
  Point(this.x, this.y);
}
```

**Bad**

```dart
class Point {
  double x, y;
  Point(this.x, this.y) {}
}
```

### PREFER using concise constructor syntax

Use concise constructor syntax where the package's language version supports it and it improves the declaration.

**Good**

```dart
class Logger {
  final String name;

  factory(String name) => _cache[name] ??= Logger._internal(name);

  new _internal(this.name);
  new fromJson(Map<String, Object?> json) : name = json['name'] as String;

  static final Map<String, Logger> _cache = {};
}
```

**Bad**

```dart
class Logger {
  final String name;

  factory Logger(String name) => _cache[name] ??= Logger._internal(name);

  Logger._internal(this.name);
  Logger.fromJson(Map<String, Object?> json) : name = json['name'] as String;

  static final Map<String, Logger> _cache = {};
}
```

### DON'T use `new`

Dart constructor invocations do not need new.

**Bad**

```dart
Widget build(BuildContext context) {
  return [!new!] Row(
    children: [
      [!new!] RaisedButton(child: [!new!] Text('Increment')),
      [!new!] Text('Click!'),
    ],
  );
}
```

**Good**

```dart
Widget build(BuildContext context) {
  return Row(
    children: [
      RaisedButton(child: Text('Increment')),
      Text('Click!'),
    ],
  );
}
```

### DON'T use `const` redundantly

An enclosing const context already applies to nested constant expressions.

**Bad**

```dart
const primaryColors = [!const!] [
  [!const!] Color('red', [!const!] [255, 0, 0]),
  [!const!] Color('green', [!const!] [0, 255, 0]),
  [!const!] Color('blue', [!const!] [0, 0, 255]),
];
```

**Good**

```dart
const primaryColors = [
  Color('red', [255, 0, 0]),
  Color('green', [0, 255, 0]),
  Color('blue', [0, 0, 255]),
];
```
