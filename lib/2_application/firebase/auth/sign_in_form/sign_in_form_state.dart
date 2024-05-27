part of 'sign_in_form_bloc.dart';

@immutable
class SignInFormState {
  final bool isSubmitting;
  final Option<Either<AbstractFailure, Unit>> authFailureOrSuccessOptionOnRegister;
  final Option<Either<AbstractFailure, Unit>> authFailureOrSuccessOptionOnSignIn;
  final Option<Either<AbstractFailure, Unit>> authFailureOrSuccessOptionOnResetPassword;

  const SignInFormState({
    required this.isSubmitting,
    required this.authFailureOrSuccessOptionOnRegister,
    required this.authFailureOrSuccessOptionOnSignIn,
    required this.authFailureOrSuccessOptionOnResetPassword,
  });

  SignInFormState copyWith({
    bool? isSubmitting,
    Option<Either<AbstractFailure, Unit>>? authFailureOrSuccessOptionOnRegister,
    Option<Either<AbstractFailure, Unit>>? authFailureOrSuccessOptionOnSignIn,
    Option<Either<AbstractFailure, Unit>>? authFailureOrSuccessOptionOnResetPassword,
  }) {
    return SignInFormState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      authFailureOrSuccessOptionOnRegister: authFailureOrSuccessOptionOnRegister ?? this.authFailureOrSuccessOptionOnRegister,
      authFailureOrSuccessOptionOnSignIn: authFailureOrSuccessOptionOnSignIn ?? this.authFailureOrSuccessOptionOnSignIn,
      authFailureOrSuccessOptionOnResetPassword: authFailureOrSuccessOptionOnResetPassword ?? this.authFailureOrSuccessOptionOnResetPassword,
    );
  }
}
