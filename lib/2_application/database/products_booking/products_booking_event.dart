part of 'products_booking_bloc.dart';

abstract class ProductsBookingEvent {}

class SetProductsBookingStateToInitialEvent extends ProductsBookingEvent {}

class ProductsBookingGetReordersEvent extends ProductsBookingEvent {
  final bool afterUpdate;

  ProductsBookingGetReordersEvent({this.afterUpdate = false});
}

class ProductsBookingFilterReordersEvent extends ProductsBookingEvent {}

class ProductsBookingGetProductsEvent extends ProductsBookingEvent {}

class OnProductsBookingSelectAllReorderProductsEvent extends ProductsBookingEvent {
  final bool isSelected;

  OnProductsBookingSelectAllReorderProductsEvent({required this.isSelected});
}

class OnProductsBookingSelectReorderProductEvent extends ProductsBookingEvent {
  final BookingProduct bookingProduct;

  OnProductsBookingSelectReorderProductEvent({required this.bookingProduct});
}

class OnProductsBookingSetBookingProductsFromReorderEvent extends ProductsBookingEvent {}

class OnProductsBookingQuantityControllerChangedEvent extends ProductsBookingEvent {}

class OnProductsBookingRemoveFromSelectedReorderProductsEvent extends ProductsBookingEvent {
  final BookingProduct bookingProduct;

  OnProductsBookingRemoveFromSelectedReorderProductsEvent({required this.bookingProduct});
}

class OnProductsBookingSetReorderFilterEvent extends ProductsBookingEvent {
  final String reorderNumber;

  OnProductsBookingSetReorderFilterEvent({required this.reorderNumber});
}

class OnProductsBookingSaveEvent extends ProductsBookingEvent {}
