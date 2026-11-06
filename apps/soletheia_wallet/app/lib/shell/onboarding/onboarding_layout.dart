import 'package:material_ui/material_ui.dart';

class OnboardingLayout extends StatelessWidget {
  static const double _maxContentWidth = 560;
  static const double _contentPadding = 24;

  const OnboardingLayout({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxContentWidth),
          child: Padding(
            padding: const EdgeInsets.all(_contentPadding),
            child: child,
          ),
        ),
      ),
    ),
  );
}
