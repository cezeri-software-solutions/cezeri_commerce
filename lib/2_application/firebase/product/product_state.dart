part of 'product_bloc.dart';

@immutable
class ProductState {
  final List<Product>? listOfAllProducts;
  final List<Product>? listOfFilteredProducts; // Der State, der im presentation layer ausgegeben wird, egal ob Suchfeld leer oder nicht
  final List<Product> selectedProducts; // Ausgewählte Produkte zum löschen oder für Massenbearbeitung
  final List<Supplier>? listOfSuppliers;
  final List<Product> listOfNotUpdatedProductsOnMassEditing;
  final MainSettings? mainSettings;
  final FirebaseFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingProductOnUpdateQuantity;
  final bool isLoadingProductsOnObserve;
  final bool isLoadingProductOnCreate;
  final bool isLoadingProductOnDelete;
  final bool isLoadingProductSuppliersOnObseve;
  final bool isLoadingProductOnMassEditing;
  final Option<Either<FirebaseFailure, List<Product>>> fosProductsOnObserveOption;
  final Option<Either<FirebaseFailure, Product>> fosProductOnCreateOption;
  final Option<Either<FirebaseFailure, Unit>> fosProductOnDeleteOption;
  final Option<Either<FirebaseFailure, List<Supplier>>> fosProductSuppliersOnObserveOption;

  final bool isLoadingOnMassEditActivateProductMarketplace;
  final Option<Either<FirebaseFailure, Product>> fosProductOnUpdateQuantityOption;
  final Option<Either<FirebaseFailure, Unit>> fosMassEditActivateProductMarketplaceOption;
  final Option<Either<FirebaseFailure, Unit>> fosMassEditProductsOption;

  //* Prestashop States
  final Option<Either<PrestaFailure, Unit>> fosProductOnEditQuantityPrestaOption;
  //* Helpers
  final TextEditingController productSearchController;
  final bool triggerPop;
  final bool isWidthSearchActive;
  final bool isSelectedAllProducts;

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
    required this.isLoadingOnMassEditActivateProductMarketplace,
    required this.fosProductOnUpdateQuantityOption,
    required this.fosMassEditActivateProductMarketplaceOption,
    required this.fosMassEditProductsOption,
    required this.fosProductOnEditQuantityPrestaOption,
    required this.productSearchController,
    required this.triggerPop,
    required this.isWidthSearchActive,
    required this.isSelectedAllProducts,
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
      isLoadingOnMassEditActivateProductMarketplace: false,
      fosProductOnUpdateQuantityOption: none(),
      fosMassEditActivateProductMarketplaceOption: none(),
      fosMassEditProductsOption: none(),
      fosProductOnEditQuantityPrestaOption: none(),
      productSearchController: TextEditingController(),
      triggerPop: false,
      isWidthSearchActive: false,
      isSelectedAllProducts: false,
    );
  }

  ProductState copyWith({
    List<Product>? listOfAllProducts,
    List<Product>? listOfFilteredProducts,
    List<Product>? selectedProducts,
    List<Supplier>? listOfSuppliers,
    List<Product>? listOfNotUpdatedProductsOnMassEditing,
    MainSettings? mainSettings,
    FirebaseFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingProductOnUpdateQuantity,
    bool? isLoadingProductsOnObserve,
    bool? isLoadingProductOnCreate,
    bool? isLoadingProductOnDelete,
    bool? isLoadingProductSuppliersOnObseve,
    bool? isLoadingProductOnMassEditing,
    Option<Either<FirebaseFailure, List<Product>>>? fosProductsOnObserveOption,
    Option<Either<FirebaseFailure, Product>>? fosProductOnCreateOption,
    Option<Either<FirebaseFailure, Unit>>? fosProductOnDeleteOption,
    Option<Either<FirebaseFailure, List<Supplier>>>? fosProductSuppliersOnObserveOption,
    bool? isLoadingOnMassEditActivateProductMarketplace,
    Option<Either<FirebaseFailure, Product>>? fosProductOnUpdateQuantityOption,
    Option<Either<FirebaseFailure, Unit>>? fosMassEditActivateProductMarketplaceOption,
    Option<Either<FirebaseFailure, Unit>>? fosMassEditProductsOption,
    Option<Either<PrestaFailure, Unit>>? fosProductOnEditQuantityPrestaOption,
    TextEditingController? productSearchController,
    bool? triggerPop,
    bool? isWidthSearchActive,
    bool? isSelectedAllProducts,
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
      isLoadingOnMassEditActivateProductMarketplace:
          isLoadingOnMassEditActivateProductMarketplace ?? this.isLoadingOnMassEditActivateProductMarketplace,
      fosProductOnUpdateQuantityOption: fosProductOnUpdateQuantityOption ?? this.fosProductOnUpdateQuantityOption,
      fosMassEditActivateProductMarketplaceOption: fosMassEditActivateProductMarketplaceOption ?? this.fosMassEditActivateProductMarketplaceOption,
      fosMassEditProductsOption: fosMassEditProductsOption ?? this.fosMassEditProductsOption,
      fosProductOnEditQuantityPrestaOption: fosProductOnEditQuantityPrestaOption ?? this.fosProductOnEditQuantityPrestaOption,
      productSearchController: productSearchController ?? this.productSearchController,
      triggerPop: triggerPop ?? this.triggerPop,
      isWidthSearchActive: isWidthSearchActive ?? this.isWidthSearchActive,
      isSelectedAllProducts: isSelectedAllProducts ?? this.isSelectedAllProducts,
    );
  }
}
