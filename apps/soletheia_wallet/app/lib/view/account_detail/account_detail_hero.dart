import 'package:material_ui/material_ui.dart';

import '../../responsive.dart';

class AccountDetailHero extends StatelessWidget {
  const AccountDetailHero({
    super.key,
    required this.address,
    required this.child,
    this.tileRadius = BorderRadius.zero,
  });

  final String address;
  final Widget child;
  final BorderRadius tileRadius;

  @override
  Widget build(BuildContext context) {
    if (Bp.of(context).isAtLeast(Bp.expanded) ||
        MediaQuery.disableAnimationsOf(context)) {
      return child;
    }
    return Hero(
      tag: (AccountDetailHero, address),
      flightShuttleBuilder: _buildFlight,
      transitionOnUserGestures: true,
      child: child,
    );
  }

  static Widget _buildFlight(
    BuildContext context,
    Animation<double> animation,
    HeroFlightDirection direction,
    BuildContext from,
    BuildContext to,
  ) {
    final opening = direction == HeroFlightDirection.push;
    final tile = opening ? from : to;
    final detail = opening ? to : from;
    final radius = tile
        .findAncestorWidgetOfExactType<AccountDetailHero>()!
        .tileRadius;
    final color = Theme.of(context).colorScheme.surfaceContainer;

    Widget layer(BuildContext endpoint, Animation<double> opacity) {
      final isDetail = endpoint == detail;
      final screen = MediaQuery.sizeOf(context);
      return FadeTransition(
        opacity: opacity,
        child: OverflowBox(
          alignment: Alignment.topLeft,
          minWidth: isDetail ? screen.width : null,
          maxWidth: isDetail ? screen.width : null,
          minHeight: isDetail ? screen.height : 0,
          maxHeight: isDetail ? screen.height : double.infinity,
          child: (endpoint.widget as Hero).child,
        ),
      );
    }

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Material(
          color: color,
          borderRadius: BorderRadius.lerp(
            radius,
            BorderRadius.zero,
            animation.value,
          ),
          clipBehavior: Clip.antiAlias,
          child: child,
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          layer(
            tile,
            ReverseAnimation(
              animation.drive(CurveTween(curve: const Interval(0, 0.4))),
            ),
          ),
          layer(
            detail,
            animation.drive(CurveTween(curve: const Interval(0.4, 1))),
          ),
        ],
      ),
    );
  }
}
