import 'package:cloud_firestore/cloud_firestore.dart';

import 'abstract_failure.dart';

abstract class FirebaseFailure extends AbstractFailure {}

class NoFailure extends FirebaseFailure {}

class GeneralFailure extends FirebaseFailure {
  final String? customMessage;
  final FirebaseException? e;

  GeneralFailure({this.customMessage, this.e});
}

class EmptyFailure extends FirebaseFailure {}

class NoConnectionFailure extends FirebaseFailure {}
