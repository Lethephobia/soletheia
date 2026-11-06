import 'package:material_ui/material_ui.dart';

import 'onboarding_layout.dart';

class OnboardingShell extends StatelessWidget {
  const OnboardingShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => OnboardingLayout(child: child);
}
