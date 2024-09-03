part of 'product_bloc.dart';

@immutable
class ProductState {
  final List<Product>? listOfAllProducts;
  final List<Product>? listOfFilteredProducts; // Der State, der im presentation layer ausgegeben wird, egal ob Suchfeld leer oder nicht
  final List<Product> selectedProducts; // Ausgewählte Produkte zum löschen oder für Massenbearbeitung
  final List<Supplier>? listOfSuppliers;
  final List<Product> listOfNotUpdatedProductsOnMassEditing;
  final MainSettings? mainSettings;
  final AbstractFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingProductOnUpdateQuantity;
  final bool isLoadingProductsOnObserve;
  final bool isLoadingProductOnCreate;
  final bool isLoadingProductOnDelete;
  final bool isLoadingProductSuppliersOnObseve;
  final bool isLoadingProductOnMassEditing;
  final Option<Either<AbstractFailure, List<Product>>> fosProductsOnObserveOption;
  final Option<Either<AbstractFailure, Product>> fosProductOnCreateOption;
  final Option<Either<AbstractFailure, Unit>> fosProductOnDeleteOption;
  final Option<Either<AbstractFailure, List<Supplier>>> fosProductSuppliersOnObserveOption;
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

  const ProductState({
    required this.listOfAllProducts,
    required this.listOfFilteredProducts,
    required this.selectedProducts,
    required this.listOfSuppliers,
    required this.listOfNotUpdatedProductsOnMassEditing,
    required this.mainSettings,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingProductOnUpdateQuantity,
    required this.isLoadingProductsOnObserve,
    required this.isLoadingProductOnCreate,
    required this.isLoadingProductOnDelete,
    required this.isLoadingProductSuppliersOnObseve,
    required this.isLoadingProductOnMassEditing,
    required this.fosProductsOnObserveOption,
    required this.fosProductOnCreateOption,
    required this.fosProductOnDeleteOption,
    required this.fosProductSuppliersOnObserveOption,
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
  });

  factory ProductState.initial() {
    return ProductState(
      listOfAllProducts: null,
      listOfFilteredProducts: null,
      selectedProducts: const [],
      listOfSuppliers: null,
      listOfNotUpdatedProductsOnMassEditing: const [],
      mainSettings: null,
      firebaseFailure: null,
      isAnyFailure: false,
      isLoadingProductOnUpdateQuantity: false,
      isLoadingProductsOnObserve: false,
      isLoadingProductOnCreate: false,
      isLoadingProductOnDelete: false,
      isLoadingProductSuppliersOnObseve: false,
      isLoadingProductOnMassEditing: false,
      fosProductsOnObserveOption: none(),
      fosProductOnCreateOption: none(),
      fosProductOnDeleteOption: none(),
      fosProductSuppliersOnObserveOption: none(),
      fosProductAbstractFailuresOption: none(),
      isLoadingOnMassEditActivateProductMarketplace: false,
      fosProductOnUpdateQuantityOption: none(),
      fosMassEditActivateProductMarketplaceOption: none(),
      fosMassEditProductsOption: none(),
      fosProductOnEditQuantityPrestaOption: none(),
      perPageQuantity: 20,
      totalQuantity: 0,
      currentPage: 1,
      productSearchController: SearchController(),
      triggerPop: false,
      isSelectedAllProducts: false,
      isLoadingPdf: false,
      loadingText: '',
    );
  }

  ProductState copyWith({
    List<Product>? listOfAllProducts,
    List<Product>? listOfFilteredProducts,
    List<Product>? selectedProducts,
    List<Supplier>? listOfSuppliers,
    List<Product>? listOfNotUpdatedProductsOnMassEditing,
    MainSettings? mainSettings,
    AbstractFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingProductOnUpdateQuantity,
    bool? isLoadingProductsOnObserve,
    bool? isLoadingProductOnCreate,
    bool? isLoadingProductOnDelete,
    bool? isLoadingProductSuppliersOnObseve,
    bool? isLoadingProductOnMassEditing,
    Option<Either<AbstractFailure, List<Product>>>? fosProductsOnObserveOption,
    Option<Either<AbstractFailure, Product>>? fosProductOnCreateOption,
    Option<Either<AbstractFailure, Unit>>? fosProductOnDeleteOption,
    Option<Either<AbstractFailure, List<Supplier>>>? fosProductSuppliersOnObserveOption,
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
  }) {
    return ProductState(
      listOfAllProducts: listOfAllProducts ?? this.listOfAllProducts,
      listOfFilteredProducts: listOfFilteredProducts ?? this.listOfFilteredProducts,
      selectedProducts: selectedProducts ?? this.selectedProducts,
      listOfSuppliers: listOfSuppliers ?? this.listOfSuppliers,
      listOfNotUpdatedProductsOnMassEditing: listOfNotUpdatedProductsOnMassEditing ?? this.listOfNotUpdatedProductsOnMassEditing,
      mainSettings: mainSettings ?? this.mainSettings,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingProductOnUpdateQuantity: isLoadingProductOnUpdateQuantity ?? this.isLoadingProductOnUpdateQuantity,
      isLoadingProductsOnObserve: isLoadingProductsOnObserve ?? this.isLoadingProductsOnObserve,
      isLoadingProductOnCreate: isLoadingProductOnCreate ?? this.isLoadingProductOnCreate,
      isLoadingProductOnDelete: isLoadingProductOnDelete ?? this.isLoadingProductOnDelete,
      isLoadingProductSuppliersOnObseve: isLoadingProductSuppliersOnObseve ?? this.isLoadingProductSuppliersOnObseve,
      isLoadingProductOnMassEditing: isLoadingProductOnMassEditing ?? this.isLoadingProductOnMassEditing,
      fosProductsOnObserveOption: fosProductsOnObserveOption ?? this.fosProductsOnObserveOption,
      fosProductOnCreateOption: fosProductOnCreateOption ?? this.fosProductOnCreateOption,
      fosProductOnDeleteOption: fosProductOnDeleteOption ?? this.fosProductOnDeleteOption,
      fosProductSuppliersOnObserveOption: fosProductSuppliersOnObserveOption ?? this.fosProductSuppliersOnObserveOption,
      fosProductAbstractFailuresOption: fosProductAbstractFailuresOption ?? this.fosProductAbstractFailuresOption,
      isLoadingOnMassEditActivateProductMarketplace: isLoadingOnMassEditActivateProductMarketplace ?? this.isLoadingOnMassEditActivateProductMarketplace,
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
    );
  }
}
