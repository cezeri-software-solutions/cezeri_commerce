part of 'main_settings_bloc.dart';

@immutable
class MainSettingsState {
  final MainSettings? mainSettings;
  final FirebaseFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingMainSettingsOnObserve;
  final bool isLoadingMainSettingsOnCreate;
  final bool isLoadingMainSettingsOnUpdate;
  final Option<Either<FirebaseFailure, MainSettings>> fosMainSettingsOnObserveOption;
  final Option<Either<FirebaseFailure, Unit>> fosMainSettingsOnCreateOption;
  final Option<Either<FirebaseFailure, Unit>> fosMainSettingsOnUpdateOption;

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
    FirebaseFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingMainSettingsOnObserve,
    bool? isLoadingMainSettingsOnCreate,
    bool? isLoadingMainSettingsOnUpdate,
    Option<Either<FirebaseFailure, MainSettings>>? fosMainSettingsOnObserveOption,
    Option<Either<FirebaseFailure, Unit>>? fosMainSettingsOnCreateOption,
    Option<Either<FirebaseFailure, Unit>>? fosMainSettingsOnUpdateOption,
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
