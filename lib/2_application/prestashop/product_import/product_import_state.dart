part of 'product_import_bloc.dart';

@immutable
class ProductImportState {
  final ProductPresta? productPresta;
  final PrestaFailure? prestaFailure;
  final bool isAnyFailure;
  final bool isLoadingProductPrestaOnObserve;
  final bool isLoadingProductsPrestaOnObserve;
  final Option<Either<PrestaFailure, ProductPresta>> fosProductPrestaOnObserveOption;

  const ProductImportState({
    required this.productPresta,
    required this.prestaFailure,
    required this.isAnyFailure,
    required this.isLoadingProductPrestaOnObserve,
    required this.isLoadingProductsPrestaOnObserve,
    required this.fosProductPrestaOnObserveOption,
  });

  factory ProductImportState.initial() => ProductImportState(
        productPresta: null,
        prestaFailure: null,
        isAnyFailure: false,
        isLoadingProductPrestaOnObserve: false,
        isLoadingProductsPrestaOnObserve: false,
        fosProductPrestaOnObserveOption: none(),
      );

  ProductImportState copyWith({
    ProductPresta? productPresta,
    PrestaFailure? prestaFailure,
    bool? isAnyFailure,
    bool? isLoadingProductPrestaOnObserve,
    bool? isLoadingProductsPrestaOnObserve,
    Option<Either<PrestaFailure, ProductPresta>>? fosProductPrestaOnObserveOption,
  }) {
    return ProductImportState(
      productPresta: productPresta ?? this.productPresta,
      prestaFailure: prestaFailure ?? this.prestaFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingProductPrestaOnObserve: isLoadingProductPrestaOnObserve ?? this.isLoadingProductPrestaOnObserve,
      isLoadingProductsPrestaOnObserve: isLoadingProductsPrestaOnObserve ?? this.isLoadingProductsPrestaOnObserve,
      fosProductPrestaOnObserveOption: fosProductPrestaOnObserveOption ?? this.fosProductPrestaOnObserveOption,
    );
  }
}
