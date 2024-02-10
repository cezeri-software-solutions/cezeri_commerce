import 'package:flutter/material.dart';

import '../../../core/auth_failures.dart';
import '../../../core/firebase_failures.dart';

// void myScaffoldMessengerOld(
//   BuildContext context,
//   FirebaseFailure? firebaseFailure,
//   AuthFailure? authFailure,
//   String? successMessage,
//   String? failureMessage,
// ) {
//   if (authFailure != null && firebaseFailure == null && successMessage == null) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(mapAuthFailureMessage(authFailure)),
//         backgroundColor: Colors.redAccent,
//       ),
//     );
//   }
//   if (firebaseFailure != null && authFailure == null && successMessage == null) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(mapFirebaseFailureMessage(firebaseFailure)),
//         backgroundColor: Colors.redAccent,
//       ),
//     );
//   }
//   if (successMessage != null && authFailure == null && firebaseFailure == null) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(successMessage, style: const TextStyle(fontWeight: FontWeight.bold)),
//       backgroundColor: Colors.green,
//       duration: const Duration(milliseconds: 500),
//     ));
//   }
// }

void myScaffoldMessenger(
  BuildContext context,
  FirebaseFailure? firebaseFailure,
  AuthFailure? authFailure,
  String? successMessage,
  String? failureMessage,
) {
  String? message;
  Color? bgColor;
  Duration duration = const Duration(days: 1); // Default duration

  if (authFailure != null) {
    message = mapAuthFailureMessage(authFailure);
    bgColor = Colors.redAccent;
  } else if (firebaseFailure != null) {
    message = mapFirebaseFailureMessage(firebaseFailure);
    bgColor = Colors.redAccent;
  } else if (successMessage != null) {
    message = successMessage;
    bgColor = Colors.green;
    duration = const Duration(seconds: 2);
  } else if (failureMessage != null) {
    message = failureMessage;
    bgColor = Colors.redAccent;
  }

  if (message != null && bgColor != null) {
    final isFailure = authFailure != null || firebaseFailure != null || failureMessage != null;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: bgColor == Colors.green ? const TextStyle(fontWeight: FontWeight.bold) : null),
        backgroundColor: bgColor,
        duration: duration,
        action: isFailure
            ? SnackBarAction(label: 'x', textColor: Colors.white, onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar())
            : null,
      ),
    );
  }
}

String mapAuthFailureMessage(AuthFailure failure) {
  return switch (failure.runtimeType) {
    AuthServerFailure => 'Etwas ist schifgelaufen',
    WrongPasswordFailure => 'Sie haben ein falsches Passwort eingegeben',
    UserDisabledFailure => 'Dieser User wurde deaktiviert\nBitte melden Sie sich beim Support',
    InvalidEmailFailure => 'Bitte geben Sie eine valide E-Mail Adresse ein',
    EmailAlreadyInUseFailure => 'Diese E-Mail ist bereits registriert',
    WeakPasswordFailure => 'Bitte geben Sie ein sichereres Passwort ein',
    EmailNotFoundFailure => 'Diese E-Mail konnte nicht gefunden werden',
    (_) => 'Etwas ist schifgelaufen',
  };
}

String mapFirebaseFailureMessage(FirebaseFailure failure) {
  return switch (failure.runtimeType) {
    GeneralFailure => 'Etwas ist schiefgelaufen GeneralFailure',
    EmptyFailure => 'Kein Passendes Dokument in der Datenbank',
    (_) => 'Etwas ist schifgelaufen default',
  };
}
