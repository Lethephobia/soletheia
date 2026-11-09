# Member contracts and type annotations

Use for member contracts and type annotations. Adapted from [Effective Dart: Design](https://dart.dev/effective-dart/design). Examples are excerpts.

## Members

### PREFER making fields and top-level variables `final`

Keep a field final unless the abstraction requires reassignment.

**Good**

```dart
final RpcClient client;
```

**Bad**

```dart
RpcClient client; // Never reassigned.
```

### DO use getters for operations that conceptually access properties

Expose a conceptual property as a getter when reading it fits property semantics, including cost and side effects.

**Good**

```dart
rectangle.area;
collection.isEmpty;
button.canShow;
dataSet.minimumValue;
```

**Bad**

```dart
connection.nextIncomingMessage; // Does network I/O.
expression.normalForm; // Could be exponential to calculate.
```

### DO use setters for operations that conceptually change properties

Use a setter for replacing a conceptual property value; name other actions as methods.

**Good**

```dart
set timeout(Duration value) { _timeout = value; }
```

**Bad**

```dart
void setTimeout(Duration value) { _timeout = value; }
```

### DON'T define a setter without a corresponding getter

A write-only operation is clearer as a method than as a property callers cannot read.

**Bad**

```dart
set timeout(Duration value) { _timeout = value; } // No getter.
```

**Good**

```dart
Duration get timeout => _timeout;
set timeout(Duration value) { _timeout = value; }
```

### AVOID using runtime type tests to fake overloading

Offer distinct typed signatures when inputs represent separate operations.

**Bad**

```dart
Account parse(Object input); // Branches on runtime type.
```

**Good**

```dart
Account parseText(String text);
Account parseBytes(List<int> bytes);
```

### AVOID public `late final` fields without initializers

A public late final field without an initializer exposes a setter to consumers.

**Bad**

```dart
late final String address; // Consumers can initialize it.
```

**Good**

```dart
final String address;
Account(this.address);
```

### AVOID returning nullable `Future`, `Stream`, and collection types

Keep the container available. Use an empty collection or a nullable future result when that expresses the domain.

**Bad**

```dart
Future<Account>? findAccount(Id id);
```

**Good**

```dart
Future<Account?> findAccount(Id id);
```

### AVOID returning `this` from methods just to enable a fluent interface

Dart cascades already support grouping calls. Return a value when it has meaning for the operation.

**Bad**

```dart
var buffer =
    StringBuffer()
        .write('one')
        .write('two')
        .write('three');
```

**Good**

```dart
var buffer =
    StringBuffer()
      ..write('one')
      ..write('two')
      ..write('three');
```

## Types

### DO type annotate variables without initializers

An uninitialized variable needs a type so later assignments can be checked.

**Good**

```dart
List<AstNode> parameters;
if (node is Constructor) {
  parameters = node.signature;
} else if (node is Method) {
  parameters = node.parameters;
}
```

**Bad**

```dart
var parameters;
if (node is Constructor) {
  parameters = node.signature;
} else if (node is Method) {
  parameters = node.parameters;
}
```

### DO type annotate fields and top-level variables if the type isn't obvious

Make a field or top-level variable's type explicit when the initializer does not make its intended contract obvious.

**Good**

```dart
Future<bool> install(PackageId id, String destination) => ...
```

**Bad**

```dart
install(id, destination) => ...
```

### DON'T redundantly type annotate initialized local variables

Let inference communicate an obvious local type without duplicating it.

**Bad**

```dart
List<List<Ingredient>> possibleDesserts(Set<Ingredient> pantry) {
  List<List<Ingredient>> desserts = <List<Ingredient>>[];
  for (final List<Ingredient> recipe in cookbook) {
    if (pantry.containsAll(recipe)) {
      desserts.add(recipe);
    }
  }

  return desserts;
}
```

**Good**

```dart
List<List<Ingredient>> possibleDesserts(Set<Ingredient> pantry) {
  var desserts = <List<Ingredient>>[];
  for (final recipe in cookbook) {
    if (pantry.containsAll(recipe)) {
      desserts.add(recipe);
    }
  }

  return desserts;
}
```

### DO annotate return types on function declarations

Give declared functions an explicit result contract, including void.

**Good**

```dart
String makeGreeting(String who) {
  return 'Hello, $who!';
}
```

**Bad**

```dart
makeGreeting(String who) {
  return 'Hello, $who!';
}
```

### DO annotate parameter types on function declarations

Annotate declared function parameters so clients and tools can rely on the signature.

**Good**

```dart
void sayRepeatedly(String message, {int count = 2}) {
  for (var i = 0; i < count; i++) {
    print(message);
  }
}
```

**Bad**

```dart
void sayRepeatedly(message, {count = 2}) {
  for (var i = 0; i < count; i++) {
    print(message);
  }
}
```

### DON'T annotate inferred parameter types on function expressions

Use contextual typing for closure parameters when their types are already known.

**Bad**

```dart
var names = people.map((Person person) => person.name);
```

**Good**

```dart
var names = people.map((person) => person.name);
```

### DON'T type annotate initializing formals

Initializing formals obtain their type from the field declaration.

**Bad**

```dart
class Point {
  double x, y;
  Point(double this.x, double this.y);
}

class MyWidget extends StatelessWidget {
  MyWidget({Key? super.key});
}
```

**Good**

```dart
class Point {
  double x, y;
  Point(this.x, this.y);
}

class MyWidget extends StatelessWidget {
  MyWidget({super.key});
}
```

### DO write type arguments on generic invocations that aren't inferred

Specify type arguments when inference cannot recover the intended type.

**Good**

```dart
var playerScores = <String, int>{};
final events = StreamController<Event>();
```

**Bad**

```dart
var playerScores = {};
final events = StreamController();
```

### DON'T write type arguments on generic invocations that are inferred

Omit generic arguments already inferred correctly by the context.

**Bad**

```dart
class Downloader {
  final Completer<String> response = Completer<String>();
}
```

**Good**

```dart
class Downloader {
  final Completer<String> response = Completer();
}
```

### AVOID writing incomplete generic types

Supply type arguments for generic types so their element or result contracts remain checked.

**Bad**

```dart
[!List!] numbers = [1, 2, 3];
var completer = Completer<[!Map!]>();
```

**Good**

```dart
List<num> numbers = [1, 2, 3];
var completer = Completer<Map<String, int>>();
```

### DO annotate with `dynamic` instead of letting inference fail

Write dynamic explicitly where unchecked values are part of the intended contract.

**Good**

```dart
dynamic mergeJson(dynamic original, dynamic changes) => ...
```

**Bad**

```dart
mergeJson(original, changes) => ...
```

### PREFER signatures in function type annotations

Write a full function signature when the parameter and result types are known.

**Good**

```dart
bool isValid(String value, [!bool Function(String)!] test) => ...
```

**Bad**

```dart
bool isValid(String value, [!Function!] test) => ...
```

### DON'T specify a return type for a setter

Setters implicitly have no return value.

**Bad**

```dart
void set foo(Foo value) {
   ...
}
```

**Good**

```dart
set foo(Foo value) {
   ...
}
```

### DON'T use the legacy typedef syntax

Use equals-style typedef syntax so function and non-function aliases follow one form.

**Bad**

```dart
typedef int Comparison<T>(T a, T b);
```

**Good**

```dart
typedef Comparison<T> = int Function(T, T);
```

### PREFER inline function types over typedefs

Use an inline callback type when an alias adds no useful shared concept.

**Good**

```dart
void listen(void Function(Account) onAccount);
```

**Bad**

```dart
typedef Listener = void Function(Account);
void listen(Listener onAccount); // Alias used only here.
```

### PREFER using function type syntax for parameters

Declare callback parameters with function type syntax so the function's type is easy to see.

**Good**

```dart
void listen(void Function(Account) onAccount);
```

**Bad**

```dart
void listen(void onAccount(Account account));
```

### AVOID using `dynamic` unless you want to disable static checking

Use Object or Object? for arbitrary checked values. Choose dynamic for intentional dynamic dispatch.

**Bad**

```dart
dynamic value = readValue(); // No dynamic dispatch needed.
```

**Good**

```dart
Object? value = readValue();
```

### DO use `Future<void>` as the return type of asynchronous members that do not produce values

Expose Future<void> so clients can await completion and observe asynchronous failures.

**Good**

```dart
Future<void> save() async { await store.write(); }
```

**Bad**

```dart
void save() async { await store.write(); }
```

### AVOID using `FutureOr<T>` as a return type

Give consumers a predictable return contract. FutureOr is useful in some callback inputs where either form is accepted.

**Bad**

```dart
FutureOr<int> triple(FutureOr<int> value) {
  if (value is int) return value * 3;
  return value.then((v) => v * 3);
}
```

**Good**

```dart
Future<int> triple(FutureOr<int> value) async => (await value) * 3;
```
