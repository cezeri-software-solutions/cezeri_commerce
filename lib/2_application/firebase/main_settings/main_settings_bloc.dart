import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../3_domain/entities/settings/main_settings.dart';
import '../../../3_domain/repositories/firebase/main_settings_respository.dart';
import '../../../core/firebase_failures.dart';

part 'main_settings_event.dart';
part 'main_settings_state.dart';

class MainSettingsBloc extends Bloc<MainSettingsEvent, MainSettingsState> {
  final MainSettingsRepository mainSettingsRepository;

  MainSettingsBloc({required this.mainSettingsRepository}) : super(MainSettingsState.initial()) {
//? #########################################################################

    on<SetMainSettingsStateToInitialEvent>((event, emit) {
      emit(MainSettingsState.initial());
    });

//? #########################################################################

    on<GetMainSettingsEvent>((event, emit) async {
      emit(state.copyWith(isLoadingMainSettingsOnObserve: true));

      final failureOrSuccess = await mainSettingsRepository.getSettings();
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (mainSettings) => emit(state.copyWith(mainSettings: mainSettings, firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingMainSettingsOnObserve: false,
        fosMainSettingsOnObserveOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosMainSettingsOnObserveOption: none()));
    });

//? #########################################################################

    on<CreateMainSettingsEvent>((event, emit) async {
      emit(state.copyWith(isLoadingMainSettingsOnCreate: true));

      final failureOrSuccess = await mainSettingsRepository.createSettings(event.mainSettings);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (mainSettings) => emit(state.copyWith(firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingMainSettingsOnCreate: false,
        fosMainSettingsOnCreateOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosMainSettingsOnCreateOption: none()));
    });

//? #########################################################################

    on<UpdateMainSettingsEvent>((event, emit) async {
      emit(state.copyWith(isLoadingMainSettingsOnUpdate: true));

      final failureOrSuccess = await mainSettingsRepository.updateSettings(event.mainSettings);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (mainSettings) => emit(state.copyWith(firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingMainSettingsOnUpdate: false,
        fosMainSettingsOnUpdateOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosMainSettingsOnUpdateOption: none()));
    });

//? #########################################################################
  }
}
