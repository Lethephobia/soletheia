import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

extension WalletWidgetTester on WidgetTester {
  Future<void> pumpWalletWidget(Widget widget) async {
    await pumpWidget(widget);
    await runAsync(() => GoogleFonts.pendingFonts());
    await pumpAndSettle();
  }
}
