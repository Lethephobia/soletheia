import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

abstract final class AppTheme {
  static ThemeData get dark {
    final base = ThemeData(
      brightness: Brightness.dark,
      colorSchemeSeed: Colors.deepPurple,
    );

    return base.copyWith(
      textTheme: GoogleFonts.notoSansJpTextTheme(base.textTheme),
      primaryTextTheme: GoogleFonts.notoSansJpTextTheme(base.primaryTextTheme),
    );
  }
}
