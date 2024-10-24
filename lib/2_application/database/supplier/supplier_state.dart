part of 'supplier_bloc.dart';

@immutable
class SupplierState {
  final Supplier? supplier;
  final List<Supplier>? listOfAllSuppliers;
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
  final int perPageQuantity;
  final int totalQuantity;
  final int currentPage;
  final bool isAllSuppliersSelected;

  //* Controller
  final SearchController searchController; 
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
    required this.perPageQuantity,
    required this.totalQuantity,
    required this.currentPage,
    required this.isAllSuppliersSelected,
    required this.searchController,
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
      perPageQuantity: 20,
      totalQuantity: 1,
      currentPage: 1,
      isAllSuppliersSelected: false,
      searchController: SearchController(),
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
    int? perPageQuantity,
    int? totalQuantity,
    int? currentPage,
    bool? isAllSuppliersSelected,
    SearchController? searchController,
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
      perPageQuantity: perPageQuantity ?? this.perPageQuantity,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      currentPage: currentPage ?? this.currentPage,
      isAllSuppliersSelected: isAllSuppliersSelected ?? this.isAllSuppliersSelected,
      searchController: searchController ?? this.searchController,
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
