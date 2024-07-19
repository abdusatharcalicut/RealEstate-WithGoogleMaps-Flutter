import 'package:flutter/material.dart';
import 'package:publrealty/themes/app_themes.dart';

class PublTextField extends StatelessWidget {
  const PublTextField(
      {Key? key,
      required this.controller,
      this.placeHolder,
      this.validator,
      this.focusNode,
      this.obscureText = false,})
      : super(key: key);

  final TextEditingController controller;
  final String? placeHolder;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final theme = AppThemes.of(context);

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      focusNode: focusNode,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        fillColor: theme.cardColor,
        filled: true,
        border: OutlineInputBorder(
          
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: theme.customBlackColor.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            // color: theme.customBlackColor.withOpacity(0.2),
            color:Colors.blue,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        hintText: placeHolder,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}
