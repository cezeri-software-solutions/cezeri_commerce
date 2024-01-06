part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class SetProductStateToInitialEvent extends ProductEvent {}

class GetAllProductsEvent extends ProductEvent {}

class GetProductEvent extends ProductEvent {
  final String id;

  GetProductEvent({required this.id});
}

class DeleteSelectedProductsEvent extends ProductEvent {
  final List<Product> selectedProducts;

  DeleteSelectedProductsEvent({required this.selectedProducts});
}

class OnProductSearchControllerClearedEvent extends ProductEvent {}

class OnSearchFieldSubmittedEvent extends ProductEvent {}

class OnProductIsSelectedAllChangedEvent extends ProductEvent {
  final bool isSelected;

  OnProductIsSelectedAllChangedEvent({required this.isSelected});
}

class OnProductSelectedEvent extends ProductEvent {
  final Product product;

  OnProductSelectedEvent({required this.product});
}

class OnProductGetSuppliersEvent extends ProductEvent {}

class SetProductsWidthSearchEvent extends ProductEvent {
  final bool value;

  SetProductsWidthSearchEvent({required this.value});
}

class SetProductIsLoadingPdfEvent extends ProductEvent {
  final bool value;

  SetProductIsLoadingPdfEvent({required this.value});
}

//? Update Menge nur in Firebase (Danach wird automatisch OnEditQuantityInMarketplacesEvent getriggert)
class UpdateQuantityOfProductEvent extends ProductEvent {
  final Product product;
  final int newQuantity;
  final bool updateOnlyAvailableQuantity;

  UpdateQuantityOfProductEvent({required this.product, required this.newQuantity, required this.updateOnlyAvailableQuantity});
}

// * #################################################################################################################################
// * Massenbearbeitung

//TODO: aktuell deaktiviert
//? Zum aktivieren von einem Marktplatz bei mehreren ausgewählten Artikeln
class MassEditActivateProductMarketplaceEvent extends ProductEvent {
  final Marketplace marketplace;

  MassEditActivateProductMarketplaceEvent({required this.marketplace});
}

class ProductsMassEditingPurchaceUpdatedEvent extends ProductEvent {
  final List<Marketplace> selectedMarketplaces;
  final double wholesalePrice;
  final String manufacturer;
  final Supplier supplier;
  final int minimumReorderQuantity;
  final int packagingUnitOnReorder;
  final int minimumStock;
  final bool isWholesalePriceSelected;
  final bool isManufacturerSelected;
  final bool isSupplierSelected;
  final bool isMinimumReorderQuantitySelected;
  final bool isPackagingUnitOnReorderSelected;
  final bool isMinimumStockSelected;

  ProductsMassEditingPurchaceUpdatedEvent({
    required this.selectedMarketplaces,
    required this.wholesalePrice,
    required this.manufacturer,
    required this.supplier,
    required this.minimumReorderQuantity,
    required this.packagingUnitOnReorder,
    required this.minimumStock,
    required this.isWholesalePriceSelected,
    required this.isManufacturerSelected,
    required this.isSupplierSelected,
    required this.isMinimumReorderQuantitySelected,
    required this.isPackagingUnitOnReorderSelected,
    required this.isMinimumStockSelected,
  });
}

class ProductsMassEditingWeightAndDimensionsUpdatedEvent extends ProductEvent {
  final List<Marketplace> selectedMarketplaces;
  final double weight;
  final double height;
  final double depth;
  final double width;
  final bool isWeightSelected;
  final bool isHeightSelected;
  final bool isDepthSelected;
  final bool isWidthSelected;

  ProductsMassEditingWeightAndDimensionsUpdatedEvent({
    required this.selectedMarketplaces,
    required this.weight,
    required this.height,
    required this.depth,
    required this.width,
    required this.isWeightSelected,
    required this.isHeightSelected,
    required this.isDepthSelected,
    required this.isWidthSelected,
  });
}

// * #################################################################################################################################
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
