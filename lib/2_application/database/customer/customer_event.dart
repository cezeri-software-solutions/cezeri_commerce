part of 'customer_bloc.dart';

@immutable
abstract class CustomerEvent {}

class SetCustomerStateToInitialEvent extends CustomerEvent {}

class GetAllCustomersEvent extends CustomerEvent {}

class GetCustomerEvent extends CustomerEvent {
  final Customer customer;

  GetCustomerEvent({required this.customer});
}

class SetEmptyCustomerOnCreateNewCustomerEvent extends CustomerEvent {}

class CreateCustomerEvent extends CustomerEvent {}

class UpdateCustomerEvent extends CustomerEvent {}

class DeleteSelectedCustomersEvent extends CustomerEvent {
  final List<Customer> selectedCustomers;

  DeleteSelectedCustomersEvent({required this.selectedCustomers});
}

class SetSearchFieldTextEvent extends CustomerEvent {
  final String searchText;

  SetSearchFieldTextEvent({required this.searchText});
}

class OnSearchFieldSubmittedEvent extends CustomerEvent {}

class OnCustomerSelectedEvent extends CustomerEvent {
  final Customer customer;

  OnCustomerSelectedEvent({required this.customer});
}

class SetCustomerTaxEvent extends CustomerEvent {
  final Tax tax;

  SetCustomerTaxEvent({required this.tax});
}

//* --- helper --- *//

class OnSelectAllCustomersEvent extends CustomerEvent {
  final bool isSelected;

  OnSelectAllCustomersEvent({required this.isSelected});
}

class OnCustomerselectedEvent extends CustomerEvent {
  final Customer appointment;

  OnCustomerselectedEvent({required this.appointment});
}

class OnCustomerInvoiceTypeChangedEvent extends CustomerEvent {
  final CustomerInvoiceType customerInvoiceType;

  OnCustomerInvoiceTypeChangedEvent({required this.customerInvoiceType});
}

class OnAddEditCustomerAddressEvent extends CustomerEvent {
  final Address address;

  OnAddEditCustomerAddressEvent({required this.address});
}

//* --- Controller --- *//

class SetCustomerControllerEvent extends CustomerEvent {}

class OnCustomerControllerChangedEvent extends CustomerEvent {}
