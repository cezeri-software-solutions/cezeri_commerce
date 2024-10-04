import 'package:flutter/services.dart';

class IntegerInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final RegExp regExp = RegExp(r'^-?\d+$');
    if (regExp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}
