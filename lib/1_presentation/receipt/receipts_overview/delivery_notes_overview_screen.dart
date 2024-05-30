import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../3_domain/entities/receipt/receipt.dart';
import 'receipts_overview_screen.dart';

@RoutePage()
class DeliveryNotesOverviewScreen extends StatelessWidget {
  final ReceiptTyp receiptTyp;

  const DeliveryNotesOverviewScreen({super.key, required this.receiptTyp});

  @override
  Widget build(BuildContext context) {
    return ReceiptsOverviewScreen(receiptTyp: receiptTyp);
  }
}
