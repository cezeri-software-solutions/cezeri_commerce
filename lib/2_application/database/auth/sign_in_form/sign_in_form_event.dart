part of 'sign_in_form_bloc.dart';

@immutable
abstract class SignInFormEvent {}

class RegisterWithEmailAndPasswordPressed extends SignInFormEvent {
  final String? email;
  final String? password;

  RegisterWithEmailAndPasswordPressed({required this.email, required this.password});
}

class SignInWithEmailAndPasswordPressed extends SignInFormEvent {
  final String? email;
  final String? password;

  SignInWithEmailAndPasswordPressed({required this.email, required this.password});
}

class SendPasswordResetEmailPressed extends SignInFormEvent {
  final String? email;

  SendPasswordResetEmailPressed({required this.email});
}

class ResetPasswordForEmailEvent extends SignInFormEvent {
  final String email;
  final String password;

  ResetPasswordForEmailEvent({required this.email, required this.password});
}
