part of 'marketplace_product_bloc.dart';

abstract class MarketplaceProductEvent {}

class SetMarketplaceProductStatesToInitialEvent extends MarketplaceProductEvent {}

class SetMarketplaceProductEvent extends MarketplaceProductEvent {
  final ProductMarketplace productMarketplace;

  SetMarketplaceProductEvent({required this.productMarketplace});
}

class SetMarketplaceProductIsActiveEvent extends MarketplaceProductEvent {
  final dynamic value;

  SetMarketplaceProductIsActiveEvent({required this.value});
}

class GetMarketplaceCategoriesEvent extends MarketplaceProductEvent {}

class SetListOfCategoriesPrestaToOriginalEvent extends MarketplaceProductEvent {}

class OnCategoriesIsExpandedChangedEvent extends MarketplaceProductEvent {
  final int index;

  OnCategoriesIsExpandedChangedEvent({required this.index});
}

class OnCategoriesIsSelectedChangedEvent extends MarketplaceProductEvent {
  final int index;
  final bool value;
  final int? id;

  OnCategoriesIsSelectedChangedEvent({required this.index, required this.value, this.id});
}

class OnDefaultCategoryChangedEvent extends MarketplaceProductEvent {
  final int id;
  final int index;

  OnDefaultCategoryChangedEvent({required this.id, required this.index});
}

class OnSetUpdatedCategoriesEvent extends MarketplaceProductEvent {}

class OnSearchControllerChangedEvent extends MarketplaceProductEvent {}
class OnSearchControllerClearedEvent extends MarketplaceProductEvent {}
