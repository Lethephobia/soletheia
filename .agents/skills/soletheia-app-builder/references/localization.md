# Localization

Use for app messages, ARB organization, and translator context.

### DO retain the official gen-l10n workflow with explicit message context

Keep one ARB per locale in `app/lib/l10n`, with English as the template and matching message order
in other locales. Keep generated localization files there, without adding a generated directory.
The app follows the system language with its configured fallback. Add an English description for
each template key; `required-resource-attributes: true` enforces metadata presence, not its quality.
Name keys by feature, screen or usage, and element. Avoid over-sharing text just because its current
translation matches. Navigation labels and page titles have separate purposes.

**Good**

```json
{
  "navigationAccountLabel": "Accounts",
  "@navigationAccountLabel": {
    "description": "Navigation bar and navigation rail label for the accounts destination."
  },
  "accountListTitle": "Accounts",
  "@accountListTitle": {
    "description": "App bar title of the account list screen."
  }
}
```

**Bad**

```json
{
  "title": "Accounts",
  "text2": "No accounts"
}
```

### PREFER complete messages with typed placeholders and ICU plural/select syntax

Keep language-dependent word order and plural rules in ARB. Reuse a message only when its meaning
and usage are shared, such as a cancellation action. Consider separate localization bundles when
a feature becomes an independent package; gen-l10n does not automatically merge multiple ARBs
of the same locale into one bundle.

**Good**

```json
{
  "accountDeleteConfirmation": "Delete account {name}?",
  "@accountDeleteConfirmation": {
    "description": "Confirmation message before deleting the named account.",
    "placeholders": {"name": {"type": "String", "example": "Development"}}
  }
}
```

**Bad**

```dart
// Fragment order and punctuation cannot adapt to the target language.
Text(l10n.deletePrefix + account.name + '?');
```
