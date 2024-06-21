part of 'customer_detail_bloc.dart';

abstract class CustomerDetailEvent {}

class SetCustomerDetailStatesToInitialEvent extends CustomerDetailEvent {}

class CustomerDetailSetEmptyCustomerEvent extends CustomerDetailEvent {}

class CustomerDetailGetCustomerEvent extends CustomerDetailEvent {
  final String customerId;

  CustomerDetailGetCustomerEvent({required this.customerId});
}

class CustomerDetailSetCustomerEvent extends CustomerDetailEvent {
  final Customer customer;

  CustomerDetailSetCustomerEvent({required this.customer});
}

class CustomerDetailCreateCustomerEvent extends CustomerDetailEvent {}

class CustomerDetailUpdateCustomerEvent extends CustomerDetailEvent {}

//* --- helper --- *//

class CustomerDetailGetCustomerReceiptsEvent extends CustomerDetailEvent {}

class CustomerDetailSetCustomerTaxEvent extends CustomerDetailEvent {
  final Tax tax;

  CustomerDetailSetCustomerTaxEvent({required this.tax});
}

class CustomerDetailInvoiceTypeChangedEvent extends CustomerDetailEvent {
  final CustomerInvoiceType customerInvoiceType;

  CustomerDetailInvoiceTypeChangedEvent({required this.customerInvoiceType});
}

class CustomerDetailUpdateCustomerAddressEvent extends CustomerDetailEvent {
  final Address address;

  CustomerDetailUpdateCustomerAddressEvent({required this.address});
}

class CustomerDetailShownReceiptTypeChangedEvent extends CustomerDetailEvent {
  final ReceiptType type;

  CustomerDetailShownReceiptTypeChangedEvent({required this.type});
}

//* --- Controller --- *//

class CustomerDetailSetControllerEvent extends CustomerDetailEvent {}

class CustomerDetailControllerChangedEvent extends CustomerDetailEvent {}
