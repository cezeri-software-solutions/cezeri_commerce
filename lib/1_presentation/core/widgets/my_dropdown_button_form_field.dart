import 'package:flutter/material.dart';

import '../../../constants.dart';

class MyDropdownButtonFormField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final String? value;
   final double? menuMaxHeight;
  final void Function(String?)? onChanged;
  final List<String> items;

  const MyDropdownButtonFormField({
    super.key,
    required this.labelText,
    this.hintText,
    this.menuMaxHeight,
    required this.value,
    required this.onChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      menuMaxHeight: menuMaxHeight,
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
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      value: value,
      onChanged: onChanged,
    );
  }
}
