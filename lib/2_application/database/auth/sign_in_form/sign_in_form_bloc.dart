import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/1_presentation/core/core.dart';
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

      final failureOrSuccess = await authRepository.registerWithEmailAndPassword(email: event.email!, password: event.password!);

      emit(state.copyWith(
        isSubmitting: false,
        authFailureOrSuccessOptionOnRegister: optionOf(failureOrSuccess),
      ));
    });

    on<SignInWithEmailAndPasswordPressed>((event, emit) async {
      emit(state.copyWith(isSubmitting: true));
      print('###### SignInWithEmailAndPasswordPressed 1 #######');

      final fos = await authRepository.signInWithEmailAndPassword(email: event.email!, password: event.password!);

      print('###### SignInWithEmailAndPasswordPressed 2 #######');
      if (fos.isLeft()) {
        print(fos.getLeft());
      } else {
        print(fos.getRight());
      }

      emit(state.copyWith(
        isSubmitting: false,
        authFailureOrSuccessOptionOnSignIn: optionOf(fos),
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

    on<ResetPasswordForEmailEvent>((event, emit) async {
      emit(state.copyWith(isSubmitting: true));

      final failureOrSuccess = await authRepository.resetPasswordForEmail(email: event.email, password: event.password);

      emit(state.copyWith(
        isSubmitting: false,
        authFailureOrSuccessOptionOnResetPassword: optionOf(failureOrSuccess),
      ));
    });
  }
}
