part of 'customer_bloc.dart';

@immutable
abstract class CustomerEvent {}

class SetCustomerStateToInitialEvent extends CustomerEvent {}

class GetAllCustomersEvent extends CustomerEvent {}

class GetCustomersPerPageEvent extends CustomerEvent {
  final bool calcCount;
  final int currentPage;

  GetCustomersPerPageEvent({required this.calcCount, required this.currentPage});
}

class DeleteSelectedCustomersEvent extends CustomerEvent {
  final List<Customer> selectedCustomers;

  DeleteSelectedCustomersEvent({required this.selectedCustomers});
}

class CustomerSearchFieldClearedEvent extends CustomerEvent {}

class OnCustomerSelectedEvent extends CustomerEvent {
  final Customer customer;

  OnCustomerSelectedEvent({required this.customer});
}

//* --- helper --- *//

class CustomerItemsPerPageChangedEvent extends CustomerEvent {
  final int value;

  CustomerItemsPerPageChangedEvent({required this.value});
}

class OnSelectAllCustomersEvent extends CustomerEvent {
  final bool isSelected;

  OnSelectAllCustomersEvent({required this.isSelected});
}

class OnCustomerselectedEvent extends CustomerEvent {
  final Customer appointment;

  OnCustomerselectedEvent({required this.appointment});
}
