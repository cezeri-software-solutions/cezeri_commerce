import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/3_domain/entities/settings/payment_method.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../3_domain/entities/carrier/carrier.dart';
import '../../../3_domain/entities/carrier/carrier_product.dart';
import '../../../3_domain/entities/country.dart';
import '../../../3_domain/entities/settings/main_settings.dart';
import '../../../3_domain/entities/settings/packaging_box.dart';
import '../../../3_domain/entities/settings/tax.dart';
import '../../../3_domain/repositories/firebase/main_settings_respository.dart';
import '../../../failures/abstract_failure.dart';

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

    on<UpdateMainSettingsEvent>((event, emit) async {
      emit(state.copyWith(isLoadingMainSettingsOnUpdate: true));

      final failureOrSuccess = await mainSettingsRepository.updateSettings(event.mainSettings);
      failureOrSuccess.fold(
        (failure) => null,
        (mainSettings) => emit(state.copyWith(mainSettings: event.mainSettings, firebaseFailure: null, isAnyFailure: false)),
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

//? #########################################################################
//? ########################## Payment Methods ##############################

    on<EnableOrDisablePaymentMethodEvent>((event, emit) async {
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

//? ##############################################################################

    on<AddEditPaymentMethodMarketplaceNameEvent>((event, emit) async {
      List<PaymentMethod> paymentMethods = List.from(state.mainSettings!.paymentMethods);

      final index = paymentMethods.indexWhere((e) => e.name == event.paymentMethod.name);
      if (index != -1) {
        paymentMethods[index] = paymentMethods[index].copyWith(nameInMarketplace: event.value);
      } else {
        return;
      }

      MainSettings updatedMainSettings = state.mainSettings!.copyWith(paymentMethods: paymentMethods);

      add(UpdateMainSettingsEvent(mainSettings: updatedMainSettings));
    });

//? ##############################################################################
//? ########################## Packaging Boxes ###################################

    on<PackagingBoxMainSettingsAddEvent>((event, emit) async {
      List<PackagingBox> packagingBoxes = List.from(state.mainSettings!.listOfPackagingBoxes);
      if (packagingBoxes.isEmpty) {
        packagingBoxes.add(event.packagingBox.copyWith(pos: 1));
      } else {
        final positions = packagingBoxes.map((e) => e.pos).toList();
        int nextPos = positions.reduce((current, next) => current > next ? current : next) + 1;
        final updatedPackagingBox = event.packagingBox.copyWith(pos: nextPos);
        packagingBoxes.add(updatedPackagingBox);
      }

      emit(state.copyWith(mainSettings: state.mainSettings!.copyWith(listOfPackagingBoxes: packagingBoxes)));
    });

//? #########################################################################

    on<PackagingBoxMainSettingsUpdateEvent>((event, emit) async {
      List<PackagingBox> packagingBoxes = List.from(state.mainSettings!.listOfPackagingBoxes);
      List<PackagingBox> updatedPackagingBoxes = packagingBoxes.map((e) {
        if (e.id == event.packagingBox.id) {
          return event.packagingBox;
        } else {
          return e;
        }
      }).toList();

      emit(state.copyWith(mainSettings: state.mainSettings!.copyWith(listOfPackagingBoxes: updatedPackagingBoxes)));
    });

//? #########################################################################

    on<OnReorderPackagingBoxMainSettingsUpdatePosEvent>((event, emit) async {
      List<PackagingBox> listOfPackagingBoxes = List.from(state.mainSettings!.listOfPackagingBoxes);

      int newIndex = event.newIndex;
      int oldIndex = event.oldIndex;

      if (newIndex > oldIndex) newIndex -= 1;

      final item = listOfPackagingBoxes.removeAt(oldIndex);
      listOfPackagingBoxes.insert(newIndex, item);

      for (int i = 0; i < listOfPackagingBoxes.length; i++) {
        listOfPackagingBoxes[i] = listOfPackagingBoxes[i].copyWith(pos: i + 1);
      }

      emit(state.copyWith(mainSettings: state.mainSettings!.copyWith(listOfPackagingBoxes: listOfPackagingBoxes)));
    });

//? #########################################################################

    on<PackagingBoxMainSettingsSaveEvent>((event, emit) async {
      emit(state.copyWith(isLoadingMainSettingsOnUpdate: true));

      final failureOrSuccess = await mainSettingsRepository.updateSettingsPackagingBoxs(state.mainSettings!.listOfPackagingBoxes);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (mainSettings) => emit(state.copyWith(mainSettings: mainSettings, firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingMainSettingsOnUpdate: false,
        fosMainSettingsOnUpdateWithMsOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosMainSettingsOnUpdateWithMsOption: none()));
    });

//? #########################################################################
//? ########################## Carriers #####################################

    on<EnableOrDisableCarrierEvent>((event, emit) async {
      List<Carrier> carriers = List.from(state.mainSettings!.listOfCarriers);

      final index = carriers.indexWhere((e) => e.internalName == event.carrier.internalName);

      if (event.value) {
        final isAlreadyActive = carriers.any((e) => e.internalName == event.carrier.internalName);
        if (isAlreadyActive) {
          if (carriers[index].isActive) {
            carriers[index] = carriers[index].copyWith(isActive: false, isDefault: false);
          } else {
            carriers[index] = carriers[index].copyWith(isActive: true);
            if (carriers.length == 1) carriers[index] = carriers[index].copyWith(isDefault: true);
          }
        } else {
          final toAddCarrier = event.carrier.copyWith(isActive: true);
          carriers.add(toAddCarrier);
        }
      } else {
        if (index >= 0) carriers[index] = carriers[index].copyWith(isActive: false, isDefault: false);
      }

      MainSettings updatedMainSettings = state.mainSettings!.copyWith(listOfCarriers: carriers);

      add(UpdateMainSettingsEvent(mainSettings: updatedMainSettings));
    });

//? #########################################################################

    on<OnIsDefaultCarrierChangedEvent>((event, emit) async {
      List<Carrier> carriers = List.from(state.mainSettings!.listOfCarriers);

      final index = carriers.indexWhere((e) => e.internalName == event.carrier.internalName);

      if (event.value) {
        carriers[index] = carriers[index].copyWith(isDefault: true);
        if (carriers.length > 1) {
          for (int i = 0; i < carriers.length; i++) {
            if (i == index) continue;
            carriers[i] = carriers[i].copyWith(isDefault: false);
          }
        }
      } else {
        if (carriers.length > 1) carriers[index] = carriers[index].copyWith(isDefault: false);
        for (int i = 0; i < carriers.length; i++) {
          if (i == index) continue;
          carriers[i] = carriers[i].copyWith(isDefault: true);
          break;
        }
      }

      MainSettings updatedMainSettings = state.mainSettings!.copyWith(listOfCarriers: carriers);

      add(UpdateMainSettingsEvent(mainSettings: updatedMainSettings));
    });

//? #########################################################################

    on<OnSaveCarrierDetailEvent>((event, emit) async {
      List<Carrier> updatedListOfCarriers = List.from(state.mainSettings!.listOfCarriers);
      updatedListOfCarriers[event.index] = state.curCarrier;
      final updatedMainSettings = state.mainSettings!.copyWith(listOfCarriers: updatedListOfCarriers);
      add(UpdateMainSettingsEvent(mainSettings: updatedMainSettings));
    });

//? #########################################################################

    on<OnCarrierDetailPressedEvent>((event, emit) async {
      emit(state.copyWith(
        curCarrier: event.carrier,
        marketplaceMappingController: TextEditingController(text: event.carrier.marketplaceMapping),
        clientIdController: TextEditingController(text: event.carrier.carrierKey.clientId),
        orgUnitIdController: TextEditingController(text: event.carrier.carrierKey.orgUnitId),
        orgUnitGuideController: TextEditingController(text: event.carrier.carrierKey.orgUnitGuide),
      ));
    });

//? #########################################################################

    on<OnCarrierControllerChangedEvent>((event, emit) async {
      emit(state.copyWith(
        curCarrier: state.curCarrier.copyWith(
          marketplaceMapping: state.marketplaceMappingController.text,
          carrierKey: state.curCarrier.carrierKey.copyWith(
            clientId: state.clientIdController.text,
            orgUnitId: state.orgUnitIdController.text,
            orgUnitGuide: state.orgUnitGuideController.text,
          ),
        ),
      ));
    });

//? #########################################################################

    on<OnCarrierPaperLayoutChangedEvnet>((event, emit) async {
      emit(state.copyWith(
        curCarrier: state.curCarrier.copyWith(paperLayout: event.value),
      ));
    });

//? #########################################################################

    on<OnCarrierLabelSizeChangedEvnet>((event, emit) async {
      emit(state.copyWith(
        curCarrier: state.curCarrier.copyWith(labelSize: event.value),
      ));
    });

//? #########################################################################

    on<OnCarrierPrinterLanguageChangedEvnet>((event, emit) async {
      emit(state.copyWith(
        curCarrier: state.curCarrier.copyWith(printerLanguage: event.value),
      ));
    });

//? #########################################################################

    on<SetSelectedCountryToCarrierAutomationEvent>((event, emit) async {
      emit(state.copyWith(selectedCountry: event.selectedCountry));
    });

//? #########################################################################

    on<SetSelectedCarrierProductToCarrierAutomationEvent>((event, emit) async {
      CarrierProduct carrierProduct = event.selectedCarrierProduct.copyWith(country: state.selectedCountry, isActive: true);

      emit(state.copyWith(selectedCarrierProduct: carrierProduct));
    });

//? #########################################################################

    on<SetIsReturnShipmentToCarrierAutomationEvent>((event, emit) async {
      emit(state.copyWith(selectedCarrierProduct: state.selectedCarrierProduct.copyWith(isReturn: event.value)));
    });

//? #########################################################################

    on<SaveSelectedCarrierProductToCarrierAutomationEvent>((event, emit) async {
      List<CarrierProduct> listOfCarrierProducts = List.from(state.curCarrier.carrierAutomations);
      listOfCarrierProducts.add(state.selectedCarrierProduct);

      emit(state.copyWith(
        curCarrier: state.curCarrier.copyWith(carrierAutomations: listOfCarrierProducts),
        selectedCountry: Country.countryList.where((e) => e.isoCode == 'AT').first,
        selectedCarrierProduct: CarrierProduct.empty(),
      ));
    });

//? #########################################################################

    on<ChangePackageAutomationForCountryEvnet>((event, emit) async {
      List<CarrierProduct> listOfCarrierProducts = List.from(state.curCarrier.carrierAutomations);
      CarrierProduct carrierProduct = listOfCarrierProducts[event.index].copyWith(
        id: event.selectedCarrierProduct.id,
        productName: event.selectedCarrierProduct.productName,
      );
      listOfCarrierProducts[event.index] = carrierProduct;

      emit(state.copyWith(curCarrier: state.curCarrier.copyWith(carrierAutomations: listOfCarrierProducts)));
    });

//? #########################################################################
  }
}
