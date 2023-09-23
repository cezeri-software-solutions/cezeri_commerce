import 'package:uuid/uuid.dart';

class UniqueID {
  const UniqueID._(this.value);
  final String value;

  // Das Projekt kann sich selber eine UniqueID erstellen
  factory UniqueID() {
    return UniqueID._(const Uuid().v1());
  }

  // Oder die UniqueID kommt von außen z.B. Firebase
  factory UniqueID.fromUniqueString(String uniqueID) {
    return UniqueID._(uniqueID);
  }
}
