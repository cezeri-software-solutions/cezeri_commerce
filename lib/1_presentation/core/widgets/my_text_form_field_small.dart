import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants.dart';

enum FieldInputType { text, integer, double, email, phone, password }

class MyTextFormFieldSmall extends StatelessWidget {
  final String? fieldTitle;
  // final String? labelText; //* Labeltext schaut bei dieser Größe nicht schön aus
  final String? hintText;
  final String? initialValue;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final FieldInputType inputType;
  final bool readOnly;
  final bool addPlaceholderForError;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final int? maxLines;
  final Widget? suffix;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final Color? fillColor;
  final double maxWidth;

  const MyTextFormFieldSmall({
    super.key,
    this.fieldTitle,
    // this.labelText,
    this.hintText,
    this.initialValue,
    this.controller,
    this.validator,
    this.inputFormatters,
    this.inputType = FieldInputType.text,
    this.readOnly = false,
    this.addPlaceholderForError = false,
    this.focusNode,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.suffix,
    this.onChanged,
    this.onTap,
    this.onTapOutside,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.fillColor,
    this.maxWidth = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (fieldTitle != null) Text(' ${fieldTitle!}', style: TextStyles.infoOnTextFieldSmall),
        SizedBox(
          width: maxWidth,
          height: addPlaceholderForError ? 55 : null,
          child: TextFormField(
            controller: controller,
            initialValue: initialValue,
            validator: (value) => validator != null ? validator!(value) : null,
            style: const TextStyle(fontSize: 13).copyWith(letterSpacing: 0),
            focusNode: focusNode,
            keyboardType: keyboardType,
            readOnly: readOnly,
            textCapitalization: textCapitalization,
            maxLines: maxLines,
            inputFormatters: inputFormatters ??
                switch (inputType) {
                  FieldInputType.integer => [IntegerInputFormatter()],
                  FieldInputType.double => [DoubleInputFormatter()],
                  _ => null,
                },
            onChanged: onChanged,
            onTap: onTap,
            decoration: InputDecoration(
              // labelText: labelText,
              // labelStyle: const TextStyle().copyWith(letterSpacing: 0),
              hintText: hintText,
              hintStyle: const TextStyle().copyWith(color: readOnly ? null : Colors.grey, letterSpacing: 0),
              fillColor: fillColor ?? (readOnly ? Colors.grey[50] : Colors.white),
              filled: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              isDense: true,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffix: suffix,
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
          ),
        ),
      ],
    );
  }
}
