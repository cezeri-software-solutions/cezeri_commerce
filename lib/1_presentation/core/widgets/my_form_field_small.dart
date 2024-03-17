import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants.dart';

// class MyTextFormFieldSmall extends StatelessWidget {
//   final String? labelText;
//   final String? hintText;
//   final TextEditingController? controller;
//   final String? Function(String?)? validator;
//   final List<TextInputFormatter>? inputFormatters;
//   final bool readOnly;
//   final FocusNode? focusNode;
//   final TextInputType? keyboardType;
//   final TextCapitalization textCapitalization;
//   final int maxLines;
//   final Widget? suffix;
//   final void Function(String)? onChanged;
//   final void Function()? onTap;
//   final void Function(PointerDownEvent)? onTapOutside;
//   final void Function()? onEditingComplete;
//   final void Function(String)? onFieldSubmitted;
//   final double maxWidth;

//   const MyTextFormFieldSmall({
//     super.key,
//     this.labelText,
//     this.hintText,
//     this.controller,
//     this.validator,
//     this.inputFormatters,
//     this.focusNode,
//     this.keyboardType,
//     this.readOnly = false,
//     this.textCapitalization = TextCapitalization.none,
//     this.maxLines = 1,
//     this.suffix,
//     this.onChanged,
//     this.onTap,
//     this.onTapOutside,
//     this.onEditingComplete,
//     this.onFieldSubmitted,
//     this.maxWidth = double.infinity,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final errorText = validator != null ? validator!() : null;
//     final maxHeight = errorText != null ? 48 : 28;
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (labelText != null) Text(' ${labelText!}', style: TextStyles.infoOnTextFieldSmall),
//         ConstrainedBox(
//           constraints: BoxConstraints(maxHeight: 28, maxWidth: maxWidth),
//           child: TextFormField(
//             controller: controller,
//             validator: validator,
//             style: const TextStyle(fontSize: 12).copyWith(letterSpacing: 0),
//             focusNode: focusNode,
//             keyboardType: keyboardType,
//             readOnly: readOnly,
//             textCapitalization: textCapitalization,
//             maxLines: maxLines,
//             inputFormatters: inputFormatters,
//             onChanged: onChanged,
//             onTap: onTap,
//             onTapOutside: onTapOutside,
//             onEditingComplete: onEditingComplete,
//             onFieldSubmitted: onFieldSubmitted,
//             decoration: InputDecoration(
//               hintText: hintText,
//               hintStyle: const TextStyle().copyWith(letterSpacing: 0),
//               fillColor: Colors.white,
//               filled: true,
//               contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
//               floatingLabelBehavior: FloatingLabelBehavior.always,
//               suffix: suffix,
//               suffixStyle: const TextStyle(fontSize: 13),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: const BorderSide(color: Colors.red),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: const BorderSide(color: CustomColors.borderColorLight),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: const BorderSide(color: CustomColors.primaryColor),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class MyTextFormFieldSmall extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final Widget? suffix;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final double maxWidth;

  const MyTextFormFieldSmall({
    Key? key,
    this.labelText,
    this.hintText,
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
    this.maxWidth = double.infinity,
  }) : super(key: key);

  @override
  _MyTextFormFieldSmallState createState() => _MyTextFormFieldSmallState();
}

class _MyTextFormFieldSmallState extends State<MyTextFormFieldSmall> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    // Dynamische Anpassung der maxHeight basierend auf dem Fehlerzustand
    final double maxHeight = _hasError ? 52 : 28;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) Text(' ${widget.labelText!}', style: TextStyles.infoOnTextFieldSmall),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight, maxWidth: widget.maxWidth),
          child: TextFormField(
            controller: widget.controller,
            validator: (value) {
              final error = widget.validator != null ? widget.validator!(value) : null;
              // Zustandsaktualisierung, um die Höhe dynamisch anzupassen
              WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => _hasError = error != null));
              return error;
            },
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
              hintStyle: const TextStyle().copyWith(letterSpacing: 0),
              fillColor: Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffix: widget.suffix,
              suffixStyle: const TextStyle(fontSize: 13),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Colors.red),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: CustomColors.borderColorLight), // Anpassen
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: CustomColors.primaryColor), // Anpassen
              ),
            ),
          ),
        ),
        // if (_hasError) const Text('Error'),
        // Fehlermeldung kann hier angezeigt werden, falls erforderlich
      ],
    );
  }
}
