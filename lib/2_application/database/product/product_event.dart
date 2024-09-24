part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class SetProductStateToInitialEvent extends ProductEvent {}

class GetProductsPerPageEvent extends ProductEvent {
  final bool isFirstLoad;
  final bool calcCount;
  final int currentPage;

  GetProductsPerPageEvent({required this.isFirstLoad, required this.calcCount, required this.currentPage});
}

class GetFilteredProductsBySearchTextEvent extends ProductEvent {
  final int currentPage;

  GetFilteredProductsBySearchTextEvent({required this.currentPage});
}

class GetProductEvent extends ProductEvent {
  final String id;

  GetProductEvent({required this.id});
}

class DeleteSelectedProductsEvent extends ProductEvent {
  final List<Product> selectedProducts;

  DeleteSelectedProductsEvent({required this.selectedProducts});
}

class OnProductSearchControllerClearedEvent extends ProductEvent {}

class OnSearchFieldClearedEvent extends ProductEvent {}

class OnProductIsSelectedAllChangedEvent extends ProductEvent {
  final bool isSelected;

  OnProductIsSelectedAllChangedEvent({required this.isSelected});
}

class OnProductSelectedEvent extends ProductEvent {
  final Product product;

  OnProductSelectedEvent({required this.product});
}

class OnProductGetSuppliersEvent extends ProductEvent {}

class SetProductIsLoadingPdfEvent extends ProductEvent {
  final bool value;

  SetProductIsLoadingPdfEvent({required this.value});
}

//? Update Menge nur in Firebase (Danach wird automatisch OnEditQuantityInMarketplacesEvent getriggert)
class UpdateQuantityOfProductEvent extends ProductEvent {
  final Product product;
  final int incQuantity;
  final bool updateOnlyAvailableQuantity;

  UpdateQuantityOfProductEvent({required this.product, required this.incQuantity, required this.updateOnlyAvailableQuantity});
}

// * #################################################################################################################################
// * Helper Pages

class ItemsPerPageChangedEvent extends ProductEvent {
  final int value;

  ItemsPerPageChangedEvent({required this.value});
}

// * #################################################################################################################################
// * Massenbearbeitung

//TODO: aktuell deaktiviert
//? Zum aktivieren von einem Marktplatz bei mehreren ausgewählten Artikeln
class MassEditActivateProductMarketplaceEvent extends ProductEvent {
  final MarketplacePresta marketplace;

  MassEditActivateProductMarketplaceEvent({required this.marketplace});
}

class ProductsMassEditingPurchaceUpdatedEvent extends ProductEvent {
  final List<AbstractMarketplace> selectedMarketplaces;
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
  final List<AbstractMarketplace> selectedMarketplaces;
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

class ProductsMassEditingAddOrRemoveCategoriesShopifyEvent extends ProductEvent {
  final MarketplaceShopify marketplace;
  final List<CustomCollectionShopify> selectedCustomCollections;
  final bool isAddCategories;

  ProductsMassEditingAddOrRemoveCategoriesShopifyEvent({
    required this.marketplace,
    required this.selectedCustomCollections,
    required this.isAddCategories,
  });
}

class ProductsMassEditingAddOrRemoveCategoriesPrestaEvent extends ProductEvent {
  final MarketplacePresta marketplace;
  final List<CategoryPresta> selectedCategoriesPresta;
  final bool isAddCategories;

  ProductsMassEditingAddOrRemoveCategoriesPrestaEvent({
    required this.marketplace,
    required this.selectedCategoriesPresta,
    required this.isAddCategories,
  });
}

// * #################################################################################################################################
// * Prestashop events

// class OnEditQuantityInMarketplacesEvent extends ProductEvent {
//   final Product product;
//   final int newQuantity;

//   OnEditQuantityInMarketplacesEvent({required this.product, required this.newQuantity});
// }

class OnEditProductInPresta extends ProductEvent {
  final Product product;

  OnEditProductInPresta({required this.product});
}
