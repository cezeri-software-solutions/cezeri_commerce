part of 'product_bloc.dart';

enum ProductsSortValue { name, articleNumber, manufacturer, supplier, wholesalePrice, netPrice, creationDate, lastEditingDate }

@immutable
class ProductState {
  final List<Product>? listOfAllProducts;
  final List<Product>? listOfFilteredProducts; // Der State, der im presentation layer ausgegeben wird, egal ob Suchfeld leer oder nicht
  final List<Product> selectedProducts; // Ausgewählte Produkte zum löschen oder für Massenbearbeitung
  final List<Product> listOfNotUpdatedProductsOnMassEditing;
  final MainSettings? mainSettings;
  final AbstractFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingProductOnUpdateQuantity;
  final bool isLoadingProductsOnObserve;
  final bool isLoadingProductOnCreate;
  final bool isLoadingProductOnDelete;
  final bool isLoadingProductOnMassEditing;
  final Option<Either<AbstractFailure, List<Product>>> fosProductsOnObserveOption;
  final Option<Either<AbstractFailure, Product>> fosProductOnCreateOption;
  final Option<Either<AbstractFailure, Unit>> fosProductOnDeleteOption;
  final Option<Either<List<AbstractFailure>, Unit>> fosProductAbstractFailuresOption;

  final bool isLoadingOnMassEditActivateProductMarketplace;
  final Option<Either<AbstractFailure, List<Product>>> fosProductOnUpdateQuantityOption;
  final Option<Either<AbstractFailure, Unit>> fosMassEditActivateProductMarketplaceOption;
  final Option<Either<AbstractFailure, Unit>> fosMassEditProductsOption;

  //* Prestashop States
  final Option<Either<List<AbstractFailure>, Unit>> fosProductOnEditQuantityPrestaOption;
  //* Helpers
  final int perPageQuantity;
  final int totalQuantity;
  final int currentPage;
  final SearchController productSearchController;
  final bool triggerPop;
  final bool isSelectedAllProducts;
  final bool isLoadingPdf;
  final String loadingText;
  //* Sortieren und Filtern helpers
  final ProductsSortValue productsSortValue;
  final bool isSortedAsc;
  final ProductsFilterValues productsFilterValues;
  //* Unter Konstruktor
  final bool isAnyFilterSet;

  ProductState({
    required this.listOfAllProducts,
    required this.listOfFilteredProducts,
    required this.selectedProducts,
    required this.listOfNotUpdatedProductsOnMassEditing,
    required this.mainSettings,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingProductOnUpdateQuantity,
    required this.isLoadingProductsOnObserve,
    required this.isLoadingProductOnCreate,
    required this.isLoadingProductOnDelete,
    required this.isLoadingProductOnMassEditing,
    required this.fosProductsOnObserveOption,
    required this.fosProductOnCreateOption,
    required this.fosProductOnDeleteOption,
    required this.fosProductAbstractFailuresOption,
    required this.isLoadingOnMassEditActivateProductMarketplace,
    required this.fosProductOnUpdateQuantityOption,
    required this.fosMassEditActivateProductMarketplaceOption,
    required this.fosMassEditProductsOption,
    required this.fosProductOnEditQuantityPrestaOption,
    required this.perPageQuantity,
    required this.totalQuantity,
    required this.currentPage,
    required this.productSearchController,
    required this.triggerPop,
    required this.isSelectedAllProducts,
    required this.isLoadingPdf,
    required this.loadingText,
    required this.productsSortValue,
    required this.isSortedAsc,
    required this.productsFilterValues,
  }) : isAnyFilterSet = _isAnyFilterSet(productsFilterValues);

  static bool _isAnyFilterSet(ProductsFilterValues productsFilterValues) {
    if (productsFilterValues.manufacturer != null ||
        productsFilterValues.supplier != null ||
        productsFilterValues.isActive != null ||
        productsFilterValues.isOutlet != null ||
        productsFilterValues.isPartOfSet != null ||
        productsFilterValues.isSet != null ||
        productsFilterValues.isSale != null) return true;
    return false;
  }

  factory ProductState.initial() {
    return ProductState(
      listOfAllProducts: null,
      listOfFilteredProducts: null,
      selectedProducts: const [],
      listOfNotUpdatedProductsOnMassEditing: const [],
      mainSettings: null,
      firebaseFailure: null,
      isAnyFailure: false,
      isLoadingProductOnUpdateQuantity: false,
      isLoadingProductsOnObserve: false,
      isLoadingProductOnCreate: false,
      isLoadingProductOnDelete: false,
      isLoadingProductOnMassEditing: false,
      fosProductsOnObserveOption: none(),
      fosProductOnCreateOption: none(),
      fosProductOnDeleteOption: none(),
      fosProductAbstractFailuresOption: none(),
      isLoadingOnMassEditActivateProductMarketplace: false,
      fosProductOnUpdateQuantityOption: none(),
      fosMassEditActivateProductMarketplaceOption: none(),
      fosMassEditProductsOption: none(),
      fosProductOnEditQuantityPrestaOption: none(),
      perPageQuantity: 20,
      totalQuantity: 1,
      currentPage: 1,
      productSearchController: SearchController(),
      triggerPop: false,
      isSelectedAllProducts: false,
      isLoadingPdf: false,
      loadingText: '',
      productsSortValue: ProductsSortValue.name,
      isSortedAsc: true,
      productsFilterValues: ProductsFilterValues.empty(),
    );
  }

  ProductState copyWith({
    List<Product>? listOfAllProducts,
    List<Product>? listOfFilteredProducts,
    List<Product>? selectedProducts,
    List<Product>? listOfNotUpdatedProductsOnMassEditing,
    MainSettings? mainSettings,
    AbstractFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingProductOnUpdateQuantity,
    bool? isLoadingProductsOnObserve,
    bool? isLoadingProductOnCreate,
    bool? isLoadingProductOnDelete,
    bool? isLoadingProductOnMassEditing,
    Option<Either<AbstractFailure, List<Product>>>? fosProductsOnObserveOption,
    Option<Either<AbstractFailure, Product>>? fosProductOnCreateOption,
    Option<Either<AbstractFailure, Unit>>? fosProductOnDeleteOption,
    Option<Either<List<AbstractFailure>, Unit>>? fosProductAbstractFailuresOption,
    bool? isLoadingOnMassEditActivateProductMarketplace,
    Option<Either<AbstractFailure, List<Product>>>? fosProductOnUpdateQuantityOption,
    Option<Either<AbstractFailure, Unit>>? fosMassEditActivateProductMarketplaceOption,
    Option<Either<AbstractFailure, Unit>>? fosMassEditProductsOption,
    Option<Either<List<AbstractFailure>, Unit>>? fosProductOnEditQuantityPrestaOption,
    int? perPageQuantity,
    int? totalQuantity,
    int? currentPage,
    SearchController? productSearchController,
    bool? triggerPop,
    bool? isSelectedAllProducts,
    bool? isLoadingPdf,
    String? loadingText,
    ProductsSortValue? productsSortValue,
    bool? isSortedAsc,
    ProductsFilterValues? productsFilterValues,
  }) {
    return ProductState(
      listOfAllProducts: listOfAllProducts ?? this.listOfAllProducts,
      listOfFilteredProducts: listOfFilteredProducts ?? this.listOfFilteredProducts,
      selectedProducts: selectedProducts ?? this.selectedProducts,
      listOfNotUpdatedProductsOnMassEditing: listOfNotUpdatedProductsOnMassEditing ?? this.listOfNotUpdatedProductsOnMassEditing,
      mainSettings: mainSettings ?? this.mainSettings,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingProductOnUpdateQuantity: isLoadingProductOnUpdateQuantity ?? this.isLoadingProductOnUpdateQuantity,
      isLoadingProductsOnObserve: isLoadingProductsOnObserve ?? this.isLoadingProductsOnObserve,
      isLoadingProductOnCreate: isLoadingProductOnCreate ?? this.isLoadingProductOnCreate,
      isLoadingProductOnDelete: isLoadingProductOnDelete ?? this.isLoadingProductOnDelete,
      isLoadingProductOnMassEditing: isLoadingProductOnMassEditing ?? this.isLoadingProductOnMassEditing,
      fosProductsOnObserveOption: fosProductsOnObserveOption ?? this.fosProductsOnObserveOption,
      fosProductOnCreateOption: fosProductOnCreateOption ?? this.fosProductOnCreateOption,
      fosProductOnDeleteOption: fosProductOnDeleteOption ?? this.fosProductOnDeleteOption,
      fosProductAbstractFailuresOption: fosProductAbstractFailuresOption ?? this.fosProductAbstractFailuresOption,
      isLoadingOnMassEditActivateProductMarketplace:
          isLoadingOnMassEditActivateProductMarketplace ?? this.isLoadingOnMassEditActivateProductMarketplace,
      fosProductOnUpdateQuantityOption: fosProductOnUpdateQuantityOption ?? this.fosProductOnUpdateQuantityOption,
      fosMassEditActivateProductMarketplaceOption: fosMassEditActivateProductMarketplaceOption ?? this.fosMassEditActivateProductMarketplaceOption,
      fosMassEditProductsOption: fosMassEditProductsOption ?? this.fosMassEditProductsOption,
      fosProductOnEditQuantityPrestaOption: fosProductOnEditQuantityPrestaOption ?? this.fosProductOnEditQuantityPrestaOption,
      perPageQuantity: perPageQuantity ?? this.perPageQuantity,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      currentPage: currentPage ?? this.currentPage,
      productSearchController: productSearchController ?? this.productSearchController,
      triggerPop: triggerPop ?? this.triggerPop,
      isSelectedAllProducts: isSelectedAllProducts ?? this.isSelectedAllProducts,
      isLoadingPdf: isLoadingPdf ?? this.isLoadingPdf,
      loadingText: loadingText ?? this.loadingText,
      productsSortValue: productsSortValue ?? this.productsSortValue,
      isSortedAsc: isSortedAsc ?? this.isSortedAsc,
      productsFilterValues: productsFilterValues ?? this.productsFilterValues,
    );
  }
}
