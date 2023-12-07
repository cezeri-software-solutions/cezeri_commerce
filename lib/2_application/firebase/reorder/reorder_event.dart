part of 'reorder_bloc.dart';

@immutable
abstract class ReorderEvent {}

class SetReorderStateToInitialEvent extends ReorderEvent {}

class GetAllReordersEvenet extends ReorderEvent {}

class DeleteSelectedReordersEvent extends ReorderEvent {
  final List<Reorder> selectedReorders;

  DeleteSelectedReordersEvent({required this.selectedReorders});
}

class SetSearchFieldTextEvent extends ReorderEvent {
  final String searchText;

  SetSearchFieldTextEvent({required this.searchText});
}

class OnSearchFieldSubmittedEvent extends ReorderEvent {}

//* --- helper --- *//

class OnSelectAllReordersEvent extends ReorderEvent {
  final bool isSelected;

  OnSelectAllReordersEvent({required this.isSelected});
}

class OnReorderSelectedEvent extends ReorderEvent {
  final Reorder reorder;

  OnReorderSelectedEvent({required this.reorder});
}
