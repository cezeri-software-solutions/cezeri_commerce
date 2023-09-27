part of 'product_bloc.dart';

@immutable
class ProductState {
  final Product? product;
  final List<Product>? listOfAllProducts;
  final List<Product>? listOfFilteredProducts; // Der State, der im presentation layer ausgegeben wird, egal ob Suchfeld leer oder nicht
  final List<Product> selectedProducts; // Ausgewählte Produkte zum löschen oder für Massenbearbeitung
  final FirebaseFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingProductOnObserve;
  final bool isLoadingProductsOnObserve;
  final bool isLoadingProductOnCreate;
  final bool isLoadingProductOnUpdate;
  final bool isLoadingProductOnDelete;
  final Option<Either<FirebaseFailure, Product>> fosProductOnObserveOption;
  final Option<Either<FirebaseFailure, List<Product>>> fosProductsOnObserveOption;
  final Option<Either<FirebaseFailure, Product>> fosProductOnCreateOption;
  final Option<Either<FirebaseFailure, Unit>> fosProductOnUpdateOption;
  final Option<Either<FirebaseFailure, Unit>> fosProductOnDeleteOption;

  final bool isLoadingOnMassEditActivateProductMarketplace;
  final Option<Either<FirebaseFailure, Product>> fosProductOnUpdateQuantityOption;
  final Option<Either<FirebaseFailure, Unit>> fosMassEditActivateProductMarketplaceOption;

  //* Prestashop States
  final Option<Either<PrestaFailure, Unit>> fosProductOnEditQuantityPrestaOption;
  //* Helpers
  final String productSearchText;

  const ProductState({
    required this.product,
    required this.listOfAllProducts,
    required this.listOfFilteredProducts,
    required this.selectedProducts,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingProductOnObserve,
    required this.isLoadingProductsOnObserve,
    required this.isLoadingProductOnCreate,
    required this.isLoadingProductOnUpdate,
    required this.isLoadingProductOnDelete,
    required this.fosProductOnObserveOption,
    required this.fosProductsOnObserveOption,
    required this.fosProductOnCreateOption,
    required this.fosProductOnUpdateOption,
    required this.fosProductOnDeleteOption,
    required this.isLoadingOnMassEditActivateProductMarketplace,
    required this.fosProductOnUpdateQuantityOption,
    required this.fosMassEditActivateProductMarketplaceOption,
    required this.fosProductOnEditQuantityPrestaOption,
    required this.productSearchText,
  });

  factory ProductState.initial() {
    return ProductState(
      product: null,
      listOfAllProducts: null,
      listOfFilteredProducts: null,
      selectedProducts: const [],
      firebaseFailure: null,
      isAnyFailure: false,
      isLoadingProductOnObserve: false,
      isLoadingProductsOnObserve: true,
      isLoadingProductOnCreate: false,
      isLoadingProductOnUpdate: false,
      isLoadingProductOnDelete: false,
      fosProductOnObserveOption: none(),
      fosProductsOnObserveOption: none(),
      fosProductOnCreateOption: none(),
      fosProductOnUpdateOption: none(),
      fosProductOnDeleteOption: none(),
      isLoadingOnMassEditActivateProductMarketplace: false,
      fosProductOnUpdateQuantityOption: none(),
      fosMassEditActivateProductMarketplaceOption: none(),
      fosProductOnEditQuantityPrestaOption: none(),
      productSearchText: '',
    );
  }

  ProductState copyWith({
    Product? product,
    List<Product>? listOfAllProducts,
    List<Product>? listOfFilteredProducts,
    List<Product>? selectedProducts,
    FirebaseFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingProductOnObserve,
    bool? isLoadingProductsOnObserve,
    bool? isLoadingProductOnCreate,
    bool? isLoadingProductOnUpdate,
    bool? isLoadingProductOnDelete,
    Option<Either<FirebaseFailure, Product>>? fosProductOnObserveOption,
    Option<Either<FirebaseFailure, List<Product>>>? fosProductsOnObserveOption,
    Option<Either<FirebaseFailure, Product>>? fosProductOnCreateOption,
    Option<Either<FirebaseFailure, Unit>>? fosProductOnUpdateOption,
    Option<Either<FirebaseFailure, Unit>>? fosProductOnDeleteOption,
    bool? isLoadingOnMassEditActivateProductMarketplace,
    Option<Either<FirebaseFailure, Product>>? fosProductOnUpdateQuantityOption,
    Option<Either<FirebaseFailure, Unit>>? fosMassEditActivateProductMarketplaceOption,
    Option<Either<PrestaFailure, Unit>>? fosProductOnEditQuantityPrestaOption,
    String? productSearchText,
  }) {
    return ProductState(
      product: product ?? this.product,
      listOfAllProducts: listOfAllProducts ?? this.listOfAllProducts,
      listOfFilteredProducts: listOfFilteredProducts ?? this.listOfFilteredProducts,
      selectedProducts: selectedProducts ?? this.selectedProducts,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingProductOnObserve: isLoadingProductOnObserve ?? this.isLoadingProductOnObserve,
      isLoadingProductsOnObserve: isLoadingProductsOnObserve ?? this.isLoadingProductsOnObserve,
      isLoadingProductOnCreate: isLoadingProductOnCreate ?? this.isLoadingProductOnCreate,
      isLoadingProductOnUpdate: isLoadingProductOnUpdate ?? this.isLoadingProductOnUpdate,
      isLoadingProductOnDelete: isLoadingProductOnDelete ?? this.isLoadingProductOnDelete,
      fosProductOnObserveOption: fosProductOnObserveOption ?? this.fosProductOnObserveOption,
      fosProductsOnObserveOption: fosProductsOnObserveOption ?? this.fosProductsOnObserveOption,
      fosProductOnCreateOption: fosProductOnCreateOption ?? this.fosProductOnCreateOption,
      fosProductOnUpdateOption: fosProductOnUpdateOption ?? this.fosProductOnUpdateOption,
      fosProductOnDeleteOption: fosProductOnDeleteOption ?? this.fosProductOnDeleteOption,
      isLoadingOnMassEditActivateProductMarketplace:
          isLoadingOnMassEditActivateProductMarketplace ?? this.isLoadingOnMassEditActivateProductMarketplace,
      fosProductOnUpdateQuantityOption: fosProductOnUpdateQuantityOption ?? this.fosProductOnUpdateQuantityOption,
      fosMassEditActivateProductMarketplaceOption: fosMassEditActivateProductMarketplaceOption ?? this.fosMassEditActivateProductMarketplaceOption,
      fosProductOnEditQuantityPrestaOption: fosProductOnEditQuantityPrestaOption ?? this.fosProductOnEditQuantityPrestaOption,
      productSearchText: productSearchText ?? this.productSearchText,
    );
  }
}
