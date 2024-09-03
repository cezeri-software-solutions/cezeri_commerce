part of 'reorder_bloc.dart';

@immutable
class ReorderState {
  final Reorder? reorder;
  final List<Reorder>? listOfAllReorders;
  final List<Reorder>? listOfFilteredReorders;
  final List<Supplier> listOfSuppliers;
  final List<Supplier> listOfFilteredSuppliers;
  final List<Reorder> selectedReorders;
  final AbstractFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingReorderOnObserve;
  final bool isLoadingReordersOnObserve;
  final bool isLoadingReorderOnCreate;
  final bool isLoadingReorderOnUpdate;
  final bool isLoadingReorderOnDelete;
  final bool isLoadingReorderSuppliersOnObserve;
  final Option<Either<AbstractFailure, Reorder>> fosReorderOnObserveOption;
  final Option<Either<AbstractFailure, List<Reorder>>> fosReordersOnObserveOption;
  final Option<Either<AbstractFailure, Reorder>> fosReorderOnCreateOption;
  final Option<Either<AbstractFailure, Reorder>> fosReorderOnUpdateOption;
  final Option<Either<AbstractFailure, Unit>> fosReorderOnDeleteOption;
  final Option<Either<AbstractFailure, Unit>> fosReordersOnDeleteOption;
  final Option<Either<AbstractFailure, List<Supplier>>> fosReorderOnObserveSuppliersOption;

  //* Helpers
  final bool isAllReordersSelected;
  final String reorderSearchText;
  final int tabValue;

  //* Controllers
  final TextEditingController supplierSearchController;

  const ReorderState({
    required this.reorder,
    required this.listOfAllReorders,
    required this.listOfFilteredReorders,
    required this.listOfSuppliers,
    required this.listOfFilteredSuppliers,
    required this.selectedReorders,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingReorderOnObserve,
    required this.isLoadingReordersOnObserve,
    required this.isLoadingReorderOnCreate,
    required this.isLoadingReorderOnUpdate,
    required this.isLoadingReorderOnDelete,
    required this.isLoadingReorderSuppliersOnObserve,
    required this.fosReorderOnObserveOption,
    required this.fosReordersOnObserveOption,
    required this.fosReorderOnCreateOption,
    required this.fosReorderOnUpdateOption,
    required this.fosReorderOnDeleteOption,
    required this.fosReordersOnDeleteOption,
    required this.fosReorderOnObserveSuppliersOption,
    required this.isAllReordersSelected,
    required this.reorderSearchText,
    required this.tabValue,
    required this.supplierSearchController,
  });

  factory ReorderState.initial() {
    return ReorderState(
      reorder: null,
      listOfAllReorders: null,
      listOfFilteredReorders: null,
      listOfSuppliers: const [],
      listOfFilteredSuppliers: const [],
      selectedReorders: const [],
      firebaseFailure: null,
      isAnyFailure: false,
      isLoadingReorderOnObserve: false,
      isLoadingReordersOnObserve: false,
      isLoadingReorderOnCreate: false,
      isLoadingReorderOnUpdate: false,
      isLoadingReorderOnDelete: false,
      isLoadingReorderSuppliersOnObserve: false,
      fosReorderOnObserveOption: none(),
      fosReordersOnObserveOption: none(),
      fosReorderOnCreateOption: none(),
      fosReorderOnUpdateOption: none(),
      fosReorderOnDeleteOption: none(),
      fosReordersOnDeleteOption: none(),
      fosReorderOnObserveSuppliersOption: none(),
      isAllReordersSelected: false,
      reorderSearchText: '',
      tabValue: 0,
      supplierSearchController: TextEditingController(),
    );
  }

  ReorderState copyWith({
    Reorder? reorder,
    List<Reorder>? listOfAllReorders,
    List<Reorder>? listOfFilteredReorders,
    List<Supplier>? listOfSuppliers,
    List<Supplier>? listOfFilteredSuppliers,
    List<Reorder>? selectedReorders,
    AbstractFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingReorderOnObserve,
    bool? isLoadingReordersOnObserve,
    bool? isLoadingReorderOnCreate,
    bool? isLoadingReorderOnUpdate,
    bool? isLoadingReorderOnDelete,
    bool? isLoadingReorderSuppliersOnObserve,
    Option<Either<AbstractFailure, Reorder>>? fosReorderOnObserveOption,
    Option<Either<AbstractFailure, List<Reorder>>>? fosReordersOnObserveOption,
    Option<Either<AbstractFailure, Reorder>>? fosReorderOnCreateOption,
    Option<Either<AbstractFailure, Reorder>>? fosReorderOnUpdateOption,
    Option<Either<AbstractFailure, Unit>>? fosReorderOnDeleteOption,
    Option<Either<AbstractFailure, Unit>>? fosReordersOnDeleteOption,
    Option<Either<AbstractFailure, List<Supplier>>>? fosReorderOnObserveSuppliersOption,
    bool? isAllReordersSelected,
    String? reorderSearchText,
    int? tabValue,
    TextEditingController? supplierSearchController,
  }) {
    return ReorderState(
      reorder: reorder ?? this.reorder,
      listOfAllReorders: listOfAllReorders ?? this.listOfAllReorders,
      listOfFilteredReorders: listOfFilteredReorders ?? this.listOfFilteredReorders,
      listOfSuppliers: listOfSuppliers ?? this.listOfSuppliers,
      listOfFilteredSuppliers: listOfFilteredSuppliers ?? this.listOfFilteredSuppliers,
      selectedReorders: selectedReorders ?? this.selectedReorders,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingReorderOnObserve: isLoadingReorderOnObserve ?? this.isLoadingReorderOnObserve,
      isLoadingReordersOnObserve: isLoadingReordersOnObserve ?? this.isLoadingReordersOnObserve,
      isLoadingReorderOnCreate: isLoadingReorderOnCreate ?? this.isLoadingReorderOnCreate,
      isLoadingReorderOnUpdate: isLoadingReorderOnUpdate ?? this.isLoadingReorderOnUpdate,
      isLoadingReorderOnDelete: isLoadingReorderOnDelete ?? this.isLoadingReorderOnDelete,
      isLoadingReorderSuppliersOnObserve: isLoadingReorderSuppliersOnObserve ?? this.isLoadingReorderSuppliersOnObserve,
      fosReorderOnObserveOption: fosReorderOnObserveOption ?? this.fosReorderOnObserveOption,
      fosReordersOnObserveOption: fosReordersOnObserveOption ?? this.fosReordersOnObserveOption,
      fosReorderOnCreateOption: fosReorderOnCreateOption ?? this.fosReorderOnCreateOption,
      fosReorderOnUpdateOption: fosReorderOnUpdateOption ?? this.fosReorderOnUpdateOption,
      fosReorderOnDeleteOption: fosReorderOnDeleteOption ?? this.fosReorderOnDeleteOption,
      fosReordersOnDeleteOption: fosReordersOnDeleteOption ?? this.fosReordersOnDeleteOption,
      fosReorderOnObserveSuppliersOption: fosReorderOnObserveSuppliersOption ?? this.fosReorderOnObserveSuppliersOption,
      isAllReordersSelected: isAllReordersSelected ?? this.isAllReordersSelected,
      reorderSearchText: reorderSearchText ?? this.reorderSearchText,
      tabValue: tabValue ?? this.tabValue,
      supplierSearchController: supplierSearchController ?? this.supplierSearchController,
    );
  }
}
