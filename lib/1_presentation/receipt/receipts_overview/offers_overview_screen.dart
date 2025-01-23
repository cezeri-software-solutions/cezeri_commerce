import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../3_domain/entities/receipt/receipt.dart';
import 'receipts_overview_screen.dart';

@RoutePage()
class OffersOverviewScreen extends StatelessWidget {
  final String receiptTyp;

  const OffersOverviewScreen({super.key, @PathParam('receiptType') required this.receiptTyp});

  @override
  Widget build(BuildContext context) {
    return ReceiptsOverviewScreen(receiptType: receiptTyp.toEnumRT());
  }
}
