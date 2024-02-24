part of 'product_import_bloc.dart';

@immutable
abstract class ProductImportEvent {}

class SetProducImportStateToInitialEvent extends ProductImportEvent {}

class SetSelectedMarketplaceProductImportEvent extends ProductImportEvent {
  final AbstractMarketplace marketplace;

  SetSelectedMarketplaceProductImportEvent({required this.marketplace});
}

class GetAllProductsFromPrestaEvent extends ProductImportEvent {
  final bool onlyActive;

  GetAllProductsFromPrestaEvent({required this.onlyActive});
}

class OnUploadProductToFirestoreEvent extends ProductImportEvent {}

class OnUploadAllProductsToFirestoreEvent extends ProductImportEvent {}

class LoadProductFromMarketplaceEvent extends ProductImportEvent {
  final String value;
  final AbstractMarketplace marketplace;

  LoadProductFromMarketplaceEvent({required this.value, required this.marketplace});
}
