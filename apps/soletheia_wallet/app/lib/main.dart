import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infrastructure/rust.dart';
import 'package:material_ui/material_ui.dart';

import 'app.dart';
import 'account.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeFonts();
  await initializeRust();
  final container = ProviderContainer();
  await container.read(accountCatalogProvider.notifier).load();
  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
