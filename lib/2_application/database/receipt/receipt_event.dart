part of 'receipt_bloc.dart';

@immutable
abstract class ReceiptEvent {}

class SetAppointmentStateToInitialEvent extends ReceiptEvent {}

class GetReceiptEvent extends ReceiptEvent {
  final Receipt appointment;

  GetReceiptEvent({required this.appointment});
}

class SetAppointmentEvent extends ReceiptEvent {
  final Receipt appointment;

  SetAppointmentEvent({required this.appointment});
}

class GetCustomerInAppointmentEvent extends ReceiptEvent {
  final String customerId;

  GetCustomerInAppointmentEvent({required this.customerId});
}

class GetReceiptsEvent extends ReceiptEvent {
  final int tabValue;
  final ReceiptTyp receiptTyp;

  GetReceiptsEvent({required this.tabValue, required this.receiptTyp});
}

class GetNewAppointmentByIdFromPrestaEvent extends ReceiptEvent {
  final int id;
  final AbstractMarketplace marketplace;

  GetNewAppointmentByIdFromPrestaEvent({required this.id, required this.marketplace});
}

class GetNewAppointmentsFromMarketplacesEvent extends ReceiptEvent {}

class CreateNewAppointmentManuallyEvent extends ReceiptEvent {
  final Receipt receipt;

  CreateNewAppointmentManuallyEvent({required this.receipt});
}

class UpdateAppointmentEvent extends ReceiptEvent {
  final Receipt appointment;
  final List<ReceiptProduct> oldListOfReceiptProducts;
  final List<ReceiptProduct> newListOfReceiptProducts;

  UpdateAppointmentEvent({required this.appointment, required this.oldListOfReceiptProducts, required this.newListOfReceiptProducts});
}

class DeleteSelectedReceiptsEvent extends ReceiptEvent {
  final List<Receipt> selectedReceipts;

  DeleteSelectedReceiptsEvent({required this.selectedReceipts});
}

class SetSearchFieldTextAppointmentsEvent extends ReceiptEvent {
  final String searchText;

  SetSearchFieldTextAppointmentsEvent({required this.searchText});
}

class OnSearchFieldSubmittedAppointmentsEvent extends ReceiptEvent {}

class OnGenerateFromOfferNewAppointmentEvent extends ReceiptEvent {}

class OnGenerateFromAppointmentEvent extends ReceiptEvent {
  final bool generateDeliveryNote;
  final bool generateInvoice;

  OnGenerateFromAppointmentEvent({required this.generateDeliveryNote, required this.generateInvoice});
}

class OnGenerateFromDeliveryNotesNewInvoiceEvent extends ReceiptEvent {}

class OnGenerateFromInvoiceNewCreditEvent extends ReceiptEvent {}

//* --- products --- *//
class GetProductByEanEvent extends ReceiptEvent {
  final String ean;

  GetProductByEanEvent({required this.ean});
}

//* --- helper --- *//
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

class OnReceiptCustomerEmailChangedEvent extends ReceiptEvent {
  final String email;

  OnReceiptCustomerEmailChangedEvent({required this.email});
}

class OnAppointmentMarketplaceChangedEvent extends ReceiptEvent {
  final AbstractMarketplace marketplace;

  OnAppointmentMarketplaceChangedEvent({required this.marketplace});
}

class OnAppointmentPaymentMethodChangedEvent extends ReceiptEvent {
  final PaymentMethod paymentMethod;

  OnAppointmentPaymentMethodChangedEvent({required this.paymentMethod});
}

class OnAppointmentPaymentStatusChangedEvent extends ReceiptEvent {
  final String paymentStatus;

  OnAppointmentPaymentStatusChangedEvent({required this.paymentStatus});
}

class OnAppointmentCarrierChangedEvent extends ReceiptEvent {
  final ReceiptCarrier receiptCarrier;

  OnAppointmentCarrierChangedEvent({required this.receiptCarrier});
}

class OnAppointmentCarrierProductChangedEvent extends ReceiptEvent {
  final CarrierProduct receiptCarrierProduct;

  OnAppointmentCarrierProductChangedEvent({required this.receiptCarrierProduct});
}

class OnEditAddressReceiptDetailEvent extends ReceiptEvent {
  final Address address;

  OnEditAddressReceiptDetailEvent({required this.address});
}

class OnReceiptCustomerUpdatedEvent extends ReceiptEvent {
  final Customer customer;

  OnReceiptCustomerUpdatedEvent({required this.customer});
}

class CreateParcelLabelReceiptEvent extends ReceiptEvent {
  final double weight;

  CreateParcelLabelReceiptEvent({required this.weight});
}

class SetIsDeliveryBlockedEvent extends ReceiptEvent {
  final bool value;

  SetIsDeliveryBlockedEvent({required this.value});
}
