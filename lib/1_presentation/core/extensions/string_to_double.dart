extension StringToDouble on String {
  double toDouble() {
    String formattedString = replaceAll(',', '.');
    return double.parse(formattedString);
  }
}
