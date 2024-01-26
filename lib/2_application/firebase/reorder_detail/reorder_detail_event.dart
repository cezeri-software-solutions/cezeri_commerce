part of 'reorder_detail_bloc.dart';

abstract class ReorderDetailEvent {}

class SetReorderDetailStateToInitialEvent extends ReorderDetailEvent {}

class ReorderDetailCreateReorderEvent extends ReorderDetailEvent {}

class ReorderDetailUpdateReorderEvent extends ReorderDetailEvent {}

class SetReorderDetailEvent extends ReorderDetailEvent {
  final Supplier? supplier;
  final ReorderCreateOrEdit reorderCreateOrEdit;
  final String? reorderId;

  SetReorderDetailEvent({required this.supplier, required this.reorderCreateOrEdit, required this.reorderId});
}

class OnReorderDetailGetProductsEvent extends ReorderDetailEvent {}

class OnReorderDetailClosedManuallyChangeEvent extends ReorderDetailEvent {
  final bool value;

  OnReorderDetailClosedManuallyChangeEvent({required this.value});
}

//* Helpers

class OnReorderDetailGetPdfDataEvent extends ReorderDetailEvent {}

class OnReorderDetailSetStatProductFromDateEvent extends ReorderDetailEvent {
  final DateTimeRange dateRange;

  OnReorderDetailSetStatProductFromDateEvent({required this.dateRange});
}

class OnReorderDetailSetLoadAllProductsEvent extends ReorderDetailEvent {}

//* Controllers

class SetReorderDetailControllersEvent extends ReorderDetailEvent {}

class OnReorderDetailControllerChangedEvent extends ReorderDetailEvent {}

class OnReorderDetailControllerClearedEvent extends ReorderDetailEvent {}

//* Products

class OnReorderDetailSetFilteredProductsEvent extends ReorderDetailEvent {}

class OnReorderDetailProductSearchTextClearedEvent extends ReorderDetailEvent {}

class OnReorderDeatilAddProductEvent extends ReorderDetailEvent {
  final Product product;
  final int quantity;

  OnReorderDeatilAddProductEvent({required this.product, required this.quantity});
}

class OnReorderDeatilAddEmptyProductEvent extends ReorderDetailEvent {}

class OnReorderDeatilRemoveProductEvent extends ReorderDetailEvent {
  final int index;

  OnReorderDeatilRemoveProductEvent({required this.index});
}

class ReorderDetailSetAllProductControllersEvent extends ReorderDetailEvent {}

class OnReorderDetailPosControllerChangedEvent extends ReorderDetailEvent {}
