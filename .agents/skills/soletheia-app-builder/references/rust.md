# Rust

Use for the wallet's application-specific Rust implementation and Flutter boundary.

### DO keep Rust behind the infrastructure package and a focused bridge facade

Rust lives under `apps/soletheia_wallet/packages/infrastructure/rust`. The current workspace member
`flutter_bridge` is the FFI facade, with `crate::api` configured as the bridge input. Add implementation
crates under `rust/crates` when concrete functionality needs them, and register them as workspace
members. Do not create speculative infrastructure/application crates or restore the removed CLI.
Use same-name module files rather than mod.rs.

**Good**

```text
rust/flutter_bridge/src/api.rs -> Flutter-facing API
rust/crates/<implementation>/ -> added when functionality requires it
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
the boundary. Native Assets hooks build Rust; lib/src/rust.dart owns the current Apple loading
adapter. Regenerate bridge bindings with the project's compatible generator after API changes.
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
