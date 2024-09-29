import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants.dart';

class MyTextFormFieldSmall extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
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
    this.labelText,
    this.hintText,
    this.initialValue,
    this.controller,
    this.validator,
    this.inputFormatters,
    this.readOnly = false,
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
    this.fillColor = Colors.white,
    this.maxWidth = double.infinity,
  });

  @override
  _MyTextFormFieldSmallState createState() => _MyTextFormFieldSmallState();
}

class _MyTextFormFieldSmallState extends State<MyTextFormFieldSmall> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) Text(' ${widget.labelText!}', style: TextStyles.infoOnTextFieldSmall),
        SizedBox(
          width: widget.maxWidth,
          child: TextFormField(
            controller: widget.controller,
            initialValue: widget.initialValue,
            validator: (value) => widget.validator != null ? widget.validator!(value) : null,
            style: const TextStyle(fontSize: 12).copyWith(letterSpacing: 0),
            focusNode: widget.focusNode,
            keyboardType: widget.keyboardType,
            readOnly: widget.readOnly,
            textCapitalization: widget.textCapitalization,
            maxLines: widget.maxLines,
            inputFormatters: widget.inputFormatters,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle().copyWith(color: Colors.grey, letterSpacing: 0),
              fillColor: widget.fillColor,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              isDense: true,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffix: widget.suffix,
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
