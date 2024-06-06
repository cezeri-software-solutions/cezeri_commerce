extension ContainsDigitExtensions on String {
  bool containsDigit() {
    final regex = RegExp(r'\d');
    return regex.hasMatch(this);
  }
}
