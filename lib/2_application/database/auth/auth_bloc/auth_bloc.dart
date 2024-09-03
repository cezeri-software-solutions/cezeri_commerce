import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../3_domain/repositories/firebase/auth_repository.dart';
import '../../../../3_domain/repositories/firebase/client_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final ClientRepository clientRepository;

  AuthBloc({required this.authRepository, required this.clientRepository}) : super(AuthInitial()) {
    //
    on<SignOutPressedEvent>((event, emit) async {
      await authRepository.signOut();
      emit(AuthStateUnauthenticated());
    });

    on<AuthCheckRequestedEvent>((event, emit) async {
      //! TEST
      // await authRepository.signOut();
      final userOption = authRepository.checkIfUserIsSignedIn();
      switch (userOption) {
        case false:
          {
            emit(AuthStateUnauthenticated());
          }
        case true:
          {
            emit(AuthStateAuthenticated());
          }
      }
    });
  }
}
