// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'supplier_bloc.dart';

@immutable
class SupplierState {
  final Supplier? supplier;
  final List<Supplier>? listOfAllSuppliers;
  final List<Supplier>? listOfFilteredSuppliers;
  final List<Supplier> selectedSuppliers;
  final AbstractFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingSupplierOnObserve;
  final bool isLoadingSuppliersOnObserve;
  final bool isLoadingSupplierOnCreate;
  final bool isLoadingSupplierOnUpdate;
  final bool isLoadingSupplierOnDelete;
  final Option<Either<AbstractFailure, Supplier>> fosSupplierOnObserveOption;
  final Option<Either<AbstractFailure, List<Supplier>>> fosSuppliersOnObserveOption;
  final Option<Either<AbstractFailure, Supplier>> fosSupplierOnCreateOption;
  final Option<Either<AbstractFailure, Supplier>> fosSupplierOnUpdateOption;
  final Option<Either<List<AbstractFailure>, Unit>> fosSupplierOnDeleteOption;

  //* Helpers
  final bool isAllSuppliersSelected;
  final String supplierSearchText;

  //* Controller
  final TextEditingController companyNameController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController homepageController;
  final TextEditingController phoneController;
  final TextEditingController phoneMobileController;

  const SupplierState({
    required this.supplier,
    required this.listOfAllSuppliers,
    required this.listOfFilteredSuppliers,
    required this.selectedSuppliers,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingSupplierOnObserve,
    required this.isLoadingSuppliersOnObserve,
    required this.isLoadingSupplierOnCreate,
    required this.isLoadingSupplierOnUpdate,
    required this.isLoadingSupplierOnDelete,
    required this.fosSupplierOnObserveOption,
    required this.fosSuppliersOnObserveOption,
    required this.fosSupplierOnCreateOption,
    required this.fosSupplierOnUpdateOption,
    required this.fosSupplierOnDeleteOption,
    required this.isAllSuppliersSelected,
    required this.supplierSearchText,
    required this.companyNameController,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.homepageController,
    required this.phoneController,
    required this.phoneMobileController,
  });

  factory SupplierState.initial() {
    return SupplierState(
      supplier: null,
      listOfAllSuppliers: null,
      listOfFilteredSuppliers: null,
      selectedSuppliers: const [],
      firebaseFailure: null,
      isAnyFailure: false,
      isLoadingSupplierOnObserve: false,
      isLoadingSuppliersOnObserve: true,
      isLoadingSupplierOnCreate: false,
      isLoadingSupplierOnUpdate: false,
      isLoadingSupplierOnDelete: false,
      fosSupplierOnObserveOption: none(),
      fosSuppliersOnObserveOption: none(),
      fosSupplierOnCreateOption: none(),
      fosSupplierOnUpdateOption: none(),
      fosSupplierOnDeleteOption: none(),
      isAllSuppliersSelected: false,
      supplierSearchText: '',
      companyNameController: TextEditingController(),
      firstNameController: TextEditingController(),
      lastNameController: TextEditingController(),
      emailController: TextEditingController(),
      homepageController: TextEditingController(),
      phoneController: TextEditingController(),
      phoneMobileController: TextEditingController(),
    );
  }

  SupplierState copyWith({
    Supplier? supplier,
    List<Supplier>? listOfAllSuppliers,
    List<Supplier>? listOfFilteredSuppliers,
    List<Supplier>? selectedSuppliers,
    AbstractFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingSupplierOnObserve,
    bool? isLoadingSuppliersOnObserve,
    bool? isLoadingSupplierOnCreate,
    bool? isLoadingSupplierOnUpdate,
    bool? isLoadingSupplierOnDelete,
    Option<Either<AbstractFailure, Supplier>>? fosSupplierOnObserveOption,
    Option<Either<AbstractFailure, List<Supplier>>>? fosSuppliersOnObserveOption,
    Option<Either<AbstractFailure, Supplier>>? fosSupplierOnCreateOption,
    Option<Either<AbstractFailure, Supplier>>? fosSupplierOnUpdateOption,
    Option<Either<List<AbstractFailure>, Unit>>? fosSupplierOnDeleteOption,
    bool? isAllSuppliersSelected,
    String? supplierSearchText,
    TextEditingController? companyNameController,
    TextEditingController? firstNameController,
    TextEditingController? lastNameController,
    TextEditingController? emailController,
    TextEditingController? homepageController,
    TextEditingController? phoneController,
    TextEditingController? phoneMobileController,
  }) {
    return SupplierState(
      supplier: supplier ?? this.supplier,
      listOfAllSuppliers: listOfAllSuppliers ?? this.listOfAllSuppliers,
      listOfFilteredSuppliers: listOfFilteredSuppliers ?? this.listOfFilteredSuppliers,
      selectedSuppliers: selectedSuppliers ?? this.selectedSuppliers,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingSupplierOnObserve: isLoadingSupplierOnObserve ?? this.isLoadingSupplierOnObserve,
      isLoadingSuppliersOnObserve: isLoadingSuppliersOnObserve ?? this.isLoadingSuppliersOnObserve,
      isLoadingSupplierOnCreate: isLoadingSupplierOnCreate ?? this.isLoadingSupplierOnCreate,
      isLoadingSupplierOnUpdate: isLoadingSupplierOnUpdate ?? this.isLoadingSupplierOnUpdate,
      isLoadingSupplierOnDelete: isLoadingSupplierOnDelete ?? this.isLoadingSupplierOnDelete,
      fosSupplierOnObserveOption: fosSupplierOnObserveOption ?? this.fosSupplierOnObserveOption,
      fosSuppliersOnObserveOption: fosSuppliersOnObserveOption ?? this.fosSuppliersOnObserveOption,
      fosSupplierOnCreateOption: fosSupplierOnCreateOption ?? this.fosSupplierOnCreateOption,
      fosSupplierOnUpdateOption: fosSupplierOnUpdateOption ?? this.fosSupplierOnUpdateOption,
      fosSupplierOnDeleteOption: fosSupplierOnDeleteOption ?? this.fosSupplierOnDeleteOption,
      isAllSuppliersSelected: isAllSuppliersSelected ?? this.isAllSuppliersSelected,
      supplierSearchText: supplierSearchText ?? this.supplierSearchText,
      companyNameController: companyNameController ?? this.companyNameController,
      firstNameController: firstNameController ?? this.firstNameController,
      lastNameController: lastNameController ?? this.lastNameController,
      emailController: emailController ?? this.emailController,
      homepageController: homepageController ?? this.homepageController,
      phoneController: phoneController ?? this.phoneController,
      phoneMobileController: phoneMobileController ?? this.phoneMobileController,
    );
  }
}
