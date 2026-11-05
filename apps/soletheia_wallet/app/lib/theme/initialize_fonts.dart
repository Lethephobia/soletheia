import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void initializeFonts() {
  GoogleFonts.config.allowRuntimeFetching = false;
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString(
      'assets/google_fonts/Noto_Sans_JP/OFL.txt',
    );
    yield LicenseEntryWithLineBreaks(['Noto Sans JP'], license);
  });
}
