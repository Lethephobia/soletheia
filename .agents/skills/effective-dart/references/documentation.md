# API comments, Markdown and wording

Use these examples when writing or reviewing aPI comments, Markdown and wording. Adapted from [Effective Dart: Documentation](https://dart.dev/effective-dart/documentation). Examples are excerpts.

## Comments

### DO format comments like sentences

Use capitalization and punctuation in comments written as prose.

**Good**

```dart
// Keep the order entered by the user.
```

**Bad**

```dart
// keep the order entered by the user
```

### DON'T use block comments for documentation

Use line comments for prose so individual lines are easy to edit and move.

**Bad**

```dart
void greet(String name) {
  /* Assume we have a valid name. */
  print('Hi, $name!');
}
```

**Good**

```dart
void greet(String name) {
  // Assume we have a valid name.
  print('Hi, $name!');
}
```

## Doc comments

### DO use `///` doc comments to document members and types

Use triple-slash comments for API documentation so dart doc associates the text with a declaration.

**Good**

```dart
/// The number of characters in this chunk when unsplit.
int get length => ...
```

**Bad**

```dart
// The number of characters in this chunk when unsplit.
int get length => ...
```

### PREFER writing doc comments for public APIs

Document observable behavior callers cannot infer from a signature.

**Good**

```dart
/// Removes the account metadata stored on this device.
Future<void> remove(Account account);
```

**Bad**

```dart
Future<void> remove(Account account);
```

### CONSIDER writing a library-level doc comment

A library comment is useful where it explains how related public types fit together.

**Good**

```dart
/// Local persistence for account metadata.
library;
```

**Bad**

```dart
// Local persistence for account metadata.
library;
```

### CONSIDER writing doc comments for private APIs

Explain non-obvious invariants on private declarations when doing so helps the next maintainer.

**Good**

```dart
/// The last confirmed slot, excluding optimistic updates.
int _confirmedSlot = 0;
```

**Bad**

```dart
int _confirmedSlot = 0; // Slot.
```

### DO start doc comments with a single-sentence summary

A standalone first sentence gives generated API listings a useful summary.

**Good**

```dart
/// Deletes the file at [path] from the file system.
void delete(String path) {
  ...
}
```

**Bad**

```dart
/// Depending on the state of the file system and the user's permissions,
/// certain operations may or may not be possible. If there is no file at
/// [path] or it can't be accessed, this function throws either [IOError]
/// or [PermissionError], respectively. Otherwise, this deletes the file.
void delete(String path) {
  ...
}
```

### DO separate the first sentence of a doc comment into its own paragraph

Start a new paragraph after the summary so the generated overview can display it independently.

**Good**

```dart
/// Deletes the file at [path].
///
/// Throws an [IOError] if the file could not be found. Throws a
/// [PermissionError] if the file is present but could not be deleted.
void delete(String path) {
  ...
}
```

**Bad**

```dart
/// Deletes the file at [path]. Throws an [IOError] if the file could not
/// be found. Throws a [PermissionError] if the file is present but could
/// not be deleted.
void delete(String path) {
  ...
}
```

### AVOID redundancy with the surrounding context

Describe behavior and constraints beyond information already visible in the name or type.

**Bad**

```dart
class RadioButtonWidget extends Widget {
  /// Sets the tooltip for this radio button widget to the list of strings in
  /// [lines].
  void tooltip(List<String> lines) {
    ...
  }
}
```

**Good**

```dart
class RadioButtonWidget extends Widget {
  /// Sets the tooltip to [lines].
  ///
  /// The lines should be word wrapped using the current font.
  void tooltip(List<String> lines) {
    ...
  }
}
```

### PREFER starting comments of a function or method with third-person verbs if its main purpose is a side effect

Describe an action with a present-tense verb such as “Stores” or “Removes.”

**Good**

```dart
/// Deletes the stored metadata.
```

**Bad**

```dart
/// Deleting metadata.
```

### PREFER starting a non-boolean variable or property comment with a noun phrase

Describe the value a reader gets from a property.

**Good**

```dart
/// The address of the selected account.
```

**Bad**

```dart
/// Gets the address of the selected account.
```

### PREFER starting a boolean variable or property comment with "Whether" followed by a noun or gerund phrase

Start boolean documentation with “Whether” to identify the condition under which it is true.

**Good**

```dart
/// Whether submission is available.
```

**Bad**

```dart
/// True when submission is available.
```

### PREFER a noun phrase or non-imperative verb phrase for a function or method if returning a value is its primary purpose

For a query, describe the result or the relationship being tested.

**Good**

```dart
/// The addresses visible to this user.
```

**Bad**

```dart
/// Get addresses.
```

### DON'T write documentation for both the getter and setter of a property

Document a read/write property once. Dart exposes the getter and setter together in API documentation.

**Bad**

```dart
/// The depth of the water in the pool, in meters.
int get waterDepth => ...

/// Updates the water depth to a total of [meters] in height.
set waterDepth(int meters) => ...
```

**Good**

```dart
/// The pH level of the water in the pool.
///
/// Ranges from 0-14, representing acidic to basic, with 7 being neutral.
int get phLevel => ...
set phLevel(int level) => ...
```

### PREFER starting library or type comments with noun phrases

Introduce the role of a type or library with a noun phrase.

**Good**

```dart
/// A store of account metadata.
```

**Bad**

```dart
/// This is a class called AccountStore.
```

### CONSIDER including code samples in doc comments

Include a short example when it helps the caller understand a format or interaction.

**Good**

```dart
/// Converts a byte count to bits, for example `bits(2) == 16`.
```

**Bad**

```dart
/// Converts the given number.
```

### DO use square brackets in doc comments to refer to in-scope identifiers

Bracket names that resolve in scope so dart doc can link to their definitions.

**Good**

```dart
/// Persists [account] for later lookup.
```

**Bad**

```dart
/// Persists `account` for later lookup.
```

### DO use prose to explain parameters, return values, and exceptions

Explain parameters, results and failure conditions together as prose that callers can read.

**Good**

```dart
/// Defines a flag with the given [name] and [abbreviation].
///
/// The [name] and [abbreviation] strings must not be empty.
///
/// Returns a new flag.
///
/// Throws a [DuplicateFlagException] if there is already an option named
/// [name] or there is already an option using the [abbreviation].
Flag addFlag(String name, String abbreviation) => ...
```

**Bad**

```dart
/// Defines a flag with the given name and abbreviation.
///
/// @param name The name of the flag.
/// @param abbr The abbreviation for the flag.
/// @returns The new flag.
/// @throws ArgumentError If there is already an option with
///     the given name or abbreviation.
Flag addFlag(String name, String abbreviation) => ...
```

### DO put doc comments before metadata annotations

Place documentation above metadata so it remains associated with the declaration.

**Good**

```dart
/// A button that can be flipped on and off.
@Component(selector: 'toggle')
class ToggleComponent {}
```

**Bad**

```dart
@Component(selector: 'toggle')
/// A button that can be flipped on and off.
class ToggleComponent {}
```

## Markdown

### AVOID using markdown excessively

Apply formatting where it helps scanning, and keep everyday descriptions easy to read as plain text.

**Bad**

```dart
/// **Returns** the *current* **slot**.
```

**Good**

```dart
/// Returns the current slot.
```

### AVOID using HTML for formatting

Use Markdown conventions that render well in both source and generated documentation.

**Bad**

```dart
/// See <b>Account</b> for the stored fields.
```

**Good**

```dart
/// See [Account] for the stored fields.
```

### PREFER backtick fences for code blocks

Use fenced blocks for multiline examples, with a language tag where appropriate.

**Good**

````dart
/// You can use [CodeBlockExample] like this:
///
/// ```dart
/// var example = CodeBlockExample();
/// print(example.isItGreat); // "Yes."
/// ```
````

**Bad**

```dart
/// You can use [CodeBlockExample] like this:
///
///     var example = CodeBlockExample();
///     print(example.isItGreat); // "Yes."
```

## Writing

### PREFER brevity

Choose the shortest wording that still communicates the contract.

**Good**

```dart
/// The selected account.
```

**Bad**

```dart
/// This property is used to hold the account that is currently selected.
```

### AVOID abbreviations and acronyms unless they are obvious

Expand unfamiliar abbreviations when their meaning would otherwise require outside knowledge.

**Bad**

```dart
/// The num. of pend. sigs.
```

**Good**

```dart
/// The number of pending signatures.
```

### PREFER using "this" instead of "the" to refer to a member's instance

Use “this” to identify the receiver when describing its state or relation to another object.

**Good**

```dart
/// The address of this account.
```

**Bad**

```dart
/// The address of the account.
```
