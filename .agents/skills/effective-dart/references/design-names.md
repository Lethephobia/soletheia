# Naming properties, methods and conversions

Use for naming properties, methods and conversions. Adapted from [Effective Dart: Design](https://dart.dev/effective-dart/design). Examples are excerpts.

## Names

### DO use terms consistently

Use the same domain word across related declarations so callers can predict names.

**Good**

```dart
pageCount         // A field.
updatePageCount() // Consistent with pageCount.
toSomething()     // Consistent with Iterable's toList().
asSomething()     // Consistent with List's asMap().
Point             // A familiar concept.
```

**Bad**

```dart
renumberPages()      // Confusingly different from pageCount.
convertToSomething() // Inconsistent with toX() precedent.
wrappedAsSomething() // Inconsistent with asX() precedent.
Cartesian            // Unfamiliar to most users.
```

### AVOID abbreviations

Spell unfamiliar terms out unless the abbreviation is established among the intended users.

**Bad**

```dart
numPages    // "Num" is an abbreviation of "number (of)".
buildRects
InputOutputStream
HypertextTransferProtocolRequest
```

**Good**

```dart
pageCount
buildRectangles
IOStream
HttpRequest
```

### PREFER putting the most descriptive noun last

Put the noun that identifies the thing last, as in accountAddress or RpcClient.

**Good**

```dart
pageCount             // A count (of pages).
ConversionSink        // A sink for doing conversions.
ChunkedConversionSink // A ConversionSink that's chunked.
CssFontFaceRule       // A rule for font faces in CSS.
```

**Bad**

```dart
numPages                  // Not a collection of pages.
CanvasRenderingContext2D  // Not a "2D".
RuleFontFaceCss           // Not a CSS.
```

### CONSIDER making the code read like a sentence

Read representative call sites aloud. Remove repetition while keeping the vocabulary precise.

**Good**

```dart
// "If errors is empty..."
if (errors.isEmpty) {
  // ...
}

// "Hey, subscription, cancel!"
subscription.cancel();

// "Get the monsters where the monster has claws."
monsters.where((monster) => monster.hasClaws);
```

**Bad**

```dart
// Telling errors to empty itself, or asking if it is?
if (errors.empty) {
  // ...
}

// Toggle what? To what?
subscription.toggle();

// Filter the monsters with claws *out* or include *only* those?
monsters.filter((monster) => monster.hasClaws);
```

### PREFER a noun phrase for a non-boolean property or variable

A non-boolean property should name the value it contains or computes.

**Good**

```dart
list.length
context.lineWidth
quest.rampagingSwampBeast
```

**Bad**

```dart
list.deleteItems
```

### PREFER a non-imperative verb phrase for a boolean property or variable

A boolean property reads as a predicate. Prefer isCustomEntropy, hasAccounts or canSubmit where those describe the condition.

**Good**

```dart
isEmpty
hasElements
canClose
closesWindow
canShowPopup
hasShownPopup
```

**Bad**

```dart
empty         // Adjective or verb?
withElements  // Sounds like it might hold elements.
closeable     // Sounds like an interface.
              // "canClose" reads better as a sentence.
closingWindow // Returns a bool or a window?
showPopup     // Sounds like it shows the popup.
```

### CONSIDER omitting the verb for a named boolean *parameter*

A named boolean option can omit a verb when the invocation remains unambiguous.

**Good**

```dart
list.toList(growable: false);
```

**Bad**

```dart
copyList(isGrowable: false);
```

### PREFER the "positive" name for a boolean property or variable

Prefer the positive condition so negation at the call site does not turn into a double negative.

**Good**

```dart
if (socket.isConnected && database.hasData) {
  socket.write(database.read());
}
```

**Bad**

```dart
if (!socket.isDisconnected && !database.isEmpty) {
  socket.write(database.read());
}
```

### PREFER an imperative verb phrase for a function or method whose main purpose is a side effect

Name mutating operations for the action a caller requests.

**Good**

```dart
store.deleteAccount(id);
```

**Bad**

```dart
store.accountDeletion(id);
```

### PREFER a noun phrase or non-imperative verb phrase for a function or method if returning a value is its primary purpose

Name queries for their result or for the relationship they evaluate.

**Good**

```dart
final offset = point.distanceTo(origin);
```

**Bad**

```dart
final offset = point.getDistanceTo(origin);
```

### CONSIDER an imperative verb phrase for a function or method if you want to draw attention to the work it performs

An action verb can make an expensive computation visible to the caller.

**Good**

```dart
final table = source.computeLookupTable(); // Rebuilds the table.
```

**Bad**

```dart
final table = source.table; // Rebuilds on each read.
```

### AVOID starting a function or method name with `get`

A property or domain-specific query name usually communicates more than a get prefix.

**Bad**

```dart
String getAddress() => _address;
```

**Good**

```dart
String get address => _address;
```

### PREFER naming a method `to___()` if it copies the object's state to a new object

A to-method produces a converted result independent of the receiver.

**Good**

```dart
List<int> toBytes() => [..._bytes];
```

**Bad**

```dart
List<int> asBytes() => [..._bytes];
```

### PREFER naming a method `as___()` if it returns a different representation backed by the original object

An as-method exposes a representation backed by the receiver; document how subsequent mutation is observed.

**Good**

```dart
Uint8List asBytes() => Uint8List.sublistView(_bytes);
```

**Bad**

```dart
Uint8List toBytes() => Uint8List.sublistView(_bytes);
```

### AVOID describing the parameters in the function's or method's name

Let parameter labels express argument roles. Include an input distinction in the name when it differentiates otherwise similar operations.

**Bad**

```dart
list.addElement(element)
map.removeKey(key)
```

**Good**

```dart
list.add(element);
map.remove(key);
```

### DO follow existing mnemonic conventions when naming type parameters

Use familiar generic parameter names for standard roles, such as K and V, and meaningful names for domain-specific roles.

**Good**

```dart
class Lookup<K, V> {}
```

**Bad**

```dart
class Lookup<A, B> {}
```
