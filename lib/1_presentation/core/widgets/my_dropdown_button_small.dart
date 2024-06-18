import 'package:flutter/material.dart';

import '../../../constants.dart';

class MyDropdownButtonSmall extends StatelessWidget {
  final String? labelText;
  final String? value;
  final void Function(String?)? onChanged;
  final List<String> items;
  final double maxWidth;
  final AlignmentGeometry? itemsAlignment;

  const MyDropdownButtonSmall({
    super.key,
    this.labelText,
    required this.value,
    required this.onChanged,
    required this.items,
    this.maxWidth = double.infinity,
    this.itemsAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) Text(' ${labelText!}', style: TextStyles.infoOnTextFieldSmall),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 28, maxWidth: maxWidth),
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              hintStyle: const TextStyle().copyWith(letterSpacing: 0),
              fillColor: Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixStyle: const TextStyle(fontSize: 13),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Colors.red),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: CustomColors.borderColorLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: CustomColors.primaryColor),
              ),
            ),
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                alignment: itemsAlignment ?? AlignmentDirectional.centerStart,
                child: Text(value),
              );
            }).toList(),
            isExpanded: true,
            value: value,
            style: const TextStyle(fontSize: 12, color: Colors.black).copyWith(letterSpacing: 0),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
