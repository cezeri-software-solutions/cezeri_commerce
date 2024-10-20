part of 'customer_bloc.dart';

@immutable
class CustomerState {
  final List<Customer>? listOfAllCustomers;
  final List<Customer> selectedCustomers;
  final AbstractFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingCustomersOnObserve;
  final bool isLoadingCustomerOnCreate;
  final bool isLoadingCustomerOnUpdate;
  final bool isLoadingCustomerOnDelete;
  final bool isLoadingCustomerMainSettingsOnObserve;
  final Option<Either<AbstractFailure, List<Customer>>> fosCustomersOnObserveOption;
  final Option<Either<AbstractFailure, Customer>> fosCustomerOnUpdateOption;
  final Option<Either<List<AbstractFailure>, Unit>> fosCustomersOnDeleteOption;

  //* Helpers
  final int perPageQuantity;
  final int totalQuantity;
  final int currentPage;
  final bool isAllCustomersSelected;
  final SearchController customerSearchController;

  const CustomerState({
    required this.listOfAllCustomers,
    required this.selectedCustomers,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingCustomersOnObserve,
    required this.isLoadingCustomerOnCreate,
    required this.isLoadingCustomerOnUpdate,
    required this.isLoadingCustomerOnDelete,
    required this.isLoadingCustomerMainSettingsOnObserve,
    required this.fosCustomersOnObserveOption,
    required this.fosCustomerOnUpdateOption,
    required this.fosCustomersOnDeleteOption,
    required this.perPageQuantity,
    required this.totalQuantity,
    required this.currentPage,
    required this.isAllCustomersSelected,
    required this.customerSearchController,
  });

  factory CustomerState.initial() {
    return CustomerState(
      listOfAllCustomers: null,
      selectedCustomers: const [],
      firebaseFailure: null,
      isAnyFailure: false,
      isLoadingCustomersOnObserve: true,
      isLoadingCustomerOnCreate: false,
      isLoadingCustomerOnUpdate: false,
      isLoadingCustomerOnDelete: false,
      isLoadingCustomerMainSettingsOnObserve: false,
      fosCustomersOnObserveOption: none(),
      fosCustomerOnUpdateOption: none(),
      fosCustomersOnDeleteOption: none(),
      perPageQuantity: 20,
      totalQuantity: 1,
      currentPage: 1,
      isAllCustomersSelected: false,
      customerSearchController: SearchController(),
    );
  }

  CustomerState copyWith({
    List<Customer>? listOfAllCustomers,
    List<Customer>? selectedCustomers,
    AbstractFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingCustomersOnObserve,
    bool? isLoadingCustomerOnCreate,
    bool? isLoadingCustomerOnUpdate,
    bool? isLoadingCustomerOnDelete,
    bool? isLoadingCustomerMainSettingsOnObserve,
    Option<Either<AbstractFailure, List<Customer>>>? fosCustomersOnObserveOption,
    Option<Either<AbstractFailure, Customer>>? fosCustomerOnUpdateOption,
    Option<Either<List<AbstractFailure>, Unit>>? fosCustomersOnDeleteOption,
    int? perPageQuantity,
    int? totalQuantity,
    int? currentPage,
    bool? isAllCustomersSelected,
    SearchController? customerSearchController,
  }) {
    return CustomerState(
      listOfAllCustomers: listOfAllCustomers ?? this.listOfAllCustomers,
      selectedCustomers: selectedCustomers ?? this.selectedCustomers,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingCustomersOnObserve: isLoadingCustomersOnObserve ?? this.isLoadingCustomersOnObserve,
      isLoadingCustomerOnCreate: isLoadingCustomerOnCreate ?? this.isLoadingCustomerOnCreate,
      isLoadingCustomerOnUpdate: isLoadingCustomerOnUpdate ?? this.isLoadingCustomerOnUpdate,
      isLoadingCustomerOnDelete: isLoadingCustomerOnDelete ?? this.isLoadingCustomerOnDelete,
      isLoadingCustomerMainSettingsOnObserve: isLoadingCustomerMainSettingsOnObserve ?? this.isLoadingCustomerMainSettingsOnObserve,
      fosCustomersOnObserveOption: fosCustomersOnObserveOption ?? this.fosCustomersOnObserveOption,
      fosCustomerOnUpdateOption: fosCustomerOnUpdateOption ?? this.fosCustomerOnUpdateOption,
      fosCustomersOnDeleteOption: fosCustomersOnDeleteOption ?? this.fosCustomersOnDeleteOption,
      perPageQuantity: perPageQuantity ?? this.perPageQuantity,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      currentPage: currentPage ?? this.currentPage,
      isAllCustomersSelected: isAllCustomersSelected ?? this.isAllCustomersSelected,
      customerSearchController: customerSearchController ?? this.customerSearchController,
    );
  }
}
