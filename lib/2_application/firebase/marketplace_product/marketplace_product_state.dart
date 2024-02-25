part of 'marketplace_product_bloc.dart';

class MarketplaceProductState {
  final ProductMarketplace? productMarketplace;
  //* Prestashop
  final ProductPresta? marketplaceProductPresta;
  final List<CategoryPresta>? listOfCategoriesPrestaOriginal;
  final List<CategoryPresta>? listOfCategoriesPresta;
  //* Shopify
  final ProductShopify? marketplaceProductShopify;
  final List<CustomCollectionShopify>? listOfCategoriesShopifyOriginal;
  final List<CustomCollectionShopify>? listOfCategoriesShopify;
  //* ###############
  final AbstractFailure? firebaseFailure;
  final AbstractFailure? marketplaceFailure;
  final bool isAnyFirebaseFailure;
  final bool isAnyPrestaFailure;
  final bool isLoadingMarketplaceProductCategoriesOnObserve;
  final Option<Either<AbstractFailure, AbstractMarketplace>> fosMarketplaceProductMarketplaceOnObserveOption;
  final Option<Either<AbstractFailure, List<CategoryPresta>>> fosMarketplaceProductCategoriesOnObserveOption;

  //* Helper Category
  final List<bool> isExpanded;
  final List<bool> isSelected;
  final String? defaultCategory;

  MarketplaceProductState({
    required this.productMarketplace,
    required this.marketplaceProductPresta,
    required this.listOfCategoriesPrestaOriginal,
    required this.listOfCategoriesPresta,
    required this.marketplaceProductShopify,
    required this.listOfCategoriesShopifyOriginal,
    required this.listOfCategoriesShopify,
    required this.firebaseFailure,
    required this.marketplaceFailure,
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
      marketplaceProductShopify: null,
      listOfCategoriesShopifyOriginal: null,
      listOfCategoriesShopify: null,
      firebaseFailure: null,
      marketplaceFailure: null,
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
    ProductPresta? marketplaceProductPresta,
    List<CategoryPresta>? listOfCategoriesPrestaOriginal,
    List<CategoryPresta>? listOfCategoriesPresta,
    ProductShopify? marketplaceProductShopify,
    List<CustomCollectionShopify>? listOfCategoriesShopifyOriginal,
    List<CustomCollectionShopify>? listOfCategoriesShopify,
    AbstractFailure? firebaseFailure,
    AbstractFailure? marketplaceFailure,
    bool? isAnyFirebaseFailure,
    bool? isAnyPrestaFailure,
    bool? isLoadingMarketplaceProductCategoriesOnObserve,
    Option<Either<AbstractFailure, AbstractMarketplace>>? fosMarketplaceProductMarketplaceOnObserveOption,
    Option<Either<AbstractFailure, List<CategoryPresta>>>? fosMarketplaceProductCategoriesOnObserveOption,
    List<bool>? isExpanded,
    List<bool>? isSelected,
    String? defaultCategory,
  }) {
    return MarketplaceProductState(
      productMarketplace: productMarketplace ?? this.productMarketplace,
      marketplaceProductPresta: marketplaceProductPresta ?? this.marketplaceProductPresta,
      listOfCategoriesPrestaOriginal: listOfCategoriesPrestaOriginal ?? this.listOfCategoriesPrestaOriginal,
      listOfCategoriesPresta: listOfCategoriesPresta ?? this.listOfCategoriesPresta,
      marketplaceProductShopify: marketplaceProductShopify ?? this.marketplaceProductShopify,
      listOfCategoriesShopifyOriginal: listOfCategoriesShopifyOriginal ?? this.listOfCategoriesShopifyOriginal,
      listOfCategoriesShopify: listOfCategoriesShopify ?? this.listOfCategoriesShopify,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      marketplaceFailure: marketplaceFailure ?? this.marketplaceFailure,
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
