import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/3_domain/entities/settings/payment_method.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../3_domain/entities/settings/main_settings.dart';
import '../../../3_domain/entities/settings/tax.dart';
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
//? ########################## Tax Rules ####################################

    on<AddTaxRulesEvent>((event, emit) async {
      final List<Tax> taxRules = List.from(state.mainSettings!.taxes);
      final isDefaultSet = taxRules.any((e) => e.isDefault);

      if (isDefaultSet && event.taxRules.isDefault) return;

      taxRules.add(event.taxRules);

      MainSettings updatedMainSettings = state.mainSettings!.copyWith(taxes: taxRules);

      add(UpdateMainSettingsEvent(mainSettings: updatedMainSettings));
    });

//? #########################################################################

    on<UpdateTaxRulesEvent>((event, emit) async {
      List<Tax> taxRules = List.from(state.mainSettings!.taxes);
      final index = taxRules.indexWhere((e) => e.taxId == event.taxRules.taxId);

      taxRules[index] = event.taxRules;

      MainSettings updatedMainSettings = state.mainSettings!.copyWith(taxes: taxRules);

      add(UpdateMainSettingsEvent(mainSettings: updatedMainSettings));
    });

//? ################################################################
//? ########################## Payment Methods #####################

    on<EnableOrDesablePaymentMethodEvent>((event, emit) async {
      List<PaymentMethod> paymentMethods = List.from(state.mainSettings!.paymentMethods);

      if (event.value) {
        final isAlreadyActive = paymentMethods.any((e) => e.name == event.paymentMethod.name);
        if (!isAlreadyActive) paymentMethods.add(event.paymentMethod);
      } else {
        final index = paymentMethods.indexWhere((e) => e.name == event.paymentMethod.name);
        if (index >= 0) paymentMethods.removeAt(index);
      }

      MainSettings updatedMainSettings = state.mainSettings!.copyWith(paymentMethods: paymentMethods);

      add(UpdateMainSettingsEvent(mainSettings: updatedMainSettings));
    });

//? #########################################################################
  }
}
