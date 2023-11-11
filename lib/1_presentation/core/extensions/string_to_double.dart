extension StringToDouble on String {
  double toDouble() {
    // Ersetzt Kommas durch Punkte und entfernt Tausendertrennzeichen
    String normalizedString = replaceAll(',', '.');

    // Versucht, den String in ein double umzuwandeln
    double? value = double.tryParse(normalizedString);

    if (value != null) {
      // Rundet das double kaufmännisch auf zwei Dezimalstellen
      return (value * 100).round() / 100;
    } else {
      // Gibt 0.0 zurück, wenn der String nicht in ein double umgewandelt werden kann
      return 0.0;
    }
  }
}
