import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../3_domain/entities/client.dart';
import '../../../3_domain/repositories/firebase/client_repository.dart';
import '../../../failures/abstract_failure.dart';

part 'client_event.dart';
part 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  final ClientRepository clientRepository;

  ClientBloc({required this.clientRepository}) : super(ClientState.initial()) {
//? #########################################################################

    on<SetClientStateToInitialEvnet>((event, emit) {
      emit(ClientState.initial());
    });

//? #########################################################################

    on<GetCurrentClientEvent>((event, emit) async {
      emit(state.copyWith(isLoadingClientOnObserve: true));

      final failureOrSuccess = await clientRepository.getCurClient();
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (client) => emit(state.copyWith(client: client, firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingClientOnObserve: false,
        fosClientOnObserveOption: optionOf(failureOrSuccess),
      ));
    });

//? #########################################################################
//? #########################################################################
//? #########################################################################
//? #########################################################################
  }
}
