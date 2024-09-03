part of 'marketplace_bloc.dart';

@immutable
abstract class MarketplaceEvent {}

class SetMarketplaceStateToInitialEvent extends MarketplaceEvent {}

class GetAllMarketplacesEvent extends MarketplaceEvent {
  final MarketplaceType? type;

  GetAllMarketplacesEvent({this.type});
}

class GetMarketplaceEvent extends MarketplaceEvent {
  final String id;

  GetMarketplaceEvent({required this.id});
}

class CreateMarketplaceEvent extends MarketplaceEvent {
  final AbstractMarketplace marketplace;
  final File? imageFile;

  CreateMarketplaceEvent({required this.marketplace, required this.imageFile});
}

class UpdateMarketplaceEvent extends MarketplaceEvent {
  final AbstractMarketplace marketplace;
  final File? imageFile;

  UpdateMarketplaceEvent({required this.marketplace, required this.imageFile});
}

class DeleteMarketplaceEvent extends MarketplaceEvent {
  final String id;

  DeleteMarketplaceEvent({required this.id});
}

class OnAddMarketplaceEMailAutomationEvent extends MarketplaceEvent {
  final AbstractMarketplace marketplace;
  final EMailAutomation eMailAutomation;

  OnAddMarketplaceEMailAutomationEvent({required this.marketplace, required this.eMailAutomation});
}

class OnUpdateMarketplaceEMailAutomationEvent extends MarketplaceEvent {
  final AbstractMarketplace marketplace;
  final EMailAutomation eMailAutomation;

  OnUpdateMarketplaceEMailAutomationEvent({required this.marketplace, required this.eMailAutomation});
}
