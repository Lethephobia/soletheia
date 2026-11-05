import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:material_ui/material_ui.dart';

import 'app.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeFonts();
  await initializeRust();
  runApp(const ProviderScope(child: App()));
}
