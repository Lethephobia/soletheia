# Identifiers, directives and formatting

Use these examples when writing or reviewing identifiers, directives and formatting. Adapted from [Effective Dart: Style](https://dart.dev/effective-dart/style). Examples are excerpts.

## Identifiers

### DO name types using `UpperCamelCase`

Readers recognize types across constructors, annotations and type positions by their capitalization.

**Good**

```dart
class RpcClient {}
```

**Bad**

```dart
class rpc_client {}
```

### DO name extensions using `UpperCamelCase`

A named extension uses the same capitalization as the type it extends.

**Good**

```dart
extension AccountLabels on Account {}
```

**Bad**

```dart
extension accountLabels on Account {}
```

### DO name packages, directories, and source files using `lowercase_with_underscores`

Lowercase file and directory names work consistently on case-sensitive and case-insensitive filesystems.

**Good**

```plaintext
my_package
└─ lib
   └─ file_system.dart
   └─ slider_menu.dart
```

**Bad**

```plaintext
mypackage
└─ lib
   └─ file-system.dart
   └─ SliderMenu.dart
```

### DO name import prefixes using `lowercase_with_underscores`

A prefix names a library namespace. Underscores separate words in that namespace.

**Good**

```dart
import 'dart:math' as math;

import 'package:angular_components/angular_components.dart' as angular_components;
import 'package:web/web.dart' as web;
```

**Bad**

```dart
import 'dart:math' as Math;

import 'package:angular_components/angular_components.dart' as angularComponents;
import 'package:web/web.dart' as Web;
```

### DO name other identifiers using `lowerCamelCase`

Use lower camel case for fields, functions, parameters and local variables.

**Good**

```dart
final accountCount = accounts.length;
```

**Bad**

```dart
final account_count = accounts.length;
```

### PREFER using `lowerCamelCase` for constant names

Ordinary constant names follow field naming conventions. Preserve established external naming conventions when interoperability requires it.

**Good**

```dart
const pi = 3.14;
const defaultTimeout = 1000;
final urlScheme = RegExp('^([a-z]+):');

class Dice {
  static final numberGenerator = Random();
}
```

**Bad**

```dart
const PI = 3.14;
const DefaultTimeout = 1000;
final URL_SCHEME = RegExp('^([a-z]+):');

class Dice {
  static final NUMBER_GENERATOR = Random();
}
```

### DO capitalize acronyms and abbreviations longer than two letters like words

Spell long acronyms as words, as in HttpClient. A two-letter acronym inside a name may stay uppercase, as in hostIP.

**Good**

```dart
// Longer than two letters, so always like a word:
Http // "hypertext transfer protocol"
Nasa // "national aeronautics and space administration"
Uri // "uniform resource identifier"
Esq // "esquire"
Ave // "avenue"

// Two letters, capitalized in English, so capitalized in an identifier:
ID // "identifier"
TV // "television"
UI // "user interface"

// Two letters, not capitalized in English, so like a word in an identifier:
Mr // "mister"
St // "street"
Rd // "road"
```

**Bad**

```dart
HTTP // "hypertext transfer protocol"
NASA // "national aeronautics and space administration"
URI // "uniform resource identifier"
esq // "esquire"
ave // "avenue"

Id // "identifier"
Tv // "television"
Ui // "user interface"

MR // "mister"
ST // "street"
RD // "road"
```

### PREFER using wildcards for unused callback parameters

Where the language version supports wildcards, each unused callback parameter can be named _ independently.

**Good**

```dart
builder: (_, child) => child!
```

**Bad**

```dart
builder: (unusedContext, child) => child!
```

### DON'T use a leading underscore for identifiers that aren't private

An underscore conveys library privacy on declarations that support it. It adds no privacy to local variables or parameters.

**Bad**

```dart
void save(String _address) {}
```

**Good**

```dart
void save(String address) {}
```

### DON'T use prefix letters

Use Dart privacy and type syntax to communicate scope and type. Prefix letters make searches and call sites less clear.

**Bad**

```dart
kDefaultTimeout
```

**Good**

```dart
defaultTimeout
```

### DON'T explicitly name libraries

The file URI identifies a library. A bare library directive still has a purpose when attaching documentation or annotations.

**Bad**

```dart
library my_library;
```

**Good**

```dart
/// A really great test library.
@TestOn('browser')
library;
```

## Ordering

### DO place `dart:` imports before other imports

Put SDK dependencies together before third-party and local dependencies.

**Good**

```dart
import 'dart:async';

import 'package:wallet/wallet.dart';
```

**Bad**

```dart
import 'package:wallet/wallet.dart';

import 'dart:async';
```

### DO place `package:` imports before relative imports

Keep package URIs together before relative URIs so a reader can distinguish external libraries from adjacent files.

**Good**

```dart
import 'package:wallet/wallet.dart';

import 'account.dart';
```

**Bad**

```dart
import 'account.dart';

import 'package:wallet/wallet.dart';
```

### DO specify exports in a separate section after all imports

Place the public exports after dependencies. A barrel can consist entirely of exports.

**Good**

```dart
import 'src/error.dart';
import 'src/foo_bar.dart';

export 'src/error.dart';
```

**Bad**

```dart
import 'src/error.dart';
export 'src/error.dart';
import 'src/foo_bar.dart';
```

### DO sort sections alphabetically

Alphabetize within each directive group to keep additions predictable.

**Good**

```dart
import 'package:bar/bar.dart';
import 'package:foo/foo.dart';

import 'foo.dart';
import 'foo/foo.dart';
```

**Bad**

```dart
import 'package:foo/foo.dart';
import 'package:bar/bar.dart';

import 'foo/foo.dart';
import 'foo.dart';
```

## Formatting

### DO format your code using `dart format`

Use dart format on edited source so indentation and wrapping follow the package's formatter.

**Good**

```dart
final count = words.length;
```

**Bad**

```dart
final count=words.length;
```

### CONSIDER changing your code to make it more formatter-friendly

If the formatted result obscures a calculation, give a meaningful intermediate expression a name.

**Good**

```dart
final active = accounts.where(isActive);
final addresses = active.map(addressOf);
```

**Bad**

```dart
final addresses = accounts.where((a) => isActive(a)).map((a) => addressOf(a));
```

### PREFER lines 80 characters or fewer

An 80-character target leaves room for side-by-side review. Long URLs, literal strings and other unsplittable text can warrant an exception.

**Good**

```dart
/// Restores an account from the supplied words.
/// The caller chooses the derivation path.
```

**Bad**

```dart
/// Restores an account from the supplied words. The caller chooses the derivation path.
```

### DO use curly braces for all flow control statements

Braces make control flow unambiguous as branches grow. The guide allows a short, single-line if without an else.

**Good**

```dart
if (isWeekDay) {
  print('Bike to work!');
} else {
  print('Go dancing or read a book!');
}
```

**Bad**

```dart
if (overflowChars != other.overflowChars)
  return overflowChars < other.overflowChars;
```
