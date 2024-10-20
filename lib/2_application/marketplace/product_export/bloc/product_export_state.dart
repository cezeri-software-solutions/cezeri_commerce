part of 'product_export_bloc.dart';

class ProductExportState {
  final List<Product>? listOfAllProducts;
  final List<Product>? listOfFilteredProducts;
  final List<Product> selectedProducts;
  final List<AbstractMarketplace> listOfMarketplaces;
  final AbstractFailure? firebaseFailure;
  final bool isLoadingProductsOnObserve;
  final bool isLoadingMarketplacesOnObserve;
  final bool isLoadingOnExportProducts;
  final Option<Either<AbstractFailure, List<Product>>> fosProductsOnObserveOption;
  final Option<Either<AbstractFailure, List<AbstractMarketplace>>> fosMarketplacesOnObserveOption;
  final Option<Either<List<AbstractFailure>, Unit>> fosProductsOnExportOption;

  //* Helpers
  final SearchController productSearchController;
  final bool isSelectedAllProducts;

  //* Export Helpers
  final int perPageQuantity;
  final int totalQuantity;
  final int currentPage;
  final int exportCounter;
  final List<Product> listOfSuccessfulProducts;
  final List<Product> listOfNotInMarketplaceProducts;
  final List<Product> listOfErrorProducts;
  final List<Product> listOfErrorImageProducts;
  final List<Product> listOfErrorCategoryProducts;
  final List<Product> listOfErrorStockProducts;
  final List<Product> listOfErrorMarketplaceProducts;

  const ProductExportState({
    required this.listOfAllProducts,
    required this.listOfFilteredProducts,
    required this.selectedProducts,
    required this.listOfMarketplaces,
    required this.firebaseFailure,
    required this.isLoadingProductsOnObserve,
    required this.isLoadingMarketplacesOnObserve,
    required this.isLoadingOnExportProducts,
    required this.fosProductsOnObserveOption,
    required this.fosMarketplacesOnObserveOption,
    required this.fosProductsOnExportOption,
    required this.productSearchController,
    required this.isSelectedAllProducts,
    required this.perPageQuantity,
    required this.totalQuantity,
    required this.currentPage,
    required this.exportCounter,
    required this.listOfSuccessfulProducts,
    required this.listOfNotInMarketplaceProducts,
    required this.listOfErrorProducts,
    required this.listOfErrorImageProducts,
    required this.listOfErrorCategoryProducts,
    required this.listOfErrorStockProducts,
    required this.listOfErrorMarketplaceProducts,
  });

  factory ProductExportState.initial() {
    return ProductExportState(
      listOfAllProducts: null,
      listOfFilteredProducts: null,
      selectedProducts: [],
      listOfMarketplaces: [],
      firebaseFailure: null,
      isLoadingProductsOnObserve: false,
      isLoadingMarketplacesOnObserve: false,
      isLoadingOnExportProducts: false,
      fosProductsOnObserveOption: none(),
      fosMarketplacesOnObserveOption: none(),
      fosProductsOnExportOption: none(),
      productSearchController: SearchController(),
      isSelectedAllProducts: false,
      perPageQuantity: 20,
      totalQuantity: 1,
      currentPage: 1,
      exportCounter: 1,
      listOfSuccessfulProducts: [],
      listOfNotInMarketplaceProducts: [],
      listOfErrorProducts: [],
      listOfErrorImageProducts: [],
      listOfErrorCategoryProducts: [],
      listOfErrorStockProducts: [],
      listOfErrorMarketplaceProducts: [],
    );
  }

  ProductExportState copyWith({
    List<Product>? listOfAllProducts,
    List<Product>? listOfFilteredProducts,
    List<Product>? selectedProducts,
    List<AbstractMarketplace>? listOfMarketplaces,
    AbstractFailure? firebaseFailure,
    bool? isLoadingProductsOnObserve,
    bool? isLoadingMarketplacesOnObserve,
    bool? isLoadingOnExportProducts,
    Option<Either<AbstractFailure, List<Product>>>? fosProductsOnObserveOption,
    Option<Either<AbstractFailure, List<AbstractMarketplace>>>? fosMarketplacesOnObserveOption,
    Option<Either<List<AbstractFailure>, Unit>>? fosProductsOnExportOption,
    SearchController? productSearchController,
    bool? isSelectedAllProducts,
    int? perPageQuantity,
    int? totalQuantity,
    int? currentPage,
    int? exportCounter,
    List<Product>? listOfSuccessfulProducts,
    List<Product>? listOfNotInMarketplaceProducts,
    List<Product>? listOfErrorProducts,
    List<Product>? listOfErrorImageProducts,
    List<Product>? listOfErrorCategoryProducts,
    List<Product>? listOfErrorStockProducts,
    List<Product>? listOfErrorMarketplaceProducts,
  }) {
    return ProductExportState(
      listOfAllProducts: listOfAllProducts ?? this.listOfAllProducts,
      listOfFilteredProducts: listOfFilteredProducts ?? this.listOfFilteredProducts,
      selectedProducts: selectedProducts ?? this.selectedProducts,
      listOfMarketplaces: listOfMarketplaces ?? this.listOfMarketplaces,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isLoadingProductsOnObserve: isLoadingProductsOnObserve ?? this.isLoadingProductsOnObserve,
      isLoadingMarketplacesOnObserve: isLoadingMarketplacesOnObserve ?? this.isLoadingMarketplacesOnObserve,
      isLoadingOnExportProducts: isLoadingOnExportProducts ?? this.isLoadingOnExportProducts,
      fosProductsOnObserveOption: fosProductsOnObserveOption ?? this.fosProductsOnObserveOption,
      fosMarketplacesOnObserveOption: fosMarketplacesOnObserveOption ?? this.fosMarketplacesOnObserveOption,
      fosProductsOnExportOption: fosProductsOnExportOption ?? this.fosProductsOnExportOption,
      productSearchController: productSearchController ?? this.productSearchController,
      isSelectedAllProducts: isSelectedAllProducts ?? this.isSelectedAllProducts,
      perPageQuantity: perPageQuantity ?? this.perPageQuantity,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      currentPage: currentPage ?? this.currentPage,
      exportCounter: exportCounter ?? this.exportCounter,
      listOfSuccessfulProducts: listOfSuccessfulProducts ?? this.listOfSuccessfulProducts,
      listOfNotInMarketplaceProducts: listOfNotInMarketplaceProducts ?? this.listOfNotInMarketplaceProducts,
      listOfErrorProducts: listOfErrorProducts ?? this.listOfErrorProducts,
      listOfErrorImageProducts: listOfErrorImageProducts ?? this.listOfErrorImageProducts,
      listOfErrorCategoryProducts: listOfErrorCategoryProducts ?? this.listOfErrorCategoryProducts,
      listOfErrorStockProducts: listOfErrorStockProducts ?? this.listOfErrorStockProducts,
      listOfErrorMarketplaceProducts: listOfErrorMarketplaceProducts ?? this.listOfErrorMarketplaceProducts,
    );
  }
}
