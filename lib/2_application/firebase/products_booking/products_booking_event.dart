part of 'products_booking_bloc.dart';

abstract class ProductsBookingEvent {}

class SetProductsBookingStateToInitialEvent extends ProductsBookingEvent {}

class ProductsBookingGetReordersEvent extends ProductsBookingEvent {}

class ProductsBookingFilterReordersEvent extends ProductsBookingEvent {}

class OnProductsBookingSelectAllReorderProductsEvent extends ProductsBookingEvent {
  final bool isSelected;

  OnProductsBookingSelectAllReorderProductsEvent({required this.isSelected});
}

class OnProductsBookingSelectReorderProductEvent extends ProductsBookingEvent {
  final BookingProduct bookingProduct;

  OnProductsBookingSelectReorderProductEvent({required this.bookingProduct});
}

class OnProductsBookingSetBookingProductsFromReorderEvent extends ProductsBookingEvent {}
