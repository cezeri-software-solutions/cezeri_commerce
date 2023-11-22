import 'abstract_failure.dart';

abstract class FirebaseFailure extends AbstractFailure {}

class NoFailure extends FirebaseFailure {}

class GeneralFailure extends FirebaseFailure {}

class EmptyFailure extends FirebaseFailure {}

class NoConnectionFailure extends FirebaseFailure {}
