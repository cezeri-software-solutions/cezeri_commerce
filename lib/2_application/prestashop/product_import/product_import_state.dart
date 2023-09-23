part of 'product_import_bloc.dart';

@immutable
class ProductImportState {
  final ProductPresta? productPresta;
  final List<ProductPresta>? listOfProductPresta;
  final PrestaFailure? prestaFailure;
  final bool isAnyFailure;
  final bool isLoadingProductPrestaOnObserve;
  final bool isLoadingProductsPrestaOnObserve;
  final Option<Either<PrestaFailure, ProductPresta>> fosProductPrestaOnObserveOption;
  final Option<Either<PrestaFailure, List<ProductPresta>>> fosProductsPrestaOnObserveOption;

  const ProductImportState({
    required this.productPresta,
    required this.listOfProductPresta,
    required this.prestaFailure,
    required this.isAnyFailure,
    required this.isLoadingProductPrestaOnObserve,
    required this.isLoadingProductsPrestaOnObserve,
    required this.fosProductPrestaOnObserveOption,
    required this.fosProductsPrestaOnObserveOption,
  });

  factory ProductImportState.initial() => ProductImportState(
        productPresta: null,
        listOfProductPresta: null,
        prestaFailure: null,
        isAnyFailure: false,
        isLoadingProductPrestaOnObserve: false,
        isLoadingProductsPrestaOnObserve: false,
        fosProductPrestaOnObserveOption: none(),
        fosProductsPrestaOnObserveOption: none(),
      );

  ProductImportState copyWith({
    ProductPresta? productPresta,
    List<ProductPresta>? listOfProductPresta,
    PrestaFailure? prestaFailure,
    bool? isAnyFailure,
    bool? isLoadingProductPrestaOnObserve,
    bool? isLoadingProductsPrestaOnObserve,
    Option<Either<PrestaFailure, ProductPresta>>? fosProductPrestaOnObserveOption,
    Option<Either<PrestaFailure, List<ProductPresta>>>? fosProductsPrestaOnObserveOption,
  }) {
    return ProductImportState(
      productPresta: productPresta ?? this.productPresta,
      listOfProductPresta: listOfProductPresta ?? this.listOfProductPresta,
      prestaFailure: prestaFailure ?? this.prestaFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingProductPrestaOnObserve: isLoadingProductPrestaOnObserve ?? this.isLoadingProductPrestaOnObserve,
      isLoadingProductsPrestaOnObserve: isLoadingProductsPrestaOnObserve ?? this.isLoadingProductsPrestaOnObserve,
      fosProductPrestaOnObserveOption: fosProductPrestaOnObserveOption ?? this.fosProductPrestaOnObserveOption,
      fosProductsPrestaOnObserveOption: fosProductsPrestaOnObserveOption ?? this.fosProductsPrestaOnObserveOption,
    );
  }
}
