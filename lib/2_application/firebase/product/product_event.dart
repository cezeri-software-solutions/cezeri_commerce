part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class SetProductStateToInitialEvent extends ProductEvent {}

class GetAllProductsEvent extends ProductEvent {}

class GetProductEvent extends ProductEvent {
  final String id;

  GetProductEvent({required this.id});
}

class SetProductControllerEvent extends ProductEvent {
  final Product product;

  SetProductControllerEvent({required this.product});
}

class OnProductControllerChangedEvent extends ProductEvent {}

class OnProductDescriptionChangedEvent extends ProductEvent {
  final String? content;

  OnProductDescriptionChangedEvent({required this.content});
}

class OnSaveProductDescriptionEvent extends ProductEvent {}

class GetProductByEanEvent extends ProductEvent {
  final String ean;

  GetProductByEanEvent({required this.ean});
}

class CreateProductEvent extends ProductEvent {
  final Product product;
  final ProductPresta? productPresta;

  CreateProductEvent({required this.product, this.productPresta});
}

class UpdateProductEvent extends ProductEvent {}

class DeleteSelectedProductsEvent extends ProductEvent {
  final List<Product> selectedProducts;

  DeleteSelectedProductsEvent({required this.selectedProducts});
}

class SetSearchFieldTextEvent extends ProductEvent {
  final String searchText;

  SetSearchFieldTextEvent({required this.searchText});
}

class OnSearchFieldSubmittedEvent extends ProductEvent {}

class OnProductSelectedEvent extends ProductEvent {
  final Product product;

  OnProductSelectedEvent({required this.product});
}

class RemoveSelectedProductImages extends ProductEvent {}

class OnPickNewProductPictureEvent extends ProductEvent {}

class OnProductImageSelectedEvent extends ProductEvent {
  final ProductImage image;

  OnProductImageSelectedEvent({required this.image});
}

class OnAllProdcutImagesSelectedEvent extends ProductEvent {
  final bool value;

  OnAllProdcutImagesSelectedEvent({required this.value});
}

class OnReorderProductImagesEvent extends ProductEvent {
  final int oldIndex;
  final int newIndex;

  OnReorderProductImagesEvent({required this.oldIndex, required this.newIndex});
}

//? Update Menge nur in Firebase (Danach wird automatisch OnEditQuantityInMarketplacesEvent getriggert)
class UpdateQuantityOfProductEvent extends ProductEvent {
  final Product product;
  final int newQuantity;

  UpdateQuantityOfProductEvent({required this.product, required this.newQuantity});
}

//? Zum aktivieren von einem Marktplatz bei mehreren ausgewählten Artikeln
class MassEditActivateProductMarketplaceEvent extends ProductEvent {
  final Marketplace marketplace;

  MassEditActivateProductMarketplaceEvent({required this.marketplace});
}

// *#################################################################
// * Prestashop events

class OnEditQuantityInMarketplacesEvent extends ProductEvent {
  final Product product;
  final int newQuantity;

  OnEditQuantityInMarketplacesEvent({required this.product, required this.newQuantity});
}

class OnEditProductInPresta extends ProductEvent {
  final Product product;

  OnEditProductInPresta({required this.product});
}
