part of 'main_settings_bloc.dart';

@immutable
class MainSettingsState {
  final MainSettings? mainSettings;
  final AbstractFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingMainSettingsOnObserve;
  final bool isLoadingMainSettingsOnCreate;
  final bool isLoadingMainSettingsOnUpdate;
  final Option<Either<AbstractFailure, MainSettings>> fosMainSettingsOnObserveOption;
  final Option<Either<AbstractFailure, Unit>> fosMainSettingsOnCreateOption;
  final Option<Either<AbstractFailure, Unit>> fosMainSettingsOnUpdateOption;
  final Option<Either<AbstractFailure, MainSettings>> fosMainSettingsOnUpdateWithMsOption;

  //* #################################################################
  //* ############################ Carrier ############################
  final Carrier curCarrier;
  final TextEditingController marketplaceMappingController;
  final TextEditingController clientIdController;
  final TextEditingController orgUnitIdController;
  final TextEditingController orgUnitGuideController;
  final Country selectedCountry;
  final CarrierProduct selectedCarrierProduct;

  const MainSettingsState({
    required this.mainSettings,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingMainSettingsOnObserve,
    required this.isLoadingMainSettingsOnCreate,
    required this.isLoadingMainSettingsOnUpdate,
    required this.fosMainSettingsOnObserveOption,
    required this.fosMainSettingsOnCreateOption,
    required this.fosMainSettingsOnUpdateOption,
    required this.fosMainSettingsOnUpdateWithMsOption,
    required this.curCarrier,
    required this.marketplaceMappingController,
    required this.clientIdController,
    required this.orgUnitIdController,
    required this.orgUnitGuideController,
    required this.selectedCountry,
    required this.selectedCarrierProduct,
  });

  factory MainSettingsState.initial() => MainSettingsState(
        mainSettings: null,
        firebaseFailure: null,
        isAnyFailure: false,
        isLoadingMainSettingsOnObserve: false,
        isLoadingMainSettingsOnCreate: false,
        isLoadingMainSettingsOnUpdate: false,
        fosMainSettingsOnObserveOption: none(),
        fosMainSettingsOnCreateOption: none(),
        fosMainSettingsOnUpdateOption: none(),
        fosMainSettingsOnUpdateWithMsOption: none(),
        curCarrier: Carrier.empty(),
        marketplaceMappingController: TextEditingController(),
        clientIdController: TextEditingController(),
        orgUnitIdController: TextEditingController(),
        orgUnitGuideController: TextEditingController(),
        selectedCountry: Country.countryList.where((e) => e.isoCode == 'AT').first,
        selectedCarrierProduct: CarrierProduct.empty(),
      );

  MainSettingsState copyWith({
    MainSettings? mainSettings,
    AbstractFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingMainSettingsOnObserve,
    bool? isLoadingMainSettingsOnCreate,
    bool? isLoadingMainSettingsOnUpdate,
    Option<Either<AbstractFailure, MainSettings>>? fosMainSettingsOnObserveOption,
    Option<Either<AbstractFailure, Unit>>? fosMainSettingsOnCreateOption,
    Option<Either<AbstractFailure, Unit>>? fosMainSettingsOnUpdateOption,
    Option<Either<AbstractFailure, MainSettings>>? fosMainSettingsOnUpdateWithMsOption,
    Carrier? curCarrier,
    TextEditingController? marketplaceMappingController,
    TextEditingController? clientIdController,
    TextEditingController? orgUnitIdController,
    TextEditingController? orgUnitGuideController,
    Country? selectedCountry,
    CarrierProduct? selectedCarrierProduct,
  }) {
    return MainSettingsState(
      mainSettings: mainSettings ?? this.mainSettings,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingMainSettingsOnObserve: isLoadingMainSettingsOnObserve ?? this.isLoadingMainSettingsOnObserve,
      isLoadingMainSettingsOnCreate: isLoadingMainSettingsOnCreate ?? this.isLoadingMainSettingsOnCreate,
      isLoadingMainSettingsOnUpdate: isLoadingMainSettingsOnUpdate ?? this.isLoadingMainSettingsOnUpdate,
      fosMainSettingsOnObserveOption: fosMainSettingsOnObserveOption ?? this.fosMainSettingsOnObserveOption,
      fosMainSettingsOnCreateOption: fosMainSettingsOnCreateOption ?? this.fosMainSettingsOnCreateOption,
      fosMainSettingsOnUpdateOption: fosMainSettingsOnUpdateOption ?? this.fosMainSettingsOnUpdateOption,
      fosMainSettingsOnUpdateWithMsOption: fosMainSettingsOnUpdateWithMsOption ?? this.fosMainSettingsOnUpdateWithMsOption,
      curCarrier: curCarrier ?? this.curCarrier,
      marketplaceMappingController: marketplaceMappingController ?? this.marketplaceMappingController,
      clientIdController: clientIdController ?? this.clientIdController,
      orgUnitIdController: orgUnitIdController ?? this.orgUnitIdController,
      orgUnitGuideController: orgUnitGuideController ?? this.orgUnitGuideController,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedCarrierProduct: selectedCarrierProduct ?? this.selectedCarrierProduct,
    );
  }
}
