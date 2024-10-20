part of 'incoming_invoice_bloc.dart';

abstract class IncomingInvoiceEvent {}

class SetIncomingInvoiceStateToInitial extends IncomingInvoiceEvent {}

class GetIncomingInvoiceEvent extends IncomingInvoiceEvent {
  final String id;

  GetIncomingInvoiceEvent({required this.id});
}

class GetIncomingInvoicesEvent extends IncomingInvoiceEvent {
  final bool calcCount;
  final int currentPage;

  GetIncomingInvoicesEvent({required this.calcCount, required this.currentPage});
}

class DeleteSelectedInvoicesEvent extends IncomingInvoiceEvent {}

class OnInvoiceSearchControllerClearedEvent extends IncomingInvoiceEvent {}

//* --- helper --- *//

class OnSelectAllInvoicesEvent extends IncomingInvoiceEvent {
  final bool isSelected;

  OnSelectAllInvoicesEvent({required this.isSelected});
}

class OnSelectInvoiceEvent extends IncomingInvoiceEvent {
  final IncomingInvoice invoice;

  OnSelectInvoiceEvent({required this.invoice});
}

class ItemsPerPageChangedEvent extends IncomingInvoiceEvent {
  final int value;

  ItemsPerPageChangedEvent({required this.value});
}
