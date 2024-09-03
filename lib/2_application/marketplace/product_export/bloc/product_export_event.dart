part of 'product_export_bloc.dart';

abstract class ProductExportEvent {}

class SetProductExportStateToInitialEvent extends ProductExportEvent {}

class GetAllProductsEvent extends ProductExportEvent {}

class GetProductsPerPageEvent extends ProductExportEvent {
  final bool isFirstLoad;
  final bool calcCount;
  final int currentPage;

  GetProductsPerPageEvent({required this.isFirstLoad, required this.calcCount, required this.currentPage});
}

class GetFilteredProductsBySearchTextEvent extends ProductExportEvent {
  final int currentPage;

  GetFilteredProductsBySearchTextEvent({required this.currentPage});
}

class ItemsPerPageChangedEvent extends ProductExportEvent {
  final int value;

  ItemsPerPageChangedEvent({required this.value});
}

class GetAllMarketplacesEvent extends ProductExportEvent {}

class OnProductSearchControllerChangedEvent extends ProductExportEvent {}

class OnProductSearchControllerClearedEvent extends ProductExportEvent {}

class OnSelectedAllProductsChangedEvent extends ProductExportEvent {
  final bool isSelected;

  OnSelectedAllProductsChangedEvent({required this.isSelected});
}

class OnProductSelectedEvent extends ProductExportEvent {
  final Product selectedProduct;

  OnProductSelectedEvent({required this.selectedProduct});
}

class OnProductsExportToSelectedMarketplaceEvent extends ProductExportEvent {
  final AbstractMarketplace selectedMarketplace;
  final AbstractMarketplace? selectedMarketplaceForSourceCategoires;

  OnProductsExportToSelectedMarketplaceEvent({required this.selectedMarketplace, required this.selectedMarketplaceForSourceCategoires});
}
