part of 'general_ledger_account_bloc.dart';

@immutable
abstract class GeneralLedgerAccountEvent {}

class SetGLAccountStateToInitialEvent extends GeneralLedgerAccountEvent {}

class GetAllGLAccountsEvent extends GeneralLedgerAccountEvent {}

class GetGLAccountEvent extends GeneralLedgerAccountEvent {
  final GeneralLedgerAccount gLAccount;

  GetGLAccountEvent({required this.gLAccount});
}

class CreateGLAccountEvent extends GeneralLedgerAccountEvent {}

class UpdateGLAccountEvent extends GeneralLedgerAccountEvent {}

class DeleteSelectedGLAccountsEvent extends GeneralLedgerAccountEvent {}

class OnGLAccountSearchControllerChangedEvent extends GeneralLedgerAccountEvent {}

class OnGLAccountSearchControllerClearedEvent extends GeneralLedgerAccountEvent {}

//* --- helper --- *//

class OnSelectAllGLAccountsEvent extends GeneralLedgerAccountEvent {
  final bool isSelected;

  OnSelectAllGLAccountsEvent({required this.isSelected});
}

class OnSelectGLAccountEvent extends GeneralLedgerAccountEvent {
  final GeneralLedgerAccount gLAccount;

  OnSelectGLAccountEvent({required this.gLAccount});
}

//* --- Controller --- *//

class SetGLAccountControllerEvent extends GeneralLedgerAccountEvent {}

class OnGLAccountControllerChangedEvent extends GeneralLedgerAccountEvent {}
