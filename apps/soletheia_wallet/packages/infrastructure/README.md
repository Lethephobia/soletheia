# Infrastructure

Flutter connects to the Rust crate in `rust/`. The `src/api/account/` bridge returns the account address and mnemonic ID after Rust saves the secrets.

Run the bridge tests from this directory on macOS. Point the test runner at the library produced by Flutter's build hook:

```sh
FRB_DART_LOAD_EXTERNAL_LIBRARY_NATIVE_LIB_DIR=build/native_assets/macos flutter test
```
