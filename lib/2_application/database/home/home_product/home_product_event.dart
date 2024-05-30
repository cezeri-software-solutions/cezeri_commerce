part of 'home_product_bloc.dart';

abstract class HomeProductEvent {}

class SetHomeProductStateToInitailEvent extends HomeProductEvent {}

class GetHomeProductsOutletProductsEvent extends HomeProductEvent {}

class GetHomeProductSoldOutProductsEvent extends HomeProductEvent {}

class GetHomeProductUnderMinimumQuantityProductsEvent extends HomeProductEvent {}

class GetHomeReordersEvent extends HomeProductEvent {}

class OnHomeProductShowProductsByChangedEvent extends HomeProductEvent {
  final ShowProductsBy showProductsBy;

  OnHomeProductShowProductsByChangedEvent({required this.showProductsBy});
}

class OnHomeProductGroupProductsByChangedEvent extends HomeProductEvent {
  final GroupProductsBy groupProductsBy;

  OnHomeProductGroupProductsByChangedEvent({required this.groupProductsBy});
}

class GenerateProductHomeProductsEvent extends HomeProductEvent {}

//* Helpers isExpanded

class OnHomeProductIsExpandedOutletChangedEvent extends HomeProductEvent {}

class OnHomeProductIsExpandedSoldOutChangedEvent extends HomeProductEvent {}
