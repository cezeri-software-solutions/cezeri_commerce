import 'abstract_failure.dart';

enum AuthFailureType { wrongEmailOrPassword, emailNotConfirmed, authServer }

abstract class AuthFailure extends AbstractFailure {
  final AuthFailureType authFailureType;

  AuthFailure({required this.authFailureType}) : super(abstractFailureType: AbstractFailureType.auth);
}

// ############### SignIn Failures #################

class WrongEmailOrPasswordFailure extends AuthFailure {
  WrongEmailOrPasswordFailure() : super(authFailureType: AuthFailureType.wrongEmailOrPassword);
}

class EmailNotConfirmedFailure extends AuthFailure {
  EmailNotConfirmedFailure() : super(authFailureType: AuthFailureType.emailNotConfirmed);
}
class AuthServerFailure extends AuthFailure {
  AuthServerFailure() : super(authFailureType: AuthFailureType.authServer);
}
