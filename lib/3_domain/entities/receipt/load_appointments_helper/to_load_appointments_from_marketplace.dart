import '../../../../4_infrastructur/repositories/prestashop_api/models/order_presta.dart';
import '../../../../4_infrastructur/repositories/shopify_api/shopify.dart';
import '../../marketplace/abstract_marketplace.dart';

class ToLoadAppointmentsFromMarketplace {
  final AbstractMarketplace marketplace;
  final int nextIdToImport;
  final int lastIdToImport;

  ToLoadAppointmentsFromMarketplace({
    required this.marketplace,
    required this.nextIdToImport,
    required this.lastIdToImport,
  });
}

class ToLoadAppointmentFromMarketplace {
  final AbstractMarketplace marketplace;
  final int orderId;

  ToLoadAppointmentFromMarketplace({
    required this.marketplace,
    required this.orderId,
  });
}

class LoadedOrderFromMarketplace {
  final AbstractMarketplace marketplace;
  final OrderPresta? orderPresta;
  final OrderShopify? orderShopify;
  final int orderMarketplaceId;

  LoadedOrderFromMarketplace({
    required this.marketplace,
    this.orderPresta,
    this.orderShopify,
    required this.orderMarketplaceId,
  });
}
