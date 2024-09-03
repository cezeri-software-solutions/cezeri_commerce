import 'package:flutter/material.dart';

import '../../../failures/abstract_failure.dart';
import '../../../failures/auth_failures.dart';
import '../../../failures/firebase_failures.dart';
import '../../../failures/presta_failure.dart';
import '../../../failures/shopify_failure.dart';
import '../functions/dialogs.dart';

Future<void> failureRenderer(BuildContext context, List<AbstractFailure> abstractFailures) async {
  if (abstractFailures.isEmpty) return;
  for (final failure in abstractFailures) {
    switch (failure.abstractFailureType) {
      case AbstractFailureType.auth:
        _authFailureRenderer(context, failure as AuthFailure);
      case AbstractFailureType.firebase:
        _firebaseFailureRenderer(context, failure as FirebaseFailure);
      case AbstractFailureType.presta:
        _prestaFailureRenderer(context, failure as PrestaFailure);
      case AbstractFailureType.mixed:
        _mixedFailureRenderer(context, failure as MixedFailure);
      case AbstractFailureType.shopify:
        _shopifyFailureRenderer(context, failure as ShopifyFailure);
    }
  }
}

Future<void> _authFailureRenderer(BuildContext context, AuthFailure failure) async {
  if (failure is EmailNotConfirmedFailure) {
    showMyDialogAlert(
      context: context,
      title: 'Achtung!',
      content: 'Verifiziere bitte deine E-Mail, indem du auf den Link in deiner E-Mail klickst, den du von uns erhalten hast.',
    );
  } else {
    _showScaffoldMessager(context, _mapAuthFailureMessage(failure));
  }
}

Future<void> _firebaseFailureRenderer(BuildContext context, FirebaseFailure failure) async {
  switch (failure.firebaseFailureType) {
    case FirebaseFailureType.general:
      _firebaseGeneralFailureRenderer(context, failure as GeneralFailure);
    case FirebaseFailureType.empty:
    //TODO:
    case FirebaseFailureType.noConnection:
      _showScaffoldMessager(context, 'Es konnte keine Verbindung zum Internet hergestellt werden.\nBitte Internetverbindung überprüfen.');
  }
}

Future<void> _firebaseGeneralFailureRenderer(BuildContext context, GeneralFailure failure) async {
  final customMessage = failure.customMessage ?? '';
  final technicalMessage = failure;
  showMyDialogAlert(context: context, title: 'Ein Fehler ist aufgetreten', content: '$customMessage\n\n$technicalMessage');
}

Future<void> _prestaFailureRenderer(BuildContext context, PrestaFailure failure) async {}
Future<void> _mixedFailureRenderer(BuildContext context, MixedFailure failure) async {
  _showScaffoldMessager(context, failure.errorMessage ?? 'Ein Fehler ist aufgetreten.');
}

Future<void> _shopifyFailureRenderer(BuildContext context, ShopifyFailure failure) async {}

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
    AuthServerFailure => 'Ein unerwarteter Fehler ist aufgetreten.\nKontaktiere den Kundendienst.',
    WrongEmailOrPasswordFailure => 'Du hast entweder eine falsche E-Mail oder ein falsches Passwort eingegeben.',
    EmailNotConfirmedFailure => 'Verifiziere bitte deine E-Mail, indem du auf den Link in deiner E-Mail klickst, den du von uns erhalten hast',
    (_) => 'Ein unerwarteter Fehler ist aufgetreten.\nKontaktiere den Kundendienst.',
  };
}
