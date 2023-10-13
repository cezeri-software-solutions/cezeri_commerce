part of 'customer_bloc.dart';

@immutable
class CustomerState {
  final Customer? customer;
  final List<Customer>? listOfAllCustomers;
  final List<Customer>? listOfFilteredCustomers;
  final List<Customer> selecetedCustomers;
  final FirebaseFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingCustomerOnObserve;
  final bool isLoadingCustomersOnObserve;
  final bool isLoadingCustomerOnCreate;
  final bool isLoadingCustomerOnUpdate;
  final bool isLoadingCustomerOnDelete;
  final Option<Either<FirebaseFailure, Customer>> fosCustomerOnObserveOption;
  final Option<Either<FirebaseFailure, List<Customer>>> fosCustomersOnObserveOption;
  final Option<Either<FirebaseFailure, Customer>> fosCustomerOnCreateOption;
  final Option<Either<FirebaseFailure, Unit>> fosCustomerOnUpdateOption;
  final Option<Either<FirebaseFailure, Unit>> fosCustomerOnDeleteOption;

  //* Helpers
  final String customerSearchText;

  const CustomerState({
    required this.customer,
    required this.listOfAllCustomers,
    required this.listOfFilteredCustomers,
    required this.selecetedCustomers,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingCustomerOnObserve,
    required this.isLoadingCustomersOnObserve,
    required this.isLoadingCustomerOnCreate,
    required this.isLoadingCustomerOnUpdate,
    required this.isLoadingCustomerOnDelete,
    required this.fosCustomerOnObserveOption,
    required this.fosCustomersOnObserveOption,
    required this.fosCustomerOnCreateOption,
    required this.fosCustomerOnUpdateOption,
    required this.fosCustomerOnDeleteOption,
    required this.customerSearchText,
  });

  factory CustomerState.initial() {
    return CustomerState(
      customer: null,
      listOfAllCustomers: null,
      listOfFilteredCustomers: null,
      selecetedCustomers: const [],
      firebaseFailure: null,
      isAnyFailure: false,
      isLoadingCustomerOnObserve: false,
      isLoadingCustomersOnObserve: true,
      isLoadingCustomerOnCreate: false,
      isLoadingCustomerOnUpdate: false,
      isLoadingCustomerOnDelete: false,
      fosCustomerOnObserveOption: none(),
      fosCustomersOnObserveOption: none(),
      fosCustomerOnCreateOption: none(),
      fosCustomerOnUpdateOption: none(),
      fosCustomerOnDeleteOption: none(),
      customerSearchText: '',
    );
  }

  CustomerState copyWith({
    Customer? customer,
    List<Customer>? listOfAllCustomers,
    List<Customer>? listOfFilteredCustomers,
    List<Customer>? selecetedCustomers,
    FirebaseFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingCustomerOnObserve,
    bool? isLoadingCustomersOnObserve,
    bool? isLoadingCustomerOnCreate,
    bool? isLoadingCustomerOnUpdate,
    bool? isLoadingCustomerOnDelete,
    Option<Either<FirebaseFailure, Customer>>? fosCustomerOnObserveOption,
    Option<Either<FirebaseFailure, List<Customer>>>? fosCustomersOnObserveOption,
    Option<Either<FirebaseFailure, Customer>>? fosCustomerOnCreateOption,
    Option<Either<FirebaseFailure, Unit>>? fosCustomerOnUpdateOption,
    Option<Either<FirebaseFailure, Unit>>? fosCustomerOnDeleteOption,
    String? customerSearchText,
  }) {
    return CustomerState(
      customer: customer ?? this.customer,
      listOfAllCustomers: listOfAllCustomers ?? this.listOfAllCustomers,
      listOfFilteredCustomers: listOfFilteredCustomers ?? this.listOfFilteredCustomers,
      selecetedCustomers: selecetedCustomers ?? this.selecetedCustomers,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingCustomerOnObserve: isLoadingCustomerOnObserve ?? this.isLoadingCustomerOnObserve,
      isLoadingCustomersOnObserve: isLoadingCustomersOnObserve ?? this.isLoadingCustomersOnObserve,
      isLoadingCustomerOnCreate: isLoadingCustomerOnCreate ?? this.isLoadingCustomerOnCreate,
      isLoadingCustomerOnUpdate: isLoadingCustomerOnUpdate ?? this.isLoadingCustomerOnUpdate,
      isLoadingCustomerOnDelete: isLoadingCustomerOnDelete ?? this.isLoadingCustomerOnDelete,
      fosCustomerOnObserveOption: fosCustomerOnObserveOption ?? this.fosCustomerOnObserveOption,
      fosCustomersOnObserveOption: fosCustomersOnObserveOption ?? this.fosCustomersOnObserveOption,
      fosCustomerOnCreateOption: fosCustomerOnCreateOption ?? this.fosCustomerOnCreateOption,
      fosCustomerOnUpdateOption: fosCustomerOnUpdateOption ?? this.fosCustomerOnUpdateOption,
      fosCustomerOnDeleteOption: fosCustomerOnDeleteOption ?? this.fosCustomerOnDeleteOption,
      customerSearchText: customerSearchText ?? this.customerSearchText,
    );
  }
}
