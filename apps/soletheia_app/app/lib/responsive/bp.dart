import 'package:flutter/widgets.dart';

/// Material Design 3 width classes, measured in logical pixels.
enum Bp {
  compact(0),
  medium(600),
  expanded(840),
  large(1200),
  extraLarge(1600);

  const Bp(this.minWidth);

  final double minWidth;

  factory Bp.fromWidth(double width) {
    if (!width.isFinite || width < 0) {
      throw ArgumentError.value(
        width,
        'width',
        'Must be finite and nonnegative',
      );
    }
    return values.lastWhere((bp) => width >= bp.minWidth);
  }

  factory Bp.fromConstraints(BoxConstraints constraints) =>
      Bp.fromWidth(constraints.maxWidth);

  factory Bp.fromMediaQuery(MediaQueryData mediaQuery) =>
      Bp.fromWidth(mediaQuery.size.width);

  static Bp of(BuildContext context) =>
      Bp.fromWidth(MediaQuery.sizeOf(context).width);

  bool isLargerThan(Bp other) => minWidth > other.minWidth;

  bool isAtLeast(Bp other) => minWidth >= other.minWidth;
}
