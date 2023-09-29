part of 'main_settings_bloc.dart';

@immutable
abstract class MainSettingsEvent {}

class SetMainSettingsStateToInitialEvent extends MainSettingsEvent {}

class GetMainSettingsEvent extends MainSettingsEvent {}

class UpdateMainSettingsEvent extends MainSettingsEvent {
  final MainSettings mainSettings;

  UpdateMainSettingsEvent({required this.mainSettings});
}

class CreateMainSettingsEvent extends MainSettingsEvent {
  final MainSettings mainSettings;

  CreateMainSettingsEvent({required this.mainSettings});
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
