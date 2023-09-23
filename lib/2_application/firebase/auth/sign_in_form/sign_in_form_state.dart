part of 'sign_in_form_bloc.dart';

@immutable
class SignInFormState {
  final bool isSubmitting;
  final Option<Either<AuthFailure, Unit>> authFailureOrSuccessOption;

  const SignInFormState({required this.isSubmitting, required this.authFailureOrSuccessOption});

  SignInFormState copyWith({
    bool? isSubmitting,
    Option<Either<AuthFailure, Unit>>? authFailureOrSuccessOption,
  }) {
    return SignInFormState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      authFailureOrSuccessOption: authFailureOrSuccessOption ?? this.authFailureOrSuccessOption,
    );
  }
}
