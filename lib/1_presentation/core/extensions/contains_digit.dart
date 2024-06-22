//* Überprüft, ob in einem String eine Zahl vorkommt.
//* z.B. zum Überprüfen, ob eine Hausnummer im Feld Straße & Hausnummer eingegeben wurde.
extension ContainsDigitExtensions on String {
  bool containsDigit() {
    final regex = RegExp(r'\d');
    return regex.hasMatch(this);
  }
}
