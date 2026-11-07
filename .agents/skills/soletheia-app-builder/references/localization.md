# Localization

Use for app messages, ARB organization, and translator context.

### DO retain the official gen-l10n workflow with explicit message context

Currently keep only `app_en.arb` in `app/lib/l10n`. English is the sole supported and default
language, regardless of the system language. Retain gen-l10n and generated supportedLocales so
additional locale ARBs can be introduced later. Keep user-facing messages in ARB, not hard-coded
in widgets. Keep generated files alongside ARB without a generated directory. Add an English description for
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

### PREFER precise blockchain and Solana terminology

This is a developer-oriented wallet. Use established domain terms instead of replacing them with
consumer metaphors or vague onboarding language. Name the operation and its actual input, such as
mnemonic, private key, public key, keypair, transaction, or RPC endpoint. Keep distinct concepts
distinct: do not use mnemonic, seed, and private key interchangeably, or label a local keypair
operation as on-chain account creation unless it actually performs that operation. Verify terminology
against the implemented format and relevant official documentation when the distinction matters.
Short technical labels are preferable to explanatory marketing copy; retain information needed to
understand an operation's effects or handle secrets correctly.

**Good**

```text
Generate mnemonic
Import mnemonic
Import private key
RPC endpoint
```

**Bad**

```text
Start your journey -> hides which key material will be generated
Restore access -> does not distinguish a mnemonic from a private key
Connection destination -> obscures a field that specifically expects an RPC endpoint
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
