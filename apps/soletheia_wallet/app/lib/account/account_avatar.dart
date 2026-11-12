import 'package:application/account.dart';
import 'package:material_ui/material_ui.dart';

class AccountAvatar extends StatelessWidget {
  const AccountAvatar({super.key, required this.address});

  final AccountAddress address;
  static const _radius = 16.0;
  static const _patternSize = 20.0;

  @override
  Widget build(BuildContext context) {
    final bytes = address.bytes;
    final hue = bytes.fold<int>(0, (sum, byte) => sum + byte) % 360;
    return CircleAvatar(
      radius: _radius,
      backgroundColor: HSLColor.fromAHSL(
        1,
        hue.toDouble(),
        0.45,
        0.27,
      ).toColor(),
      child: CustomPaint(
        size: const Size.square(_patternSize),
        painter: _IdenticonPainter(address),
      ),
    );
  }
}

class _IdenticonPainter extends CustomPainter {
  const _IdenticonPainter(this.address);
  final AccountAddress address;
  static const _columns = 5;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / _columns;
    final paint = Paint()..color = Colors.white;
    for (var row = 0; row < _columns; row++) {
      for (var col = 0; col < _columns; col++) {
        final mirrored = col < 3 ? col : _columns - 1 - col;
        final index = row * 3 + mirrored;
        if ((address.bytes[index] ^ address.bytes[index + 15]).isOdd ||
            (row == 2 && col == 2)) {
          canvas.drawRect(
            Rect.fromLTWH(col * cell, row * cell, cell, cell),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_IdenticonPainter oldDelegate) {
    return oldDelegate.address != address;
  }
}
