import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soletheia/responsive.dart';

void main() {
  test('classifies widths at and between boundaries', () {
    final cases = <double, Bp>{
      0: Bp.compact,
      599.9: Bp.compact,
      600: Bp.medium,
      839.9: Bp.medium,
      840: Bp.expanded,
      1199.9: Bp.expanded,
      1200: Bp.large,
      1599.9: Bp.large,
      1600: Bp.extraLarge,
      4000: Bp.extraLarge,
    };
    for (final entry in cases.entries) {
      expect(Bp.fromWidth(entry.key), entry.value);
    }
  });

  test('rejects invalid widths and unbounded constraints', () {
    for (final width in [-1.0, double.nan, double.infinity]) {
      expect(() => Bp.fromWidth(width), throwsArgumentError);
    }
    expect(
      () => Bp.fromConstraints(const BoxConstraints()),
      throwsArgumentError,
    );
  });

  test('uses the maximum constraint width and MediaQuery width', () {
    expect(
      Bp.fromConstraints(const BoxConstraints(minWidth: 300, maxWidth: 1200)),
      Bp.large,
    );
    expect(
      Bp.fromMediaQuery(const MediaQueryData(size: Size(840, 400))),
      Bp.expanded,
    );
  });

  test('compares classes with and without equality', () {
    expect(Bp.expanded.isLargerThan(Bp.medium), isTrue);
    expect(Bp.medium.isLargerThan(Bp.medium), isFalse);
    expect(Bp.compact.isLargerThan(Bp.medium), isFalse);
    expect(Bp.expanded.isAtLeast(Bp.medium), isTrue);
    expect(Bp.medium.isAtLeast(Bp.medium), isTrue);
    expect(Bp.compact.isAtLeast(Bp.medium), isFalse);
  });

  testWidgets('of follows changes to the available logical width', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 2;
    tester.view.physicalSize = const Size(1200, 1600);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    late Bp current;
    await tester.pumpWidget(
      MediaQuery.fromView(
        view: tester.view,
        child: Builder(
          builder: (context) {
            current = Bp.of(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(current, Bp.medium);

    tester.view.physicalSize = const Size(3200, 1600);
    await tester.pump();
    expect(current, Bp.extraLarge);
  });
}
