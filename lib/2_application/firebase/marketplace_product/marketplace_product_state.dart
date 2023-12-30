part of 'marketplace_product_bloc.dart';

class MarketplaceProductState {
  final ProductMarketplace? productMarketplace;
  final MarketplaceProductPresta? marketplaceProductPresta;
  final List<CategoryPresta>? listOfCategoriesPresta;
  final FirebaseFailure? firebaseFailure;
  final PrestaFailure? prestaFailure;
  final bool isAnyFirebaseFailure;
  final bool isAnyPrestaFailure;
  final bool isLoadingMarketplaceProductCategoriesOnObserve;
  final Option<Either<FirebaseFailure, Marketplace>> fosMarketplaceProductMarketplaceOnObserveOption;
  final Option<Either<PrestaFailure, List<CategoryPresta>>> fosMarketplaceProductCategoriesOnObserveOption;

  MarketplaceProductState({
    required this.productMarketplace,
    required this.marketplaceProductPresta,
    required this.listOfCategoriesPresta,
    required this.firebaseFailure,
    required this.prestaFailure,
    required this.isAnyFirebaseFailure,
    required this.isAnyPrestaFailure,
    required this.isLoadingMarketplaceProductCategoriesOnObserve,
    required this.fosMarketplaceProductMarketplaceOnObserveOption,
    required this.fosMarketplaceProductCategoriesOnObserveOption,
  });

  factory MarketplaceProductState.initial() {
    return MarketplaceProductState(
      productMarketplace: null,
      marketplaceProductPresta: null,
      listOfCategoriesPresta: null,
      firebaseFailure: null,
      prestaFailure: null,
      isAnyFirebaseFailure: false,
      isAnyPrestaFailure: false,
      isLoadingMarketplaceProductCategoriesOnObserve: false,
      fosMarketplaceProductMarketplaceOnObserveOption: none(),
      fosMarketplaceProductCategoriesOnObserveOption: none(),
    );
  }

  MarketplaceProductState copyWith({
    ProductMarketplace? productMarketplace,
    MarketplaceProductPresta? marketplaceProductPresta,
    List<CategoryPresta>? listOfCategoriesPresta,
    FirebaseFailure? firebaseFailure,
    PrestaFailure? prestaFailure,
    bool? isAnyFirebaseFailure,
    bool? isAnyPrestaFailure,
    bool? isLoadingMarketplaceProductCategoriesOnObserve,
    Option<Either<FirebaseFailure, Marketplace>>? fosMarketplaceProductMarketplaceOnObserveOption,
    Option<Either<PrestaFailure, List<CategoryPresta>>>? fosMarketplaceProductCategoriesOnObserveOption,
  }) {
    return MarketplaceProductState(
      productMarketplace: productMarketplace ?? this.productMarketplace,
      marketplaceProductPresta: marketplaceProductPresta ?? this.marketplaceProductPresta,
      listOfCategoriesPresta: listOfCategoriesPresta ?? this.listOfCategoriesPresta,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      prestaFailure: prestaFailure ?? this.prestaFailure,
      isAnyFirebaseFailure: isAnyFirebaseFailure ?? this.isAnyFirebaseFailure,
      isAnyPrestaFailure: isAnyPrestaFailure ?? this.isAnyPrestaFailure,
      isLoadingMarketplaceProductCategoriesOnObserve:
          isLoadingMarketplaceProductCategoriesOnObserve ?? this.isLoadingMarketplaceProductCategoriesOnObserve,
      fosMarketplaceProductMarketplaceOnObserveOption:
          fosMarketplaceProductMarketplaceOnObserveOption ?? this.fosMarketplaceProductMarketplaceOnObserveOption,
      fosMarketplaceProductCategoriesOnObserveOption:
          fosMarketplaceProductCategoriesOnObserveOption ?? this.fosMarketplaceProductCategoriesOnObserveOption,
    );
  }
}
