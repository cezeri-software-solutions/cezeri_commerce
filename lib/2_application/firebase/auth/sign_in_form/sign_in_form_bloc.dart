import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../3_domain/repositories/firebase/auth_repository.dart';
import '../../../../failures/abstract_failure.dart';

part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';

class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final AuthRepository authRepository;

  SignInFormBloc({required this.authRepository})
      : super(SignInFormState(
          isSubmitting: false,
          authFailureOrSuccessOptionOnRegister: none(),
          authFailureOrSuccessOptionOnSignIn: none(),
          authFailureOrSuccessOptionOnResetPassword: none(),
        )) {
    on<RegisterWithEmailAndPasswordPressed>((event, emit) async {
      emit(state.copyWith(isSubmitting: true));

      print('geldii');

      final failureOrSuccess = await authRepository.registerWithEmailAndPassword(email: event.email!, password: event.password!);

      emit(state.copyWith(
        isSubmitting: false,
        authFailureOrSuccessOptionOnRegister: optionOf(failureOrSuccess),
      ));
    });

    on<SignInWithEmailAndPasswordPressed>((event, emit) async {
      emit(state.copyWith(isSubmitting: true));

      final failureOrSuccess = await authRepository.signInWithEmailAndPassword(email: event.email!, password: event.password!);

      emit(state.copyWith(
        isSubmitting: false,
        authFailureOrSuccessOptionOnSignIn: optionOf(failureOrSuccess),
      ));
    });

    on<SendPasswordResetEmailPressed>((event, emit) async {
      emit(state.copyWith(isSubmitting: true));

      final failureOrSuccess = await authRepository.sendPasswordResetEmail(email: event.email!);

      emit(state.copyWith(
        isSubmitting: false,
        authFailureOrSuccessOptionOnResetPassword: optionOf(failureOrSuccess),
      ));
    });
  }
}
