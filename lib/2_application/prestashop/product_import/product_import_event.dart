part of 'product_import_bloc.dart';

@immutable
abstract class ProductImportEvent {}

class SetProducImportStateToInitialEvent extends ProductImportEvent {}

class SetSelectedMarketplaceProductImportEvent extends ProductImportEvent {
  final Marketplace marketplace;

  SetSelectedMarketplaceProductImportEvent({required this.marketplace});
}

class GetAllProductsFromPrestaEvent extends ProductImportEvent {
  final bool onlyActive;

  GetAllProductsFromPrestaEvent({required this.onlyActive});
}

class OnUploadProductToFirestoreEvent extends ProductImportEvent {}

class OnUploadAllProductsToFirestoreEvent extends ProductImportEvent {}

class GetProductByIdAsJsonFromPrestaEvent extends ProductImportEvent {
  final int id;
  final Marketplace marketplace;

  GetProductByIdAsJsonFromPrestaEvent({required this.id, required this.marketplace});
}
