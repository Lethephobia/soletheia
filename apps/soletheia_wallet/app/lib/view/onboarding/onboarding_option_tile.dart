import 'package:material_ui/material_ui.dart';

class OnboardingOptionTile extends StatelessWidget {
  static const double _outerCornerRadius = 16;
  static const double _innerCornerRadius = 4;

  const OnboardingOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainer,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(isFirst ? _outerCornerRadius : _innerCornerRadius),
        bottom: Radius.circular(
          isLast ? _outerCornerRadius : _innerCornerRadius,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        enabled: onTap != null,
        onTap: onTap,
      ),
    );
  }
}
