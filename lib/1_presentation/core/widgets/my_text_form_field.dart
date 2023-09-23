import 'package:flutter/material.dart';

import '../../../constants.dart';

class MyTextFormField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;
  final int maxLines;

  const MyTextFormField({
    super.key,
    required this.labelText,
    this.hintText,
    this.controller,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: const TextStyle().copyWith(letterSpacing: 0),
      textCapitalization: textCapitalization,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle().copyWith(letterSpacing: 0),
        hintText: hintText,
        hintStyle: const TextStyle().copyWith(letterSpacing: 0),
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.red),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: CustomColors.borderColorLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: CustomColors.primaryColor),
        ),
      ),
    );
  }
}
