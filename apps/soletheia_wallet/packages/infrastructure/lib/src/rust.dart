import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_io.dart';

import 'rust/frb_generated.dart';

const _assetId = 'package:infrastructure/src/rust/frb_generated.io.dart';

@Native<Int32 Function()>(
  symbol: 'frb_get_rust_content_hash',
  assetId: _assetId,
)
external int _contentHash();

final class _DlInfo extends Struct {
  external Pointer<Utf8> filename;
  external Pointer<Void> base;
  external Pointer<Utf8> symbolName;
  external Pointer<Void> symbolAddress;
}

/// Initializes FRB with the library bundled by the Native Assets build hook.
Future<void> initializeRust() async {
  // FRB 2.13 requires a DynamicLibrary. Resolve the Apple dylib path from a
  // Native Assets symbol until Dart's DynamicLibrary.codeAsset is available.
  final dladdr = DynamicLibrary.process()
      .lookupFunction<
        Int32 Function(Pointer<Void>, Pointer<_DlInfo>),
        int Function(Pointer<Void>, Pointer<_DlInfo>)
      >('dladdr');
  final info = calloc<_DlInfo>();
  try {
    final symbol = Native.addressOf<NativeFunction<Int32 Function()>>(
      _contentHash,
    );
    if (dladdr(symbol.cast(), info) == 0 || info.ref.filename == nullptr) {
      throw StateError('Could not locate the bundled Rust library.');
    }
    await RustLib.init(
      externalLibrary: ExternalLibrary.open(info.ref.filename.toDartString()),
    );
  } finally {
    calloc.free(info);
  }
}
