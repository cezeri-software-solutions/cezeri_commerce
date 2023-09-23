part of 'product_import_bloc.dart';

@immutable
abstract class ProductImportEvent {}

class SetProducImportStateToInitialEvent extends ProductImportEvent {}

class GetAllProductsFromPrestaEvent extends ProductImportEvent {}

class GetProductByIdFromPrestaEvent extends ProductImportEvent {
  final int id;
  final Marketplace marketplace;

  GetProductByIdFromPrestaEvent({required this.id, required this.marketplace});
}
