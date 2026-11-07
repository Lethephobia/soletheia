# Infrastructure

Flutter connects to the Rust crate in `rust/`. Its `src/mnemonic/` module implements BIP-39 phrase generation.

Run the bridge tests from this directory on macOS. Point the test runner at the library produced by Flutter's build hook:

```sh
FRB_DART_LOAD_EXTERNAL_LIBRARY_NATIVE_LIB_DIR=build/native_assets/macos flutter test
```
