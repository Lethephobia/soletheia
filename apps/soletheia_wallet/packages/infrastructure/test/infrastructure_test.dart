import 'package:infrastructure/infrastructure.dart';
import 'package:test/test.dart';

void main() {
  test('initializes and disposes the Rust bridge', () async {
    await initializeRust();
    RustLib.dispose();
  });
}
