//* Wandelt einen String in ein double um.
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

//* Wandelt einen String in ein int um.
extension ToMyInt on String? {
  int toMyInt() {
    if (this == null || this!.isEmpty) {
      return 0;
    }

    // Ersetzt Kommas durch Punkte und entfernt Tausendertrennzeichen
    String normalizedString = this!.replaceAll(',', '.').replaceAll(RegExp(r'\s'), '');

    // Versucht, den String in ein int umzuwandeln
    int? value = int.tryParse(normalizedString.split('.')[0]);

    if (value != null) {
      // Gibt das int zurück, wenn der String erfolgreich umgewandelt werden kann
      return value;
    } else {
      // Gibt 0 zurück, wenn der String nicht in ein int umgewandelt werden kann
      return 0;
    }
  }
}
