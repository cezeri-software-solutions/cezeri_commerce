part of 'main_settings_bloc.dart';

@immutable
abstract class MainSettingsEvent {}

class SetMainSettingsStateToInitialEvent extends MainSettingsEvent {}

class GetMainSettingsEvent extends MainSettingsEvent {}

class UpdateMainSettingsEvent extends MainSettingsEvent {
  final MainSettings mainSettings;

  UpdateMainSettingsEvent({required this.mainSettings});
}

//? ################################################################
//? ########################## Tax Rules ###########################

class AddTaxRulesEvent extends MainSettingsEvent {
  final Tax taxRules;

  AddTaxRulesEvent({required this.taxRules});
}

class UpdateTaxRulesEvent extends MainSettingsEvent {
  final Tax taxRules;

  UpdateTaxRulesEvent({required this.taxRules});
}

//? ################################################################
//? ########################## Payment Methods #####################

class EnableOrDisablePaymentMethodEvent extends MainSettingsEvent {
  final bool value;
  final PaymentMethod paymentMethod;

  EnableOrDisablePaymentMethodEvent({required this.value, required this.paymentMethod});
}

class AddEditPaymentMethodMarketplaceNameEvent extends MainSettingsEvent {
  final String value;
  final PaymentMethod paymentMethod;

  AddEditPaymentMethodMarketplaceNameEvent({required this.value, required this.paymentMethod});
}

//? ################################################################
//? ########################## Packaging Boxes #####################

class PackagingBoxMainSettingsAddEvent extends MainSettingsEvent {
  final PackagingBox packagingBox;

  PackagingBoxMainSettingsAddEvent({required this.packagingBox});
}

//? ################################################################

class PackagingBoxMainSettingsUpdateEvent extends MainSettingsEvent {
  final PackagingBox packagingBox;

  PackagingBoxMainSettingsUpdateEvent({required this.packagingBox});
}

//? ################################################################

class OnReorderPackagingBoxMainSettingsUpdatePosEvent extends MainSettingsEvent {
  final int oldIndex;
  final int newIndex;

  OnReorderPackagingBoxMainSettingsUpdatePosEvent({required this.oldIndex, required this.newIndex});
}

//? ################################################################

class PackagingBoxMainSettingsSaveEvent extends MainSettingsEvent {}

//? ################################################################
//? ########################## Carriers ############################

class EnableOrDisableCarrierEvent extends MainSettingsEvent {
  final bool value;
  final Carrier carrier;

  EnableOrDisableCarrierEvent({required this.value, required this.carrier});
}

class OnIsDefaultCarrierChangedEvent extends MainSettingsEvent {
  final bool value;
  final Carrier carrier;

  OnIsDefaultCarrierChangedEvent({required this.value, required this.carrier});
}

class OnSaveCarrierDetailEvent extends MainSettingsEvent {
  final int index;

  OnSaveCarrierDetailEvent({required this.index});
}

class OnCarrierDetailPressedEvent extends MainSettingsEvent {
  final Carrier carrier;

  OnCarrierDetailPressedEvent({required this.carrier});
}

class OnCarrierControllerChangedEvent extends MainSettingsEvent {}

class OnCarrierPaperLayoutChangedEvnet extends MainSettingsEvent {
  final String value;

  OnCarrierPaperLayoutChangedEvnet({required this.value});
}

class OnCarrierLabelSizeChangedEvnet extends MainSettingsEvent {
  final String value;

  OnCarrierLabelSizeChangedEvnet({required this.value});
}

class OnCarrierPrinterLanguageChangedEvnet extends MainSettingsEvent {
  final String value;

  OnCarrierPrinterLanguageChangedEvnet({required this.value});
}

class SetSelectedCountryToCarrierAutomationEvent extends MainSettingsEvent {
  final Country selectedCountry;

  SetSelectedCountryToCarrierAutomationEvent({required this.selectedCountry});
}

class SetSelectedCarrierProductToCarrierAutomationEvent extends MainSettingsEvent {
  final CarrierProduct selectedCarrierProduct;

  SetSelectedCarrierProductToCarrierAutomationEvent({required this.selectedCarrierProduct});
}

class SetIsReturnShipmentToCarrierAutomationEvent extends MainSettingsEvent {
  final bool value;

  SetIsReturnShipmentToCarrierAutomationEvent({required this.value});
}

class SaveSelectedCarrierProductToCarrierAutomationEvent extends MainSettingsEvent {}

class ChangePackageAutomationForCountryEvnet extends MainSettingsEvent {
  final CarrierProduct selectedCarrierProduct;
  final int index;

  ChangePackageAutomationForCountryEvnet({required this.selectedCarrierProduct, required this.index});
}
