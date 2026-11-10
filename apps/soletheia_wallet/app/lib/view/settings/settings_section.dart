import 'package:material_ui/material_ui.dart';

class SettingsSection extends StatelessWidget {
  static const double _outerRadius = 16;
  static const double _innerRadius = 4;
  static const double _tileSpacing = 2;
  static const double _headingInset = 16;
  static const double _headingSpacing = 8;

  const SettingsSection({super.key, required this.title, required this.tiles});

  final String title;
  final List<ListTile> tiles;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(
            start: _headingInset,
            bottom: _headingSpacing,
          ),
          child: Semantics(
            header: true,
            child: Text(title, style: theme.textTheme.titleSmall),
          ),
        ),
        Column(
          spacing: _tileSpacing,
          children: [
            for (final (index, tile) in tiles.indexed)
              Material(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                    index == 0 ? _outerRadius : _innerRadius,
                  ),
                  bottom: Radius.circular(
                    index == tiles.length - 1 ? _outerRadius : _innerRadius,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: tile,
              ),
          ],
        ),
      ],
    );
  }
}
