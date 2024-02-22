part of 'product_import_bloc.dart';

@immutable
class ProductImportState {
  final ProductPresta? productPresta;
  final PrestaFailure? prestaFailure;
  final List<ProductPresta>? listOfProductsPresta;
  final AbstractMarketplace? selectedMarketplace;
  final bool isAnyFailure;
  final bool isLoadingProductPrestaOnObserve;
  final bool isLoadingProductsPrestaOnObserve;
  final bool isLoadingProductOnCreate;
  final bool isLoadingProductsOnCreate;
  final Option<Either<PrestaFailure, ProductPresta>> fosProductPrestaOnObserveOption;
  final Option<Either<PrestaFailure, Unit>> fosProductsPrestaOnObserveOption;
  final Option<Either<AbstractFailure, Unit>> fosProductOnCreateOption;
  final Option<Either<AbstractFailure, Unit>> fosProductsOnCreateOption;
  //* Helper
  final int numberOfToLoadProducts;
  final int loadedProducts;
  final String loadingText;

  const ProductImportState({
    required this.productPresta,
    required this.prestaFailure,
    required this.listOfProductsPresta,
    required this.selectedMarketplace,
    required this.isAnyFailure,
    required this.isLoadingProductPrestaOnObserve,
    required this.isLoadingProductsPrestaOnObserve,
    required this.isLoadingProductOnCreate,
    required this.isLoadingProductsOnCreate,
    required this.fosProductPrestaOnObserveOption,
    required this.fosProductsPrestaOnObserveOption,
    required this.fosProductOnCreateOption,
    required this.fosProductsOnCreateOption,
    required this.numberOfToLoadProducts,
    required this.loadedProducts,
    required this.loadingText,
  });

  factory ProductImportState.initial() => ProductImportState(
        productPresta: null,
        prestaFailure: null,
        listOfProductsPresta: null,
        selectedMarketplace: null,
        isAnyFailure: false,
        isLoadingProductPrestaOnObserve: false,
        isLoadingProductsPrestaOnObserve: false,
        isLoadingProductOnCreate: false,
        isLoadingProductsOnCreate: false,
        fosProductPrestaOnObserveOption: none(),
        fosProductsPrestaOnObserveOption: none(),
        fosProductOnCreateOption: none(),
        fosProductsOnCreateOption: none(),
        numberOfToLoadProducts: 0,
        loadedProducts: 0,
        loadingText: '',
      );

  ProductImportState copyWith({
    ProductPresta? productPresta,
    PrestaFailure? prestaFailure,
    List<ProductPresta>? listOfProductsPresta,
    AbstractMarketplace? selectedMarketplace,
    bool? isAnyFailure,
    bool? isLoadingProductPrestaOnObserve,
    bool? isLoadingProductsPrestaOnObserve,
    bool? isLoadingProductOnCreate,
    bool? isLoadingProductsOnCreate,
    Option<Either<PrestaFailure, ProductPresta>>? fosProductPrestaOnObserveOption,
    Option<Either<PrestaFailure, Unit>>? fosProductsPrestaOnObserveOption,
    Option<Either<AbstractFailure, Unit>>? fosProductOnCreateOption,
    Option<Either<AbstractFailure, Unit>>? fosProductsOnCreateOption,
    int? numberOfToLoadProducts,
    int? loadedProducts,
    String? loadingText,
  }) {
    return ProductImportState(
      productPresta: productPresta ?? this.productPresta,
      prestaFailure: prestaFailure ?? this.prestaFailure,
      listOfProductsPresta: listOfProductsPresta ?? this.listOfProductsPresta,
      selectedMarketplace: selectedMarketplace ?? this.selectedMarketplace,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingProductPrestaOnObserve: isLoadingProductPrestaOnObserve ?? this.isLoadingProductPrestaOnObserve,
      isLoadingProductsPrestaOnObserve: isLoadingProductsPrestaOnObserve ?? this.isLoadingProductsPrestaOnObserve,
      isLoadingProductOnCreate: isLoadingProductOnCreate ?? this.isLoadingProductOnCreate,
      isLoadingProductsOnCreate: isLoadingProductsOnCreate ?? this.isLoadingProductsOnCreate,
      fosProductPrestaOnObserveOption: fosProductPrestaOnObserveOption ?? this.fosProductPrestaOnObserveOption,
      fosProductsPrestaOnObserveOption: fosProductsPrestaOnObserveOption ?? this.fosProductsPrestaOnObserveOption,
      fosProductOnCreateOption: fosProductOnCreateOption ?? this.fosProductOnCreateOption,
      fosProductsOnCreateOption: fosProductsOnCreateOption ?? this.fosProductsOnCreateOption,
      numberOfToLoadProducts: numberOfToLoadProducts ?? this.numberOfToLoadProducts,
      loadedProducts: loadedProducts ?? this.loadedProducts,
      loadingText: loadingText ?? this.loadingText,
    );
  }
}
