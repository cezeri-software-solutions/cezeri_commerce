import 'abstract_failure.dart';

enum FirebaseFailureType { general, empty, noConnection }

abstract class FirebaseFailure extends AbstractFailure {
  final FirebaseFailureType firebaseFailureType;
  FirebaseFailure({required this.firebaseFailureType}) : super(abstractFailureType: AbstractFailureType.firebase);
}

class GeneralFailure extends FirebaseFailure {
  final String? customMessage;

  GeneralFailure({this.customMessage}) : super(firebaseFailureType: FirebaseFailureType.general);
}

class EmptyFailure extends FirebaseFailure {
  EmptyFailure() : super(firebaseFailureType: FirebaseFailureType.empty);
}

class NoConnectionFailure extends FirebaseFailure {
  NoConnectionFailure() : super(firebaseFailureType: FirebaseFailureType.noConnection);
}

String fFEMpartOfSetProductNotFoundByName(String partProductName, String setProductName) {
  return 'Der Einzelartikel: "$partProductName" des Set-Artikels: "$setProductName" konnte nicht in der Datenbank gefunden werden';
}

String fFEMpartOfSetProductNotFoundById(String partProductId, String setProductName) {
  return 'Der Einzelartikel mit der ID: "$partProductId" des Set-Artikels: "$setProductName" konnte nicht in der Datenbank gefunden werden';
}

String fFEMnoPartProductsFound() {
  return 'Dieser Set-Artikel hat keine Einzelartikel';
}
