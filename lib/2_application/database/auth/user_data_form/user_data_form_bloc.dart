import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/3_domain/repositories/database/client_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../3_domain/entities/client.dart';
import '../../../../3_domain/enums/enums.dart';
import '../../../../failures/abstract_failure.dart';

part 'user_data_form_event.dart';
part 'user_data_form_state.dart';

class UserDataFormBloc extends Bloc<UserDataFormEvent, UserDataFormState> {
  final ClientRepository clientRepository;

  UserDataFormBloc({required this.clientRepository}) : super(UserDataFormState.initial()) {
    on<InitialUserDataFormEvent>((event, emit) {
      if (event.client != null) {
        emit(state.copyWith(client: event.client, isLoading: true));
      } else {
        emit(state);
      }
    });

    on<SaveUserDataPressedEvent>((event, emit) async {
      Either<AbstractFailure, Unit>? failureOrSuccessClient;

      emit(state.copyWith(isLoading: true, failureOrSuccessClientOption: none()));

      final Client editedConditioner = state.client.copyWith(
        gender: event.gender,
        companyName: event.companyName,
        firstName: event.firstName,
        lastName: event.lastName,
        tel1: event.tel1,
        tel2: event.tel2,
        email: event.email,
        street: event.street,
        postCode: event.postCode,
        city: event.city,
        country: event.country,
      );

      if (state.isLoading) failureOrSuccessClient = await clientRepository.createClient(editedConditioner);

      emit(state.copyWith(isLoading: false, failureOrSuccessClientOption: optionOf(failureOrSuccessClient)));
    });
  }
}
