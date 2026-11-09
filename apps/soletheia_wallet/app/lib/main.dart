import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infrastructure/rust.dart';
import 'package:material_ui/material_ui.dart';

import 'account.dart';
import 'app.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeFonts();
  await initializeRust();
  final container = ProviderContainer();
  final subscription = container.listen(accountsProvider.future, (_, _) {});
  await subscription.read();
  subscription.close();
  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
