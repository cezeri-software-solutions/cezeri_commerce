part of 'product_detail_bloc.dart';

abstract class ProductDetailEvent {}

class SetProductDetailStatesToInitialEvent extends ProductDetailEvent {}

class GetProductEvent extends ProductDetailEvent {
  final String id;

  GetProductEvent({required this.id});
}

class GetListOfProductsEvent extends ProductDetailEvent {}

class SetListOfProductsEvent extends ProductDetailEvent {
  final List<Product> listOfProducts;

  SetListOfProductsEvent({required this.listOfProducts});
}

class GetProductAfterExportNewProductToMarketplaceEvent extends ProductDetailEvent {
  final String id;

  GetProductAfterExportNewProductToMarketplaceEvent({required this.id});
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

class OnProductIsOutletChangedEvent extends ProductDetailEvent {
  final bool value;

  OnProductIsOutletChangedEvent({required this.value});
}

class OnProductShowDescriptionChangedEvent extends ProductDetailEvent {}

class OnProductDescriptionChangedEvent extends ProductDetailEvent {
  final String? content;

  OnProductDescriptionChangedEvent({required this.content});
}

class OnSaveProductDescriptionEvent extends ProductDetailEvent {
  final String description;
  final String descriptionShort;

  OnSaveProductDescriptionEvent({required this.description, required this.descriptionShort});
}

class OnAddEditProductSpecificPriceEvent extends ProductDetailEvent {
  final SpecificPrice specificPrice;

  OnAddEditProductSpecificPriceEvent({required this.specificPrice});
}

class OnDeleteProductSpecificPriceEvent extends ProductDetailEvent {}

class GetProductByEanEvent extends ProductDetailEvent {
  final String ean;

  GetProductByEanEvent({required this.ean});
}

class UpdateProductEvent extends ProductDetailEvent {}

class OnProductIsActiveChangedEvent extends ProductDetailEvent {}

class RemoveSelectedProductImages extends ProductDetailEvent {}

class OnPickNewProductPictureEvent extends ProductDetailEvent {}

class OnProductSetSupplierEvent extends ProductDetailEvent {
  final String supplierName;

  OnProductSetSupplierEvent({required this.supplierName});
}

class OnProductGetMarketplacesEvent extends ProductDetailEvent {}

class OnCreateProductInMarketplaceEvent extends ProductDetailEvent {
  final BuildContext context;
  final ProductMarketplace productMarketplace;

  OnCreateProductInMarketplaceEvent({required this.context, required this.productMarketplace});
}

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

class DeleteMarketplaceFromProductEvent extends ProductDetailEvent {
  final String marketplaceId;

  DeleteMarketplaceFromProductEvent({required this.marketplaceId});
}

// * #################################################################################################################################
// * Set-Article

class OnProductSetIsSetArticleEvent extends ProductDetailEvent {}

class OnAddProductToSetArticleEvent extends ProductDetailEvent {
  final Product product;

  OnAddProductToSetArticleEvent({required this.product});
}

class OnRemoveProductFromSetArticleEvent extends ProductDetailEvent {
  final int index;

  OnRemoveProductFromSetArticleEvent({required this.index});
}

class OnSetArticleQuantityChangedEvent extends ProductDetailEvent {
  final String productId;
  final bool isIncrease;

  OnSetArticleQuantityChangedEvent({required this.productId, required this.isIncrease});
}

class OnSetProductSalesNetPriceGeneratedEvent extends ProductDetailEvent {}

class OnSetProductWholesalePriceGeneratedEvent extends ProductDetailEvent {}

class OnPartOfSetProductControllerChangedEvent extends ProductDetailEvent {}

class OnPartOfSetProductControllerClearedEvent extends ProductDetailEvent {}

// * #################################################################################################################################
// * StatProducts Chart

class OnProductGetProductsSalesDataEvent extends ProductDetailEvent {}

class OnProductChangeChartModeEvent extends ProductDetailEvent {}

class OnEditProductInPresta extends ProductDetailEvent {
  final Product product;
  final bool updateImages;

  OnEditProductInPresta({required this.product, required this.updateImages});
}

class UploadProductImageToPrestaEvent extends ProductDetailEvent {}
