part of 'receipt_bloc.dart';

@immutable
abstract class ReceiptEvent {}

class SetAppointmentStateToInitialEvent extends ReceiptEvent {}

class GetReceiptEvent extends ReceiptEvent {
  final Receipt appointment;

  GetReceiptEvent({required this.appointment});
}

class SetReceiptEvent extends ReceiptEvent {
  final Receipt appointment;

  SetReceiptEvent({required this.appointment});
}

class GetReceiptsEvent extends ReceiptEvent {
  final int tabValue;
  final ReceiptType receiptTyp;

  GetReceiptsEvent({required this.tabValue, required this.receiptTyp});
}

class GetReceiptsPerPageEvent extends ReceiptEvent {
  final bool isFirstLoad;
  final bool calcCount;
  final int currentPage;
  final int tabValue;
  final ReceiptType receiptType;

  GetReceiptsPerPageEvent({
    required this.isFirstLoad,
    required this.calcCount,
    required this.currentPage,
    required this.tabValue,
    required this.receiptType,
  });
}

class GetNewAppointmentByIdFromPrestaEvent extends ReceiptEvent {
  final int id;
  final AbstractMarketplace marketplace;

  GetNewAppointmentByIdFromPrestaEvent({required this.id, required this.marketplace});
}

class GetNewAppointmentsFromMarketplacesEvent extends ReceiptEvent {}

class CreateNewReceiptManuallyEvent extends ReceiptEvent {
  final Receipt receipt;

  CreateNewReceiptManuallyEvent({required this.receipt});
}

class DeleteSelectedReceiptsEvent extends ReceiptEvent {
  final List<Receipt> selectedReceipts;

  DeleteSelectedReceiptsEvent({required this.selectedReceipts});
}

class OnSearchFieldSubmittedAppointmentsEvent extends ReceiptEvent {}

class OnSearchFieldClearedEvent extends ReceiptEvent {}

class OnGenerateFromOfferNewAppointmentEvent extends ReceiptEvent {}

class OnGenerateFromAppointmentEvent extends ReceiptEvent {
  final bool generateDeliveryNote;
  final bool generateInvoice;

  OnGenerateFromAppointmentEvent({required this.generateDeliveryNote, required this.generateInvoice});
}

class OnGenerateFromDeliveryNotesNewInvoiceEvent extends ReceiptEvent {}

class OnGenerateFromInvoiceNewCreditEvent extends ReceiptEvent {
  final bool setQuantity;

  OnGenerateFromInvoiceNewCreditEvent({required this.setQuantity});
}

//* --- helper --- *//

class ItemsPerPageChangedEvent extends ReceiptEvent {
  final int value;

  ItemsPerPageChangedEvent({required this.value});
}

class SetAppointmentIsExpandedEvent extends ReceiptEvent {
  final int index;

  SetAppointmentIsExpandedEvent({required this.index});
}

class OnSelectAllAppointmentsEvent extends ReceiptEvent {
  final bool isSelected;

  OnSelectAllAppointmentsEvent({required this.isSelected});
}

class OnAppointmentSelectedEvent extends ReceiptEvent {
  final Receipt appointment;

  OnAppointmentSelectedEvent({required this.appointment});
}
