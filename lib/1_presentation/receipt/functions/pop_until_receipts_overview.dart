import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../routes/router.gr.dart';

void popUntilBase(BuildContext context, ReceiptType receiptType) => context.router.popUntilRouteWithName(switch (receiptType) {
      ReceiptType.offer => OffersOverviewRoute.name,
      ReceiptType.appointment => AppointmentsOverviewRoute.name,
      ReceiptType.deliveryNote => DeliveryNotesOverviewRoute.name,
      ReceiptType.invoice || ReceiptType.credit => InvoicesOverviewRoute.name,
    });
