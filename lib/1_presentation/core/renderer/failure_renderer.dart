import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../core/abstract_failure.dart';
import '../../../core/auth_failures.dart';
import '../../../core/firebase_failures.dart';
import '../../../core/presta_failure.dart';
import '../functions/dialogs.dart';

final logger = Logger();

Future<void> failureRenderer(BuildContext context, List<AbstractFailure> abstractFailures) async {
  for (final failure in abstractFailures) {
    switch (failure.abstractFailureType) {
      case AbstractFailureType.auth:
        await _authFailureRenderer(context, failure as AuthFailure);
      case AbstractFailureType.firebase:
        await _firebaseFailureRenderer(context, failure as FirebaseFailure);
      case AbstractFailureType.presta:
        await _prestaFailureRenderer(context, failure as PrestaFailure);
      case AbstractFailureType.mixed:
        await _mixedFailureRenderer(context, failure as MixedFailure);
    }
  }
}

Future<void> _authFailureRenderer(BuildContext context, AuthFailure failure) async {
  await _showScaffoldMessager(context, _mapAuthFailureMessage(failure));
}

Future<void> _firebaseFailureRenderer(BuildContext context, FirebaseFailure failure) async {
  switch (failure.firebaseFailureType) {
    case FirebaseFailureType.general:
      await _firebaseGeneralFailureRenderer(context, failure as GeneralFailure);
    case FirebaseFailureType.empty:
      //TODO:
    case FirebaseFailureType.noConnection:
      await _showScaffoldMessager(context, 'Es konnte keine Verbindung zum Internet hergestellt werden.\nBitte Internetverbindung überprüfen.');
  }
}

Future<void> _firebaseGeneralFailureRenderer(BuildContext context, GeneralFailure failure) async {
  final customMessage = failure.customMessage ?? '';
  final technicalMessage = failure.e ?? '';
  await showMyDialogAlert(context: context, title: 'Ein Fehler ist aufgetreten', content: '$customMessage\n\n$technicalMessage');
}

Future<void> _prestaFailureRenderer(BuildContext context, PrestaFailure failure) async {}
Future<void> _mixedFailureRenderer(BuildContext context, MixedFailure failure) async {}

Future<void> _showScaffoldMessager(BuildContext context, String message) async {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: Colors.red,
    duration: const Duration(days: 1),
    action: SnackBarAction(label: 'x', textColor: Colors.white, onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
  ));
}

String _mapAuthFailureMessage(AuthFailure failure) {
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
