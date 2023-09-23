part of 'marketplace_bloc.dart';

@immutable
abstract class MarketplaceEvent {}

class SetMarketplaceStateToInitialEvent extends MarketplaceEvent {}

class GetAllMarketplacesEvent extends MarketplaceEvent {}

class GetMarketplaceEvent extends MarketplaceEvent {
  final String id;

  GetMarketplaceEvent({required this.id});
}

class CreateMarketplaceEvent extends MarketplaceEvent {
  final Marketplace marketplace;

  CreateMarketplaceEvent({required this.marketplace});
}

class UpdateMarketplaceEvent extends MarketplaceEvent {
  final Marketplace marketplace;

  UpdateMarketplaceEvent({required this.marketplace});
}

class DeleteMarketplaceEvent extends MarketplaceEvent {
  final String id;

  DeleteMarketplaceEvent({required this.id});
}
