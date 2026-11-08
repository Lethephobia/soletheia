# Rust

Use for the wallet's application-specific Rust implementation and Flutter boundary.

### DO keep Rust behind the infrastructure package and a focused bridge facade

The wallet builds a single crate at `apps/soletheia_wallet/packages/infrastructure/rust`.
Keep feature implementations and their Flutter-facing functions in Rust modules. FRB currently
reads the account creation API, its mnemonic input types, and `crate::api::init`. Use a file named after its module and place
child modules in the matching directory.

**Good**

```text
rust/src/api/account.rs -> Flutter-facing account creation API
rust/src/infrastructure/bip39/bip39_mnemonic_generator.rs -> generation logic and unit tests
src/signing.rs + src/signing/<child>.rs -> module layout
```

**Bad**

```text
Restore a shared native backend and CLI without a requested consumer.
Add empty architecture crates before implementing any capability.
src/signing/mod.rs -> conflicts with the chosen module convention
```

### DO preserve generated integration and the Native Assets build path

Inspect flutter_rust_bridge.yaml, hook/build.dart, Cargo manifests, and the toolchain before changing
the boundary. Native Assets hooks build Rust. Keep handwritten adapters and initialization in
`lib/src/rust/` and generated bindings in `lib/src/rust_bridge/`. Regenerate bridge bindings
with the project's compatible generator after API changes.
Inspect the generation diff; do not hand-edit frb_generated files. Treat toolchain versions and
platform support as live configuration, not immutable rules in this skill.

**Good**

```text
Change Rust API -> regenerate FRB bindings -> verify Dart and Rust consumers.
Change loader behavior -> edit the handwritten adapter and exercise initialization.
```

**Bad**

```text
Patch generated bindings to hide an API mismatch.
Reintroduce Cargokit or CocoaPods solely because an old migration used them.
```
