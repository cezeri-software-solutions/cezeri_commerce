part of 'reorder_bloc.dart';

@immutable
abstract class ReorderEvent {}

class SetReorderStateToInitialEvent extends ReorderEvent {}

class GetReordersEvenet extends ReorderEvent {
  final int tabValue;

  GetReordersEvenet({required this.tabValue});
}

class DeleteSelectedReordersEvent extends ReorderEvent {}

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

class OnReorderGetAllSuppliersEvent extends ReorderEvent {}

//* --- controller ---*//

class OnReorderSetFilteredSuppliersEvent extends ReorderEvent {}

class OnReorderSupplierSearchTextClearedEvent extends ReorderEvent {}
