part of 'marketplace_product_bloc.dart';

class MarketplaceProductState {
  final ProductMarketplace? productMarketplace;
  final MarketplaceProductPresta? marketplaceProductPresta;
  final List<CategoryPresta>? listOfCategoriesPrestaOriginal;
  final List<CategoryPresta>? listOfCategoriesPresta;
  final AbstractFailure? firebaseFailure;
  final PrestaFailure? prestaFailure;
  final bool isAnyFirebaseFailure;
  final bool isAnyPrestaFailure;
  final bool isLoadingMarketplaceProductCategoriesOnObserve;
  final Option<Either<AbstractFailure, MarketplacePresta>> fosMarketplaceProductMarketplaceOnObserveOption;
  final Option<Either<PrestaFailure, List<CategoryPresta>>> fosMarketplaceProductCategoriesOnObserveOption;

  //* Helper Category
  final List<bool> isExpanded;
  final List<bool> isSelected;
  final String? defaultCategory;

  MarketplaceProductState({
    required this.productMarketplace,
    required this.marketplaceProductPresta,
    required this.listOfCategoriesPrestaOriginal,
    required this.listOfCategoriesPresta,
    required this.firebaseFailure,
    required this.prestaFailure,
    required this.isAnyFirebaseFailure,
    required this.isAnyPrestaFailure,
    required this.isLoadingMarketplaceProductCategoriesOnObserve,
    required this.fosMarketplaceProductMarketplaceOnObserveOption,
    required this.fosMarketplaceProductCategoriesOnObserveOption,
    required this.isExpanded,
    required this.isSelected,
    required this.defaultCategory,
  });

  factory MarketplaceProductState.initial() {
    return MarketplaceProductState(
      productMarketplace: null,
      marketplaceProductPresta: null,
      listOfCategoriesPrestaOriginal: null,
      listOfCategoriesPresta: null,
      firebaseFailure: null,
      prestaFailure: null,
      isAnyFirebaseFailure: false,
      isAnyPrestaFailure: false,
      isLoadingMarketplaceProductCategoriesOnObserve: false,
      fosMarketplaceProductMarketplaceOnObserveOption: none(),
      fosMarketplaceProductCategoriesOnObserveOption: none(),
      isExpanded: [],
      isSelected: [],
      defaultCategory: null,
    );
  }

  MarketplaceProductState copyWith({
    ProductMarketplace? productMarketplace,
    MarketplaceProductPresta? marketplaceProductPresta,
    List<CategoryPresta>? listOfCategoriesPrestaOriginal,
    List<CategoryPresta>? listOfCategoriesPresta,
    AbstractFailure? firebaseFailure,
    PrestaFailure? prestaFailure,
    bool? isAnyFirebaseFailure,
    bool? isAnyPrestaFailure,
    bool? isLoadingMarketplaceProductCategoriesOnObserve,
    Option<Either<AbstractFailure, MarketplacePresta>>? fosMarketplaceProductMarketplaceOnObserveOption,
    Option<Either<PrestaFailure, List<CategoryPresta>>>? fosMarketplaceProductCategoriesOnObserveOption,
    List<bool>? isExpanded,
    List<bool>? isSelected,
    String? defaultCategory,
  }) {
    return MarketplaceProductState(
      productMarketplace: productMarketplace ?? this.productMarketplace,
      marketplaceProductPresta: marketplaceProductPresta ?? this.marketplaceProductPresta,
      listOfCategoriesPrestaOriginal: listOfCategoriesPrestaOriginal ?? this.listOfCategoriesPrestaOriginal,
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
      isExpanded: isExpanded ?? this.isExpanded,
      isSelected: isSelected ?? this.isSelected,
      defaultCategory: defaultCategory ?? this.defaultCategory,
    );
  }
}
