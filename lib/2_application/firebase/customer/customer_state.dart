part of 'customer_bloc.dart';

@immutable
class CustomerState {
  final Customer? customer;
  final List<Customer>? listOfAllCustomers;
  final List<Customer>? listOfFilteredCustomers;
  final List<Customer> selectedCustomers;
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
  final Option<Either<FirebaseFailure, Customer>> fosCustomerOnUpdateOption;
  final Option<Either<FirebaseFailure, Unit>> fosCustomerOnDeleteOption;

  //* Helpers
  final bool isAllCustomersSelected;
  final String customerSearchText;

  //* Controller
  final TextEditingController companyNameController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController phoneMobileController;
  final TextEditingController uidNumberController;
  final TextEditingController taxNumberController;

  const CustomerState({
    required this.customer,
    required this.listOfAllCustomers,
    required this.listOfFilteredCustomers,
    required this.selectedCustomers,
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
    required this.isAllCustomersSelected,
    required this.customerSearchText,
    required this.companyNameController,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.phoneMobileController,
    required this.uidNumberController,
    required this.taxNumberController,
  });

  factory CustomerState.initial() {
    return CustomerState(
      customer: null,
      listOfAllCustomers: null,
      listOfFilteredCustomers: null,
      selectedCustomers: const [],
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
      isAllCustomersSelected: false,
      customerSearchText: '',
      companyNameController: TextEditingController(),
      firstNameController: TextEditingController(),
      lastNameController: TextEditingController(),
      emailController: TextEditingController(),
      phoneController: TextEditingController(),
      phoneMobileController: TextEditingController(),
      uidNumberController: TextEditingController(),
      taxNumberController: TextEditingController(),
    );
  }

  CustomerState copyWith({
    Customer? customer,
    List<Customer>? listOfAllCustomers,
    List<Customer>? listOfFilteredCustomers,
    List<Customer>? selectedCustomers,
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
    Option<Either<FirebaseFailure, Customer>>? fosCustomerOnUpdateOption,
    Option<Either<FirebaseFailure, Unit>>? fosCustomerOnDeleteOption,
    bool? isAllCustomersSelected,
    String? customerSearchText,
    TextEditingController? companyNameController,
    TextEditingController? firstNameController,
    TextEditingController? lastNameController,
    TextEditingController? emailController,
    TextEditingController? phoneController,
    TextEditingController? phoneMobileController,
    TextEditingController? uidNumberController,
    TextEditingController? taxNumberController,
  }) {
    return CustomerState(
      customer: customer ?? this.customer,
      listOfAllCustomers: listOfAllCustomers ?? this.listOfAllCustomers,
      listOfFilteredCustomers: listOfFilteredCustomers ?? this.listOfFilteredCustomers,
      selectedCustomers: selectedCustomers ?? this.selectedCustomers,
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
      isAllCustomersSelected: isAllCustomersSelected ?? this.isAllCustomersSelected,
      customerSearchText: customerSearchText ?? this.customerSearchText,
      companyNameController: companyNameController ?? this.companyNameController,
      firstNameController: firstNameController ?? this.firstNameController,
      lastNameController: lastNameController ?? this.lastNameController,
      emailController: emailController ?? this.emailController,
      phoneController: phoneController ?? this.phoneController,
      phoneMobileController: phoneMobileController ?? this.phoneMobileController,
      uidNumberController: uidNumberController ?? this.uidNumberController,
      taxNumberController: taxNumberController ?? this.taxNumberController,
    );
  }
}
