part of 'customer_detail_bloc.dart';

class CustomerDetailState {
  final Customer? customer;
  final List<Receipt> listOfCustomerOffers;
  final List<Receipt> listOfCustomerAppointments;
  final List<Receipt> listOfCustomerDeliveryNotes;
  final List<Receipt> listOfCustomerInvoices;
  final AbstractFailure? databaseFailure;
  final bool isLoadingCustomerDetailOnObserve;
  final bool isLoadingCustomerDetailOnCreate;
  final bool isLoadingCustomerDetailOnUpdate;
  final bool isLoadingCustomerDetailOnDelete;
  final Option<Either<AbstractFailure, Customer>> fosCustomerDetailOnObserveOption;
  final Option<Either<AbstractFailure, Customer>> fosCustomerDetailOnCreateOption;
  final Option<Either<AbstractFailure, Customer>> fosCustomerDetailOnUpdateOption;
  final Option<Either<AbstractFailure, Customer>> fosCustomerDetailOnDeleteOption;

  //* Helper Receipts
  final bool isLoadingCustomerDetailOnObserveReceipts;
  final AbstractFailure? receiptsFailure;
  final ReceiptType shownReceiptType;

  //* Controller
  final TextEditingController companyNameController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController phoneMobileController;
  final TextEditingController uidNumberController;
  final TextEditingController taxNumberController;

  const CustomerDetailState({
    required this.customer,
    required this.listOfCustomerOffers,
    required this.listOfCustomerAppointments,
    required this.listOfCustomerDeliveryNotes,
    required this.listOfCustomerInvoices,
    required this.databaseFailure,
    required this.isLoadingCustomerDetailOnObserve,
    required this.isLoadingCustomerDetailOnCreate,
    required this.isLoadingCustomerDetailOnUpdate,
    required this.isLoadingCustomerDetailOnDelete,
    required this.fosCustomerDetailOnObserveOption,
    required this.fosCustomerDetailOnCreateOption,
    required this.fosCustomerDetailOnUpdateOption,
    required this.fosCustomerDetailOnDeleteOption,
    required this.isLoadingCustomerDetailOnObserveReceipts,
    required this.receiptsFailure,
    required this.shownReceiptType,
    required this.companyNameController,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.phoneMobileController,
    required this.uidNumberController,
    required this.taxNumberController,
  });

  factory CustomerDetailState.initial() {
    return CustomerDetailState(
      customer: null,
      listOfCustomerOffers: [],
      listOfCustomerAppointments: [],
      listOfCustomerDeliveryNotes: [],
      listOfCustomerInvoices: [],
      databaseFailure: null,
      isLoadingCustomerDetailOnObserve: false,
      isLoadingCustomerDetailOnCreate: false,
      isLoadingCustomerDetailOnUpdate: false,
      isLoadingCustomerDetailOnDelete: false,
      fosCustomerDetailOnObserveOption: none(),
      fosCustomerDetailOnCreateOption: none(),
      fosCustomerDetailOnUpdateOption: none(),
      fosCustomerDetailOnDeleteOption: none(),
      isLoadingCustomerDetailOnObserveReceipts: false,
      receiptsFailure: null,
      shownReceiptType: ReceiptType.appointment,
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

  CustomerDetailState copyWith({
    Customer? customer,
    List<Receipt>? listOfCustomerOffers,
    List<Receipt>? listOfCustomerAppointments,
    List<Receipt>? listOfCustomerDeliveryNotes,
    List<Receipt>? listOfCustomerInvoices,
    AbstractFailure? databaseFailure,
    bool? isLoadingCustomerDetailOnObserve,
    bool? isLoadingCustomerDetailOnCreate,
    bool? isLoadingCustomerDetailOnUpdate,
    bool? isLoadingCustomerDetailOnDelete,
    Option<Either<AbstractFailure, Customer>>? fosCustomerDetailOnObserveOption,
    Option<Either<AbstractFailure, Customer>>? fosCustomerDetailOnCreateOption,
    Option<Either<AbstractFailure, Customer>>? fosCustomerDetailOnUpdateOption,
    Option<Either<AbstractFailure, Customer>>? fosCustomerDetailOnDeleteOption,
    bool? isLoadingCustomerDetailOnObserveReceipts,
    AbstractFailure? receiptsFailure,
    ReceiptType? shownReceiptType,
    TextEditingController? companyNameController,
    TextEditingController? firstNameController,
    TextEditingController? lastNameController,
    TextEditingController? emailController,
    TextEditingController? phoneController,
    TextEditingController? phoneMobileController,
    TextEditingController? uidNumberController,
    TextEditingController? taxNumberController,
  }) {
    return CustomerDetailState(
      customer: customer ?? this.customer,
      listOfCustomerOffers: listOfCustomerOffers ?? this.listOfCustomerOffers,
      listOfCustomerAppointments: listOfCustomerAppointments ?? this.listOfCustomerAppointments,
      listOfCustomerDeliveryNotes: listOfCustomerDeliveryNotes ?? this.listOfCustomerDeliveryNotes,
      listOfCustomerInvoices: listOfCustomerInvoices ?? this.listOfCustomerInvoices,
      databaseFailure: databaseFailure ?? this.databaseFailure,
      isLoadingCustomerDetailOnObserve: isLoadingCustomerDetailOnObserve ?? this.isLoadingCustomerDetailOnObserve,
      isLoadingCustomerDetailOnCreate: isLoadingCustomerDetailOnCreate ?? this.isLoadingCustomerDetailOnCreate,
      isLoadingCustomerDetailOnUpdate: isLoadingCustomerDetailOnUpdate ?? this.isLoadingCustomerDetailOnUpdate,
      isLoadingCustomerDetailOnDelete: isLoadingCustomerDetailOnDelete ?? this.isLoadingCustomerDetailOnDelete,
      fosCustomerDetailOnObserveOption: fosCustomerDetailOnObserveOption ?? this.fosCustomerDetailOnObserveOption,
      fosCustomerDetailOnCreateOption: fosCustomerDetailOnCreateOption ?? this.fosCustomerDetailOnCreateOption,
      fosCustomerDetailOnUpdateOption: fosCustomerDetailOnUpdateOption ?? this.fosCustomerDetailOnUpdateOption,
      fosCustomerDetailOnDeleteOption: fosCustomerDetailOnDeleteOption ?? this.fosCustomerDetailOnDeleteOption,
      isLoadingCustomerDetailOnObserveReceipts: isLoadingCustomerDetailOnObserveReceipts ?? this.isLoadingCustomerDetailOnObserveReceipts,
      receiptsFailure: receiptsFailure ?? this.receiptsFailure,
      shownReceiptType: shownReceiptType ?? this.shownReceiptType,
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
