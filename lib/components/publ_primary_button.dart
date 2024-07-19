import 'package:flutter/material.dart';

class PublPrimaryButton extends StatelessWidget {
  const PublPrimaryButton({
    Key? key,
    required this.onPressed,
    this.title = "",
    this.minHeight = 0.0,
  }) : super(key: key);

  final double minHeight;
  final VoidCallback? onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: Size(0, minHeight),
          textStyle:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      child: Text(title),
    );
  }
}
