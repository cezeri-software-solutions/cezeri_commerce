part of 'incoming_invoice_detail_bloc.dart';

abstract class IncomingInvoiceDetailEvent {}

class SetIncomingInvoiceDetailToInitial extends IncomingInvoiceDetailEvent {}

class SetInitialControllerEvent extends IncomingInvoiceDetailEvent {}

class SetIncomingInvoiceEvent extends IncomingInvoiceDetailEvent {
  final IncomingInvoiceAddEditType type;
  final Supplier? supplier;
  final String? incomingInvoiceId;

  SetIncomingInvoiceEvent({required this.type, required this.supplier, required this.incomingInvoiceId});
}

class SetIncomingInvoiceOnCreateEvent extends IncomingInvoiceDetailEvent {
  final Supplier supplier;

  SetIncomingInvoiceOnCreateEvent({required this.supplier});
}

class SetIncomingInvoiceOnCopyEvent extends IncomingInvoiceDetailEvent {
  final String incomingInvoiceId;

  SetIncomingInvoiceOnCopyEvent({required this.incomingInvoiceId});
}

class SetIncomingInvoiceOnEditEvent extends IncomingInvoiceDetailEvent {
  final Supplier? supplier;
  final String incomingInvoiceId;

  SetIncomingInvoiceOnEditEvent({required this.supplier, required this.incomingInvoiceId});
}

class GetIncomingInvoiceEvent extends IncomingInvoiceDetailEvent {
  final String id;

  GetIncomingInvoiceEvent({required this.id});
}

class CreateIncomingInvoiceEvent extends IncomingInvoiceDetailEvent {}

class UpdateIncomingInvoiceEvent extends IncomingInvoiceDetailEvent {}

//* Helpers Controller
class OnInvoiceNumberControllerChangedEvent extends IncomingInvoiceDetailEvent {}

class OnDiscountPercentageControllerChangedEvent extends IncomingInvoiceDetailEvent {}

class OnDiscountAmountControllerChangedEvent extends IncomingInvoiceDetailEvent {}

class OnEarlyPaymentControllerChangedEvent extends IncomingInvoiceDetailEvent {}

class OnCommentControllerChangedEvent extends IncomingInvoiceDetailEvent {}

//* Helpers Values

class OnDiscountPercentageChangedEvent extends IncomingInvoiceDetailEvent {
  final String value;

  OnDiscountPercentageChangedEvent({required this.value});
}

class OnDiscountAmountChangedEvent extends IncomingInvoiceDetailEvent {
  final String value;

  OnDiscountAmountChangedEvent({required this.value});
}

class OnCurrencyChangedEvent extends IncomingInvoiceDetailEvent {
  final String currency;

  OnCurrencyChangedEvent({required this.currency});
}

class OnPaymentMethodChangedEvent extends IncomingInvoiceDetailEvent {
  final String paymentMethod;

  OnPaymentMethodChangedEvent({required this.paymentMethod});
}

//* Helpers Dates
class OnEarlyPaymentDiscountDateChangedEvent extends IncomingInvoiceDetailEvent {
  final DateTime? date;

  OnEarlyPaymentDiscountDateChangedEvent({required this.date});
}

class OnInvoiceDateChangedEvent extends IncomingInvoiceDetailEvent {
  final DateTime date;

  OnInvoiceDateChangedEvent({required this.date});
}

class OnBookingDateChangedEvent extends IncomingInvoiceDetailEvent {
  final DateTime? date;

  OnBookingDateChangedEvent({required this.date});
}

class OnDueDateChangedEvent extends IncomingInvoiceDetailEvent {
  final DateTime? date;

  OnDueDateChangedEvent({required this.date});
}

class OnDeliveryDateChangedEvent extends IncomingInvoiceDetailEvent {
  final DateTime? date;

  OnDeliveryDateChangedEvent({required this.date});
}

//* ############################################################################################################################
//* Incoming Invoice FILES

class OnAddFilesToListEvent extends IncomingInvoiceDetailEvent {
  final List<IncomingInvoiceFile> listOfFiles;

  OnAddFilesToListEvent({required this.listOfFiles});
}

class OnRemoveFileFromListEvent extends IncomingInvoiceDetailEvent {
  final int index;

  OnRemoveFileFromListEvent({required this.index});
}

class OnUpdateFileNameEvent extends IncomingInvoiceDetailEvent {
  final String name;
  final int index;

  OnUpdateFileNameEvent({required this.name, required this.index});
}

//* ############################################################################################################################
//* Incoming Invoice ITEMS

class OnAddNewItemToListEvent extends IncomingInvoiceDetailEvent {
  final ItemType itemType;

  OnAddNewItemToListEvent({required this.itemType});
}

class OnAddNewItemsFromReorderEvent extends IncomingInvoiceDetailEvent {
  final Reorder reorder;

  OnAddNewItemsFromReorderEvent({required this.reorder});
}

class OnRemoveItemFromListEvent extends IncomingInvoiceDetailEvent {
  final int index;

  OnRemoveItemFromListEvent({required this.index});
}

class OnRemoveAllItemsFromListEvent extends IncomingInvoiceDetailEvent {}

class OnItemGLAccountChangedEvent extends IncomingInvoiceDetailEvent {
  final String gLAccount;
  final int index;

  OnItemGLAccountChangedEvent({required this.gLAccount, required this.index});
}

class OnItemItemTitleChangedEvent extends IncomingInvoiceDetailEvent {
  final String value;
  final int index;

  OnItemItemTitleChangedEvent({required this.value, required this.index});
}

class OnItemQuantityChangedEvent extends IncomingInvoiceDetailEvent {
  final String value;
  final int index;

  OnItemQuantityChangedEvent({required this.value, required this.index});
}

class OnItemTaxChangedEvent extends IncomingInvoiceDetailEvent {
  final String value;
  final int index;

  OnItemTaxChangedEvent({required this.value, required this.index});
}

class OnItemUnitNetPriceChangedEvent extends IncomingInvoiceDetailEvent {
  final String value;
  final int index;

  OnItemUnitNetPriceChangedEvent({required this.value, required this.index});
}

class OnItemDiscountChangedEvent extends IncomingInvoiceDetailEvent {
  final String value;
  final int index;

  OnItemDiscountChangedEvent({required this.value, required this.index});
}

class OnItemDiscountTypeChangedEvent extends IncomingInvoiceDetailEvent {
  final DiscountType discountType;
  final int index;

  OnItemDiscountTypeChangedEvent({required this.discountType, required this.index});
}

class OnItemsMassEditingEvent extends IncomingInvoiceDetailEvent {
  final String? gLAccount;
  final int? taxRate;

  OnItemsMassEditingEvent({required this.gLAccount, required this.taxRate});
}
