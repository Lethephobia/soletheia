---
name: effective-dart
description: Apply Effective Dart when writing or reviewing hand-written Dart and Flutter code. Use for identifier and API naming, documentation, imports, collection and async idioms, type contracts, and equality.
---

# Effective Dart

When implementing a change, check how a caller will read the API, then apply the
relevant language idioms below. When reviewing, show a concrete call site or
replacement for each finding. Distinguish requirements (DO, DON'T), defaults
with exceptions (PREFER, AVOID), and choices that depend on context (CONSIDER).
Use the package's supported language version for syntax choices.

## Style

- DO use names like `RpcClient` for types and extensions, `rpc_client.dart` for
  files, and `rpcClient` for members. PREFER lowerCamelCase for constants too.
  Use a leading underscore for library privacy and `_` for an unused callback parameter.
- DO group directives in this order: SDK imports, package imports, relative
  imports, then exports. Sort each group by URI.
- DO use braces around control-flow bodies and run `dart format` on edited files.
  PREFER lines of at most 80 characters. If an expression formats awkwardly,
  simplify the expression before trying to control wrapping.

## Documentation

- PREFER documenting public contracts. DO write `///` before annotations and
  start with one summary sentence in its own paragraph. Use the following
  paragraph for observable behavior such as validation, side effects, or errors.
- PREFER a noun phrase for a value and “Whether …” for a flag. Describe an action
  with a verb such as “Stores …”. Document a getter/setter pair once.
- DO refer to symbols with square brackets. Explain parameters, results, and
  exceptions in prose. For example, the following tells the caller when validation matters:

  ```dart
  /// Whether the form accepts entropy supplied by the user.
  ///
  /// When enabled, [entropy] must be valid before submission.
  final bool isCustomEntropy;
  ```

## Usage

- PREFER relative imports within the same `lib` tree. Use package URIs across
  the `lib` boundary and import another package through its public libraries.
- For a non-nullable flag, write `if (form.isCustomEntropy)`. For a nullable
  value, use promotion or a null-check pattern when possible. A nullable field
  expresses absence directly when initialization status must be inspected.
- Use collection literals, `isEmpty` or `isNotEmpty`, and `whereType<T>()` for
  type filtering. Pass an existing callback directly when its signature fits:
  `onChanged: viewModel.setCustomEntropy`.
- PREFER read-only fields for stored values and getters for inexpensive derived
  values. Initialize fields at declaration or during construction. Use
  initializing formals when possible, as in `Account(this.address);`.
- PREFER `async` and `await` for sequencing. A simple forwarding method can
  return the existing future directly. Catch the specific exception you can
  handle; use `rethrow` to propagate it with its original stack trace. Reserve
  `Error` for programming mistakes.

## Design

- PREFER positive predicates for boolean state. Compare `if (form.customEntropy)`
  with `if (form.isCustomEntropy)`: the second reads as a condition. Choose the
  verb that fits, as in `hasAccounts` or `canSubmit`. A named option such as
  `growable: false` may read better without a verb.
- PREFER nouns for values, action verbs for side effects, and getters for
  property access. Use `to…` for an independent converted value and `as…` for a
  view backed by the original. Keep terms consistent across related APIs.
- Annotate declared function parameters and results. Trust inference for
  initialized locals and callbacks when the type is clear. Prefer named
  options to positional booleans; compare `save(overwrite: true)` with `save(true)`.
- Use `Future<void>` for async work with no result. For an asynchronous lookup
  that can miss, `Future<Account?>` lets callers always await the operation.
- Keep implementation details private. Choose class modifiers according to
  whether consumers may extend or implement the type. For value equality,
  compare an `Object` parameter, keep equality symmetric and transitive, and
  compute matching hash codes from the same stable data.

Run the package analyzer after Dart edits. Review API naming and documentation
at the call site as well, since static analysis only covers part of the guide.

These local instructions summarize the official [Style](https://dart.dev/effective-dart/style),
[Documentation](https://dart.dev/effective-dart/documentation),
[Usage](https://dart.dev/effective-dart/usage), and
[Design](https://dart.dev/effective-dart/design) chapters. Use those chapters to
resolve edge cases and to refresh this skill when the guide changes.
