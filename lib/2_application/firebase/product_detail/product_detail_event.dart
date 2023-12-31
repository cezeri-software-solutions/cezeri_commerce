part of 'product_detail_bloc.dart';

abstract class ProductDetailEvent {}

class SetProductDetailStatesToInitialEvent extends ProductDetailEvent {}

class GetProductEvent extends ProductDetailEvent {
  final String id;

  GetProductEvent({required this.id});
}

class SetProductEvent extends ProductDetailEvent {
  final Product product;
  final bool loadStatProduct;

  SetProductEvent({required this.product, required this.loadStatProduct});
}

class SetProductControllerEvent extends ProductDetailEvent {
  final Product product;

  SetProductControllerEvent({required this.product});
}

class OnProductControllerChangedEvent extends ProductDetailEvent {}

class OnProductSalesPriceControllerChangedEvent extends ProductDetailEvent {
  final bool isNet;

  OnProductSalesPriceControllerChangedEvent({required this.isNet});
}

class OnProductShowDescriptionChangedEvent extends ProductDetailEvent {}

class OnProductDescriptionChangedEvent extends ProductDetailEvent {
  final String? content;

  OnProductDescriptionChangedEvent({required this.content});
}

class OnSaveProductDescriptionEvent extends ProductDetailEvent {}

class GetProductByEanEvent extends ProductDetailEvent {
  final String ean;

  GetProductByEanEvent({required this.ean});
}

class UpdateProductEvent extends ProductDetailEvent {}

class OnProductIsActiveChangedEvent extends ProductDetailEvent {}

class RemoveSelectedProductImages extends ProductDetailEvent {}

class OnPickNewProductPictureEvent extends ProductDetailEvent {}

class OnProductGetSuppliersEvent extends ProductDetailEvent {}

class OnProductSetSupplierEvent extends ProductDetailEvent {
  final String supplierName;

  OnProductSetSupplierEvent({required this.supplierName});
}

class OnProductGetMarketplacesEvent extends ProductDetailEvent {}

class OnProductImageSelectedEvent extends ProductDetailEvent {
  final ProductImage image;

  OnProductImageSelectedEvent({required this.image});
}

class OnAllProdcutImagesSelectedEvent extends ProductDetailEvent {
  final bool value;

  OnAllProdcutImagesSelectedEvent({required this.value});
}

class OnReorderProductImagesEvent extends ProductDetailEvent {
  final int oldIndex;
  final int newIndex;

  OnReorderProductImagesEvent({required this.oldIndex, required this.newIndex});
}

class OnUpdateProductMarketplaceEvent extends ProductDetailEvent {
  final ProductMarketplace productMarketplace;

  OnUpdateProductMarketplaceEvent({required this.productMarketplace});
}

// * #################################################################################################################################
// * StatProducts Chart

class OnProductGetStatProductsEvent extends ProductDetailEvent {}

class OnProductChangeChartModeEvent extends ProductDetailEvent {}

class OnEditProductInPresta extends ProductDetailEvent {
  final Product product;

  OnEditProductInPresta({required this.product});
}

class UploadProductImageToPrestaEvent extends ProductDetailEvent {}
