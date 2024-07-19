import 'dart:math';

import 'package:flutter/material.dart';
import 'package:publrealty/themes/app_themes.dart';

class AppBarWithOpacityView extends StatefulWidget
    implements PreferredSizeWidget {
  const AppBarWithOpacityView(
      {Key? key, required this.title, required this.controller})
      : super(key: key);

  final String title;
  final ScrollController controller;

  @override
  State<AppBarWithOpacityView> createState() => _AppBarWithOpacityViewState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarWithOpacityViewState extends State<AppBarWithOpacityView> {
  var headerOpacity = 0.0;

  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {
        headerOpacity = min(1, max(0, widget.controller.offset / 100));
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppThemes.of(context);

    return AppBar(
      backgroundColor: theme.cardColor.withOpacity(headerOpacity),
      elevation: 0,
      iconTheme: IconThemeData(color: theme.customLabelColor),
      actionsIconTheme: IconThemeData(color: theme.primaryColor),
      title: Opacity(
        opacity: headerOpacity,
        child: Text(
          widget.title,
          style: TextStyle(color: theme.customLabelColor),
        ),
      ),
    );
  }
}
