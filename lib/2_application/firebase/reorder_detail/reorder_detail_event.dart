part of 'reorder_detail_bloc.dart';

abstract class ReorderDetailEvent {}

class SetReorderDetailStateToInitialEvent extends ReorderDetailEvent {}

class SetReorderDetailEvent extends ReorderDetailEvent {
  final Supplier? supplier;
  final ReorderCreateOrEdit reorderCreateOrEdit;
  final String? reorderId;

  SetReorderDetailEvent({required this.supplier, required this.reorderCreateOrEdit, required this.reorderId});
}

class OnReorderDetailGetProductsEvent extends ReorderDetailEvent {}

//* Controllers

class SetReorderDetailControllersEvent extends ReorderDetailEvent {}

class OnReorderDetailControllerChangedEvent extends ReorderDetailEvent {}

//* Products

class OnReorderDetailSetFilteredProductsEvent extends ReorderDetailEvent {}

class OnReorderDetailProductSearchTextClearedEvent extends ReorderDetailEvent {}

class OnReorderDeatilAddProductEvent extends ReorderDetailEvent {
  final Product product;

  OnReorderDeatilAddProductEvent({required this.product});
}

class ReorderDetailSetAllProductControllersEvent extends ReorderDetailEvent {}
