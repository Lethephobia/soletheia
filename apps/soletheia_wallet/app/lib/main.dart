import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:material_ui/material_ui.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString(
      'assets/google_fonts/Noto_Sans_JP/OFL.txt',
    );
    yield LicenseEntryWithLineBreaks(['Noto Sans JP'], license);
  });
  await RustLib.init();
  runApp(const ProviderScope(child: App()));
}
