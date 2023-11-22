import '../../../entities_presta/order_presta.dart';
import '../../marketplace/marketplace.dart';

class ToLoadAppointmentsFromMarketplace {
  final Marketplace marketplace;
  final int nextIdToImport;
  final int lastIdToImport;

  ToLoadAppointmentsFromMarketplace({
    required this.marketplace,
    required this.nextIdToImport,
    required this.lastIdToImport,
  });
}

class ToLoadAppointmentFromMarketplace {
  final Marketplace marketplace;
  final int orderId;

  ToLoadAppointmentFromMarketplace({
    required this.marketplace,
    required this.orderId,
  });
}

class LoadedOrderFromMarketplace {
  final Marketplace marketplace;
  final OrderPresta orderPresta;
  final int orderMarketplaceId;

  LoadedOrderFromMarketplace({
    required this.marketplace,
    required this.orderPresta,
    required this.orderMarketplaceId,
  });
}
