import 'package:email_validator/email_validator.dart';

String? validateEmail(String? email) {
  if (email != null && !EmailValidator.validate(email)) {
    return 'Gültige E-Mail eingeben';
  } else {
    return null;
  }
}

String? validatePassword(String? password) {
  if (password != null && password.length < 7) {
    return 'Passwort zu kurz';
  } else {
    return null;
  }
}

String? validateGeneralMin3(String? input) {
  if (input != null && input.length < 3) {
    return 'Mindestens 3 Zeichen';
  } else {
    return null;
  }
}

String? validateVehicleBrand(String? input) {
  if (input != null && input.length < 2) {
    return 'Pflichtfeld';
  } else {
    return null;
  }
}

String? validateGeneralNumber(String? input) {
  if (input != null && input.isEmpty) {
    return 'Pflichtfeld';
  } else {
    return null;
  }
}

String? validateGeneralMin2(String? input) {
  if (input != null && input.length < 2) {
    return 'Mindesten 2 Zeichen';
  } else {
    return null;
  }
}
