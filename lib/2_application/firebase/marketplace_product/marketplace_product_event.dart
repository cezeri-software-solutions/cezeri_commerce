part of 'marketplace_product_bloc.dart';

abstract class MarketplaceProductEvent {}

class SetMarketplaceProductEvent extends MarketplaceProductEvent {
  final ProductMarketplace productMarketplace;

  SetMarketplaceProductEvent({required this.productMarketplace});
}

class SetMarketplaceProductIsActiveEvent extends MarketplaceProductEvent {
  final bool value;

  SetMarketplaceProductIsActiveEvent({required this.value});
}

class GetMarketplaceCategoriesEvent extends MarketplaceProductEvent {}
