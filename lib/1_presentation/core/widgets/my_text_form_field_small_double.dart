// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import '../../../constants.dart';
// import '../input_formatters/double_input_formatter.dart';

// class MyTextFormFieldSmallDouble extends StatelessWidget {
//   final String? fieldTitle;
//   final String? labelText;
//   final String? hintText;
//   final TextEditingController? controller;
//   final String? Function(String?)? validator;
//   final List<TextInputFormatter>? inputFormatters;
//   final bool readOnly;
//   final FocusNode? focusNode;
//   final TextCapitalization textCapitalization;
//   final int maxLines;
//   final Widget? suffix;
//   final void Function(String)? onChanged;
//   final void Function()? onTap;
//   final void Function(PointerDownEvent)? onTapOutside;
//   final void Function()? onEditingComplete;
//   final void Function(String)? onFieldSubmitted;
//   final double maxWidth;
//   final Color? fillColor;

//   const MyTextFormFieldSmallDouble({
//     super.key,
//     this.fieldTitle,
//     this.labelText,
//     this.hintText,
//     this.controller,
//     this.validator,
//     this.inputFormatters,
//     this.focusNode,
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
//     this.fillColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final fillColor = this.fillColor ?? Colors.white;

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (fieldTitle != null) Text(' ${fieldTitle!}', style: TextStyles.infoOnTextFieldSmall),
//         ConstrainedBox(
//           constraints: BoxConstraints(maxHeight: 28, maxWidth: maxWidth),
//           child: TextFormField(
//             controller: controller,
//             validator: validator,
//             style: const TextStyle(fontSize: 14).copyWith(letterSpacing: 0),
//             focusNode: focusNode,
//             readOnly: readOnly,
//             textCapitalization: textCapitalization,
//             maxLines: maxLines,
//             inputFormatters: inputFormatters ?? [DoubleInputFormatter()],
//             onChanged: onChanged,
//             onTap: onTap,
//             onTapOutside: onTapOutside,
//             onEditingComplete: onEditingComplete,
//             onFieldSubmitted: onFieldSubmitted,
//             decoration: InputDecoration(
//               labelText: labelText,
//               labelStyle: const TextStyle().copyWith(letterSpacing: 0),
//               hintText: hintText,
//               hintStyle: const TextStyle().copyWith(letterSpacing: 0),
//               fillColor: fillColor,
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
