import 'abstract_failure.dart';

enum AuthFailureType { wrongPassword, userDisabled, invalidEmail, emailAlreadyInUse, weakPassword, emailNotFound, authServer }

abstract class AuthFailure extends AbstractFailure {
  final AuthFailureType authFailureType;

  AuthFailure({required this.authFailureType}) : super(abstractFailureType: AbstractFailureType.auth);
}

// ############### SignIn Failures #################

class WrongPasswordFailure extends AuthFailure {
  WrongPasswordFailure() : super(authFailureType: AuthFailureType.wrongPassword);
}

class UserDisabledFailure extends AuthFailure {
  UserDisabledFailure() : super(authFailureType: AuthFailureType.userDisabled);
}

class InvalidEmailFailure extends AuthFailure {
  InvalidEmailFailure() : super(authFailureType: AuthFailureType.invalidEmail);
}

// ############### Register Failures #################

class EmailAlreadyInUseFailure extends AuthFailure {
  EmailAlreadyInUseFailure() : super(authFailureType: AuthFailureType.emailAlreadyInUse);
}

class WeakPasswordFailure extends AuthFailure {
  WeakPasswordFailure() : super(authFailureType: AuthFailureType.weakPassword);
}

// ############### SignIn & Register Failures #################

class EmailNotFoundFailure extends AuthFailure {
  EmailNotFoundFailure() : super(authFailureType: AuthFailureType.emailNotFound);
}

class AuthServerFailure extends AuthFailure {
  AuthServerFailure() : super(authFailureType: AuthFailureType.authServer);
}
