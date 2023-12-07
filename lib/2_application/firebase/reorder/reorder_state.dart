part of 'reorder_bloc.dart';

@immutable
class ReorderState {
  final Reorder? reorder;
  final List<Reorder>? listOfAllReorders;
  final List<Reorder>? listOfFilteredReorders;
  final List<Reorder> selectedReorders;
  final FirebaseFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingReorderOnObserve;
  final bool isLoadingReordersOnObserve;
  final bool isLoadingReorderOnCreate;
  final bool isLoadingReorderOnUpdate;
  final bool isLoadingReorderOnDelete;
  final Option<Either<FirebaseFailure, Reorder>> fosReorderOnObserveOption;
  final Option<Either<FirebaseFailure, List<Reorder>>> fosReordersOnObserveOption;
  final Option<Either<FirebaseFailure, Reorder>> fosReorderOnCreateOption;
  final Option<Either<FirebaseFailure, Reorder>> fosReorderOnUpdateOption;
  final Option<Either<FirebaseFailure, Unit>> fosReorderOnDeleteOption;

  //* Helpers
  final bool isAllReordersSelected;
  final String reorderSearchText;

  const ReorderState({
    required this.reorder,
    required this.listOfAllReorders,
    required this.listOfFilteredReorders,
    required this.selectedReorders,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingReorderOnObserve,
    required this.isLoadingReordersOnObserve,
    required this.isLoadingReorderOnCreate,
    required this.isLoadingReorderOnUpdate,
    required this.isLoadingReorderOnDelete,
    required this.fosReorderOnObserveOption,
    required this.fosReordersOnObserveOption,
    required this.fosReorderOnCreateOption,
    required this.fosReorderOnUpdateOption,
    required this.fosReorderOnDeleteOption,
    required this.isAllReordersSelected,
    required this.reorderSearchText,
  });

  factory ReorderState.initial() {
    return ReorderState(
      reorder: null,
      listOfAllReorders: null,
      listOfFilteredReorders: null,
      selectedReorders: const [],
      firebaseFailure: null,
      isAnyFailure: false,
      isLoadingReorderOnObserve: false,
      isLoadingReordersOnObserve: false,
      isLoadingReorderOnCreate: false,
      isLoadingReorderOnUpdate: false,
      isLoadingReorderOnDelete: false,
      fosReorderOnObserveOption: none(),
      fosReordersOnObserveOption: none(),
      fosReorderOnCreateOption: none(),
      fosReorderOnUpdateOption: none(),
      fosReorderOnDeleteOption: none(),
      isAllReordersSelected: false,
      reorderSearchText: '',
    );
  }

  ReorderState copyWith({
    Reorder? reorder,
    List<Reorder>? listOfAllReorders,
    List<Reorder>? listOfFilteredReorders,
    List<Reorder>? selectedReorders,
    FirebaseFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingReorderOnObserve,
    bool? isLoadingReordersOnObserve,
    bool? isLoadingReorderOnCreate,
    bool? isLoadingReorderOnUpdate,
    bool? isLoadingReorderOnDelete,
    Option<Either<FirebaseFailure, Reorder>>? fosReorderOnObserveOption,
    Option<Either<FirebaseFailure, List<Reorder>>>? fosReordersOnObserveOption,
    Option<Either<FirebaseFailure, Reorder>>? fosReorderOnCreateOption,
    Option<Either<FirebaseFailure, Reorder>>? fosReorderOnUpdateOption,
    Option<Either<FirebaseFailure, Unit>>? fosReorderOnDeleteOption,
    bool? isAllReordersSelected,
    String? reorderSearchText,
  }) {
    return ReorderState(
      reorder: reorder ?? this.reorder,
      listOfAllReorders: listOfAllReorders ?? this.listOfAllReorders,
      listOfFilteredReorders: listOfFilteredReorders ?? this.listOfFilteredReorders,
      selectedReorders: selectedReorders ?? this.selectedReorders,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingReorderOnObserve: isLoadingReorderOnObserve ?? this.isLoadingReorderOnObserve,
      isLoadingReordersOnObserve: isLoadingReordersOnObserve ?? this.isLoadingReordersOnObserve,
      isLoadingReorderOnCreate: isLoadingReorderOnCreate ?? this.isLoadingReorderOnCreate,
      isLoadingReorderOnUpdate: isLoadingReorderOnUpdate ?? this.isLoadingReorderOnUpdate,
      isLoadingReorderOnDelete: isLoadingReorderOnDelete ?? this.isLoadingReorderOnDelete,
      fosReorderOnObserveOption: fosReorderOnObserveOption ?? this.fosReorderOnObserveOption,
      fosReordersOnObserveOption: fosReordersOnObserveOption ?? this.fosReordersOnObserveOption,
      fosReorderOnCreateOption: fosReorderOnCreateOption ?? this.fosReorderOnCreateOption,
      fosReorderOnUpdateOption: fosReorderOnUpdateOption ?? this.fosReorderOnUpdateOption,
      fosReorderOnDeleteOption: fosReorderOnDeleteOption ?? this.fosReorderOnDeleteOption,
      isAllReordersSelected: isAllReordersSelected ?? this.isAllReordersSelected,
      reorderSearchText: reorderSearchText ?? this.reorderSearchText,
    );
  }
}
