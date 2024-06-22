import 'dart:math' as math;

//* Kaufmännische Rundung auf 2 Nachkommastellen
extension ToMyCurrencyString on double? {
  String toMyCurrencyString([int? int]) {
    if (this == null) {
      return "0,00";
    }
    double value = this!;
    double roundedValue = (value * (int == null ? 100 : math.pow(10, int))).round() / (int == null ? 100 : math.pow(10, int));
    return roundedValue.toStringAsFixed(int ?? 2).replaceAll('.', ',');
  }
}

//* Dient nur zur schöneren Darstellung.
//* Nicht so abspeichern
extension ToMyCurrencyStringToShow on double {
  String toMyCurrencyStringToShow([int? int]) {
    double roundedValue = (this * (int == null ? 100 : math.pow(10, int))).round() / (int == null ? 100 : math.pow(10, int));
    return roundedValue.toStringAsFixed(int ?? 2).replaceAll('.', ',').replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        );
  }
}

extension ToMyXmlString on double? {
  String toMyXmlString([int? int]) {
    if (this == null) {
      return "0.00";
    }
    double value = this!;
    double roundedValue = (value * (int == null ? 100 : math.pow(10, int))).round() / (int == null ? 100 : math.pow(10, int));
    return roundedValue.toStringAsFixed(int ?? 2).replaceAll(',', '.');
  }
}

//* Kaufmännische Rundung auf 2 Nachkommastellen
extension ToMyDouble on String? {
  double toMyDouble() {
    if (this == null || this!.isEmpty) {
      return 0.0;
    }

    // Ersetzt Kommas durch Punkte und entfernt Tausendertrennzeichen
    String normalizedString = this!.replaceAll(',', '.');

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

//* Kaufmännische Rundung auf 2 Nachkommastellen
extension ToMyRoundedDouble on double {
  double toMyRoundedDouble() {
    // Rundet das double kaufmännisch auf zwei Dezimalstellen
    return (this * 100).roundToDouble() / 100;
  }
}
