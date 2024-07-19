import 'package:flutter/material.dart';
import 'package:publrealty/themes/app_themes.dart';

class PublAppBar extends AppBar {
  PublAppBar({required title, required ThemeData theme})
      : super(
          title: Text(
            title,
            style: TextStyle(color: theme.customLabelColor),
          ),
          elevation: 0.3,
          actionsIconTheme: IconThemeData(color: theme.customLabelColor),
          iconTheme: IconThemeData(color: theme.customLabelColor),
          backgroundColor: theme.cardColor,
        );
}
