part of 'product_import_bloc.dart';

@immutable
class ProductImportState {
  final List<MarketplaceProduct>? marketplaceProducts;
  final AbstractFailure? marketplaceFailure;
  final List<ProductRawPresta>? listOfProductsPresta;
  final AbstractMarketplace? selectedMarketplace;
  final bool isAnyFailure;
  final bool isLoadingProductPrestaOnObserve;
  final bool isLoadingProductsPrestaOnObserve;
  final bool isLoadingProductOnCreate;
  final bool isLoadingProductsOnCreate;
  final Option<Either<AbstractFailure, ProductPresta>> fosProductPrestaOnObserveOption;
  final Option<Either<AbstractFailure, List<ProductShopify>>> fosListProductShopifyOnObserveOption;
  final Option<Either<AbstractFailure, Unit>> fosProductsPrestaOnObserveOption;
  final Option<Either<AbstractFailure, Unit>> fosProductOnCreateOption;
  final Option<Either<AbstractFailure, Unit>> fosProductsOnCreateOption;
  //* Helper
  final int numberOfToLoadProducts;
  final int loadedProducts;
  final String loadingText;

  const ProductImportState({
    required this.marketplaceProducts,
    required this.marketplaceFailure,
    required this.listOfProductsPresta,
    required this.selectedMarketplace,
    required this.isAnyFailure,
    required this.isLoadingProductPrestaOnObserve,
    required this.isLoadingProductsPrestaOnObserve,
    required this.isLoadingProductOnCreate,
    required this.isLoadingProductsOnCreate,
    required this.fosProductPrestaOnObserveOption,
    required this.fosListProductShopifyOnObserveOption,
    required this.fosProductsPrestaOnObserveOption,
    required this.fosProductOnCreateOption,
    required this.fosProductsOnCreateOption,
    required this.numberOfToLoadProducts,
    required this.loadedProducts,
    required this.loadingText,
  });

  factory ProductImportState.initial() => ProductImportState(
        marketplaceProducts: null,
        marketplaceFailure: null,
        listOfProductsPresta: null,
        selectedMarketplace: null,
        isAnyFailure: false,
        isLoadingProductPrestaOnObserve: false,
        isLoadingProductsPrestaOnObserve: false,
        isLoadingProductOnCreate: false,
        isLoadingProductsOnCreate: false,
        fosProductPrestaOnObserveOption: none(),
        fosListProductShopifyOnObserveOption: none(),
        fosProductsPrestaOnObserveOption: none(),
        fosProductOnCreateOption: none(),
        fosProductsOnCreateOption: none(),
        numberOfToLoadProducts: 0,
        loadedProducts: 0,
        loadingText: '',
      );

  ProductImportState copyWith({
    List<MarketplaceProduct>? marketplaceProduct,
    AbstractFailure? marketplaceFailure,
    List<ProductRawPresta>? listOfProductsPresta,
    AbstractMarketplace? selectedMarketplace,
    bool? isAnyFailure,
    bool? isLoadingProductPrestaOnObserve,
    bool? isLoadingProductsPrestaOnObserve,
    bool? isLoadingProductOnCreate,
    bool? isLoadingProductsOnCreate,
    Option<Either<AbstractFailure, ProductPresta>>? fosProductPrestaOnObserveOption,
    Option<Either<AbstractFailure, List<ProductShopify>>>? fosListProductShopifyOnObserveOption,
    Option<Either<AbstractFailure, Unit>>? fosProductsPrestaOnObserveOption,
    Option<Either<AbstractFailure, Unit>>? fosProductOnCreateOption,
    Option<Either<AbstractFailure, Unit>>? fosProductsOnCreateOption,
    int? numberOfToLoadProducts,
    int? loadedProducts,
    String? loadingText,
  }) {
    return ProductImportState(
      marketplaceProducts: marketplaceProduct ?? marketplaceProducts,
      marketplaceFailure: marketplaceFailure ?? this.marketplaceFailure,
      listOfProductsPresta: listOfProductsPresta ?? this.listOfProductsPresta,
      selectedMarketplace: selectedMarketplace ?? this.selectedMarketplace,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingProductPrestaOnObserve: isLoadingProductPrestaOnObserve ?? this.isLoadingProductPrestaOnObserve,
      isLoadingProductsPrestaOnObserve: isLoadingProductsPrestaOnObserve ?? this.isLoadingProductsPrestaOnObserve,
      isLoadingProductOnCreate: isLoadingProductOnCreate ?? this.isLoadingProductOnCreate,
      isLoadingProductsOnCreate: isLoadingProductsOnCreate ?? this.isLoadingProductsOnCreate,
      fosProductPrestaOnObserveOption: fosProductPrestaOnObserveOption ?? this.fosProductPrestaOnObserveOption,
      fosListProductShopifyOnObserveOption: fosListProductShopifyOnObserveOption ?? this.fosListProductShopifyOnObserveOption,
      fosProductsPrestaOnObserveOption: fosProductsPrestaOnObserveOption ?? this.fosProductsPrestaOnObserveOption,
      fosProductOnCreateOption: fosProductOnCreateOption ?? this.fosProductOnCreateOption,
      fosProductsOnCreateOption: fosProductsOnCreateOption ?? this.fosProductsOnCreateOption,
      numberOfToLoadProducts: numberOfToLoadProducts ?? this.numberOfToLoadProducts,
      loadedProducts: loadedProducts ?? this.loadedProducts,
      loadingText: loadingText ?? this.loadingText,
    );
  }
}
