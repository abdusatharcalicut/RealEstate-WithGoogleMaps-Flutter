import 'package:flutter/material.dart';
import 'package:publrealty/themes/app_themes.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    Key? key,
    required this.title,
    this.paddingVertical = 8.0,
    this.paddingHorizontal = 16.0,
    this.rightTitle,
    this.rightAction,
  }) : super(key: key);

  final String title;
  final double paddingVertical;
  final double paddingHorizontal;
  final String? rightTitle;
  final Function? rightAction;

  @override
  Widget build(BuildContext context) {
    final theme = AppThemes.of(context);

    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontal,
            vertical: paddingVertical,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: theme.customLabelColor,
            ),
          ),
        ),
        const Spacer(),
        if (rightTitle != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: InkWell(
              onTap: () {
                rightAction?.call();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                child: Text(
                  rightTitle ?? "",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.primaryColorDark,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
