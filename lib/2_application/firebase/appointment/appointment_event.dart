part of 'appointment_bloc.dart';

@immutable
abstract class AppointmentEvent {}

class SetAppointmentStateToInitialEvent extends AppointmentEvent {}

class GetAppointmentEvent extends AppointmentEvent {
  final Receipt appointment;

  GetAppointmentEvent({required this.appointment});
}

class SetAppointmentEvent extends AppointmentEvent {
  final Receipt appointment;

  SetAppointmentEvent({required this.appointment});
}

class GetCustomerInAppointmentEvent extends AppointmentEvent {
  final String customerId;

  GetCustomerInAppointmentEvent({required this.customerId});
}

class GetReceiptsEvent extends AppointmentEvent {
  final int tabValue;
  final ReceiptTyp receiptTyp;

  GetReceiptsEvent({required this.tabValue, required this.receiptTyp});
}

class GetNewAppointmentByIdFromPrestaEvent extends AppointmentEvent {
  final int id;
  final Marketplace marketplace;

  GetNewAppointmentByIdFromPrestaEvent({required this.id, required this.marketplace});
}

class GetNewAppointmentsFromPrestaEvent extends AppointmentEvent {}

class CreateNewAppointmentManuallyEvent extends AppointmentEvent {
  final Receipt receipt;

  CreateNewAppointmentManuallyEvent({required this.receipt});
}

class UpdateAppointmentEvent extends AppointmentEvent {
  final Receipt appointment;
  final List<ReceiptProduct> oldListOfReceiptProducts;
  final List<ReceiptProduct> newListOfReceiptProducts;

  UpdateAppointmentEvent({required this.appointment, required this.oldListOfReceiptProducts, required this.newListOfReceiptProducts});
}

class DeleteSelectedReceiptsEvent extends AppointmentEvent {
  final List<Receipt> selectedReceipts;

  DeleteSelectedReceiptsEvent({required this.selectedReceipts});
}

class SetSearchFieldTextAppointmentsEvent extends AppointmentEvent {
  final String searchText;

  SetSearchFieldTextAppointmentsEvent({required this.searchText});
}

class OnSearchFieldSubmittedAppointmentsEvent extends AppointmentEvent {}

class OnGenerateFromOfferNewAppointmentEvent extends AppointmentEvent {}

class OnGenerateFromAppointmentEvent extends AppointmentEvent {
  final bool generateDeliveryNote;
  final bool generateInvoice;

  OnGenerateFromAppointmentEvent({required this.generateDeliveryNote, required this.generateInvoice});
}

class OnGenerateFromDeliveryNotesNewInvoiceEvent extends AppointmentEvent {}

class OnGenerateFromInvoiceNewCreditEvent extends AppointmentEvent {}

//* --- helper --- *//
class SetAppointmentIsExpandedEvent extends AppointmentEvent {
  final int index;

  SetAppointmentIsExpandedEvent({required this.index});
}

class OnSelectAllAppointmentsEvent extends AppointmentEvent {
  final bool isSelected;

  OnSelectAllAppointmentsEvent({required this.isSelected});
}

class OnAppointmentSelectedEvent extends AppointmentEvent {
  final Receipt appointment;

  OnAppointmentSelectedEvent({required this.appointment});
}

class OnAppointmentMarketplaceChangedEvent extends AppointmentEvent {
  final Marketplace marketplace;

  OnAppointmentMarketplaceChangedEvent({required this.marketplace});
}

class OnAppointmentPaymentMethodChangedEvent extends AppointmentEvent {
  final PaymentMethod paymentMethod;

  OnAppointmentPaymentMethodChangedEvent({required this.paymentMethod});
}

class OnAppointmentPaymentStatusChangedEvent extends AppointmentEvent {
  final String paymentStatus;

  OnAppointmentPaymentStatusChangedEvent({required this.paymentStatus});
}

class OnAppointmentCarrierChangedEvent extends AppointmentEvent {
  final ReceiptCarrier receiptCarrier;

  OnAppointmentCarrierChangedEvent({required this.receiptCarrier});
}

class OnAppointmentCarrierProductChangedEvent extends AppointmentEvent {
  final CarrierProduct receiptCarrierProduct;

  OnAppointmentCarrierProductChangedEvent({required this.receiptCarrierProduct});
}

class OnEditAddressReceiptDetailEvent extends AppointmentEvent {
  final Address address;

  OnEditAddressReceiptDetailEvent({required this.address});
}

class SendEmailToCustomerReceiptEvent extends AppointmentEvent {}
