part of 'receipt_detail_bloc.dart';

abstract class ReceiptDetailEvent {}

class SetReceiptDetailStatesToInitialEvent extends ReceiptDetailEvent {}

class ReceiptDetailSetEmptyReceiptEvent extends ReceiptDetailEvent {
  final Receipt newEmptyReceipt;

  ReceiptDetailSetEmptyReceiptEvent({required this.newEmptyReceipt});
}

class ReceiptDetailGetReceiptEvent extends ReceiptDetailEvent {
  final String receiptId;
  final ReceiptType receiptType;

  ReceiptDetailGetReceiptEvent({required this.receiptId, required this.receiptType});
}

class ReceiptDetailGetProductByEanEvent extends ReceiptDetailEvent {
  final String ean;

  ReceiptDetailGetProductByEanEvent({required this.ean});
}

class ReceiptDetailCreateParcelLabelReceiptEvent extends ReceiptDetailEvent {
  final double weight;

  ReceiptDetailCreateParcelLabelReceiptEvent({required this.weight});
}

class ReceiptDetailUpdateReceiptEvent extends ReceiptDetailEvent {
  final Receipt receipt;
  final List<ReceiptProduct> oldListOfReceiptProducts;
  final List<ReceiptProduct> newListOfReceiptProducts;

  ReceiptDetailUpdateReceiptEvent({required this.receipt, required this.oldListOfReceiptProducts, required this.newListOfReceiptProducts});
}

class ReceiptDetailCreateReceiptManuallyEvent extends ReceiptDetailEvent {
  final Receipt receipt;

  ReceiptDetailCreateReceiptManuallyEvent({required this.receipt});
}

//* ##############################################################################################################
//* ##############################################################################################################
//* ReceiptDetailAddressCard

class ReceiptDetailEditAddressEvent extends ReceiptDetailEvent {
  final Address address;

  ReceiptDetailEditAddressEvent({required this.address});
}

class ReceiptDetailUpdateCustomerEvent extends ReceiptDetailEvent {
  final Customer customer;

  ReceiptDetailUpdateCustomerEvent({required this.customer});
}

//* ##############################################################################################################
//* ##############################################################################################################
//* ReceiptDetailGeneralCard

class ReceiptDetailCustomerEmailChangedEvent extends ReceiptDetailEvent {
  final String email;

  ReceiptDetailCustomerEmailChangedEvent({required this.email});
}

class ReceiptDetailMarketplaceChangedEvent extends ReceiptDetailEvent {
  final AbstractMarketplace marketplace;

  ReceiptDetailMarketplaceChangedEvent({required this.marketplace});
}

class ReceiptDetailDeliveryBlockedChangedEvent extends ReceiptDetailEvent {
  final bool value;

  ReceiptDetailDeliveryBlockedChangedEvent({required this.value});
}

//* ##############################################################################################################
//* ##############################################################################################################
//* ReceiptDetailPaymentMethodCard

class ReceiptDetailPaymentMethodChangedEvent extends ReceiptDetailEvent {
  final PaymentMethod paymentMethod;

  ReceiptDetailPaymentMethodChangedEvent({required this.paymentMethod});
}

class ReceiptDetailPaymentStatusChangedEvent extends ReceiptDetailEvent {
  final String paymentStatus;

  ReceiptDetailPaymentStatusChangedEvent({required this.paymentStatus});
}

//* ##############################################################################################################
//* ##############################################################################################################
//* ReceiptDetailCarrierCard

class ReceiptDetailCarrierChangedEvent extends ReceiptDetailEvent {
  final ReceiptCarrier receiptCarrier;

  ReceiptDetailCarrierChangedEvent({required this.receiptCarrier});
}

class ReceiptDetailCarrierProductChangedEvent extends ReceiptDetailEvent {
  final CarrierProduct receiptCarrierProduct;

  ReceiptDetailCarrierProductChangedEvent({required this.receiptCarrierProduct});
}

//* ##############################################################################################################
//* ##############################################################################################################
//* ReceiptDetailCommentsCard

class ReceiptDetailCommentChangedEvent extends ReceiptDetailEvent {}

//* ##############################################################################################################
//* ##############################################################################################################
//* ReceiptDetailSameReceiptsCard

class ReceiptDetailGetSameReceiptsEvent extends ReceiptDetailEvent {}
