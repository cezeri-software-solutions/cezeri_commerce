part of 'customer_bloc.dart';

@immutable
class CustomerState {
  final Customer? customer;
  final List<Customer>? listOfAllCustomers;
  final List<Customer>? listOfFilteredCustomers;
  final List<Customer> selectedCustomers;
  final AbstractFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingCustomerOnObserve;
  final bool isLoadingCustomersOnObserve;
  final bool isLoadingCustomerOnCreate;
  final bool isLoadingCustomerOnUpdate;
  final bool isLoadingCustomerOnDelete;
  final bool isLoadingCustomerMainSettingsOnObserve;
  final Option<Either<AbstractFailure, Customer>> fosCustomerOnObserveOption;
  final Option<Either<AbstractFailure, List<Customer>>> fosCustomersOnObserveOption;
  final Option<Either<AbstractFailure, Customer>> fosCustomerOnCreateOption;
  final Option<Either<AbstractFailure, Customer>> fosCustomerOnUpdateOption;
  final Option<Either<List<AbstractFailure>, Unit>> fosCustomersOnDeleteOption;
  final Option<Either<AbstractFailure, MainSettings>> fosCustomerMainSettingsOnObserveOption;

  //* Helpers
  final int perPageQuantity;
  final int totalQuantity;
  final int currentPage;
  final bool isAllCustomersSelected;
  final SearchController customerSearchController;

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
    required this.isLoadingCustomerMainSettingsOnObserve,
    required this.fosCustomerOnObserveOption,
    required this.fosCustomersOnObserveOption,
    required this.fosCustomerOnCreateOption,
    required this.fosCustomerOnUpdateOption,
    required this.fosCustomersOnDeleteOption,
    required this.fosCustomerMainSettingsOnObserveOption,
    required this.perPageQuantity,
    required this.totalQuantity,
    required this.currentPage,
    required this.isAllCustomersSelected,
    required this.customerSearchController,
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
      isLoadingCustomerMainSettingsOnObserve: false,
      fosCustomerOnObserveOption: none(),
      fosCustomersOnObserveOption: none(),
      fosCustomerOnCreateOption: none(),
      fosCustomerOnUpdateOption: none(),
      fosCustomersOnDeleteOption: none(),
      fosCustomerMainSettingsOnObserveOption: none(),
      perPageQuantity: 20,
      totalQuantity: 0,
      currentPage: 1,
      isAllCustomersSelected: false,
      customerSearchController: SearchController(),
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
    AbstractFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingCustomerOnObserve,
    bool? isLoadingCustomersOnObserve,
    bool? isLoadingCustomerOnCreate,
    bool? isLoadingCustomerOnUpdate,
    bool? isLoadingCustomerOnDelete,
    bool? isLoadingCustomerMainSettingsOnObserve,
    Option<Either<AbstractFailure, Customer>>? fosCustomerOnObserveOption,
    Option<Either<AbstractFailure, List<Customer>>>? fosCustomersOnObserveOption,
    Option<Either<AbstractFailure, Customer>>? fosCustomerOnCreateOption,
    Option<Either<AbstractFailure, Customer>>? fosCustomerOnUpdateOption,
    Option<Either<List<AbstractFailure>, Unit>>? fosCustomersOnDeleteOption,
    Option<Either<AbstractFailure, MainSettings>>? fosCustomerMainSettingsOnObserveOption,
    int? perPageQuantity,
    int? totalQuantity,
    int? currentPage,
    bool? isAllCustomersSelected,
    SearchController? customerSearchController,
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
      isLoadingCustomerMainSettingsOnObserve: isLoadingCustomerMainSettingsOnObserve ?? this.isLoadingCustomerMainSettingsOnObserve,
      fosCustomerOnObserveOption: fosCustomerOnObserveOption ?? this.fosCustomerOnObserveOption,
      fosCustomersOnObserveOption: fosCustomersOnObserveOption ?? this.fosCustomersOnObserveOption,
      fosCustomerOnCreateOption: fosCustomerOnCreateOption ?? this.fosCustomerOnCreateOption,
      fosCustomerOnUpdateOption: fosCustomerOnUpdateOption ?? this.fosCustomerOnUpdateOption,
      fosCustomersOnDeleteOption: fosCustomersOnDeleteOption ?? this.fosCustomersOnDeleteOption,
      fosCustomerMainSettingsOnObserveOption: fosCustomerMainSettingsOnObserveOption ?? this.fosCustomerMainSettingsOnObserveOption,
      perPageQuantity: perPageQuantity ?? this.perPageQuantity,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      currentPage: currentPage ?? this.currentPage,
      isAllCustomersSelected: isAllCustomersSelected ?? this.isAllCustomersSelected,
      customerSearchController: customerSearchController ?? this.customerSearchController,
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
