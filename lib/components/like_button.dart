import 'package:flutter/material.dart';
import 'package:publrealty/themes/app_themes.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({
    Key? key,
    required this.isLiked,
    required this.onTap,
  }) : super(key: key);

  final bool isLiked;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AppThemes.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 6, right: 6, top: 7, bottom: 5),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(100),
          boxShadow: const [
            BoxShadow(
                blurStyle: BlurStyle.normal,
                offset: Offset(0, 2),
                blurRadius: 2,
                color: Color(0x20000000))
          ],
        ),
        child: Icon(
          isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          size: 23,
          color: isLiked ? theme.customRedColor : theme.disabledColor,
        ),
      ),
    );
  }
}
