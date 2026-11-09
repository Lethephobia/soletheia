---
name: effective-dart
description: Apply Effective Dart when writing or reviewing hand-written Dart and Flutter code. Use for identifier and API naming, documentation, imports, collection and async idioms, type contracts, and equality.
---

# Effective Dart

When implementing a change, check how a caller will read the API, then apply the
relevant topic guides below. When reviewing, show a concrete call site or
replacement for each finding. Distinguish requirements (DO, DON'T), defaults
with exceptions (PREFER, AVOID), and choices that depend on context (CONSIDER).
Use the package's supported language version for syntax choices.

## Topic guides

Read the guides relevant to the changed code. Each rule keeps its upstream strength and pairs a rationale with Good and Bad examples.

- [Identifiers, directives and formatting](references/style.md)
- [API comments, Markdown and wording](references/documentation.md)
- [Imports, nullability, strings and collections](references/usage-libraries-values.md)
- [Functions, variables, members and constructors](references/usage-members.md)
- [Errors, futures and streams](references/usage-errors-async.md)
- [Naming properties, methods and conversions](references/design-names.md)
- [Library visibility, classes, mixins and constructors](references/design-libraries-classes.md)
- [Member contracts and type annotations](references/design-members-types.md)
- [Parameters, ranges and value equality](references/design-parameters-equality.md)

Format edited Dart files, run the package analyzer, and read changed APIs at their call sites. Apply project-specific rules alongside these language guidelines.

## Sources

Adapted from [Effective Dart by the Dart project authors](https://dart.dev/effective-dart) ([source revision](https://github.com/dart-lang/site-www/tree/203d8441af9c32d965a2bdb12e7f204360d317a8/src/content/effective-dart)). The references regroup the rules, summarize their rationale and supplement the code examples. See the [upstream license](UPSTREAM-LICENSE) for the original text and sample licenses.
