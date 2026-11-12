import 'package:material_ui/material_ui.dart';

import '../../l10n.dart';
import '../../responsive.dart';

class AccountListLayout extends StatelessWidget {
  const AccountListLayout({
    super.key,
    required this.list,
    required this.navigator,
  });

  static const _listWidth = 360.0;
  static const _horizontalPadding = 24.0;
  static const _paneSpacing = 24.0;

  final Widget list;
  final Widget navigator;

  @override
  Widget build(BuildContext context) {
    if (!Bp.of(context).isAtLeast(Bp.expanded)) return navigator;
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, _) {
          return [
            SliverAppBar(
              floating: true,
              leading: BackButton(onPressed: () => Navigator.of(context).pop()),
              title: Text(AppLocalizations.of(context).accountListTitle),
            ),
          ];
        },
        body: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
            child: Row(
              children: [
                SizedBox(width: _listWidth, child: list),
                const SizedBox(width: _paneSpacing),
                Expanded(child: navigator),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
