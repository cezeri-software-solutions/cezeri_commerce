import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:flutter/material.dart';

import '../../../../3_domain/entities/incoming_invoice/incoming_invoice.dart';
import '../../../../constants.dart';

class IncomingInvoiceTotalPositionsView extends StatelessWidget {
  final IncomingInvoice invoice;
  final double? containerWidth;

  const IncomingInvoiceTotalPositionsView({super.key, required this.invoice, this.containerWidth});

  @override
  Widget build(BuildContext context) {
    return MyFormFieldContainer(
      padding: const EdgeInsets.all(10),
      borderRadius: 10,
      width: containerWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [const Text('Gesamt aus Positionen', style: TextStyles.defaultBoldPrimary), const Divider(), _TotalSumView(invoice: invoice)],
      ),
    );
  }
}

class _TotalSumView extends StatelessWidget {
  final IncomingInvoice invoice;

  const _TotalSumView({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [const Text('Netto'), Text('${invoice.totalPositions.netAmount.toMyCurrencyStringToShow()} €')],
        ),
        Gaps.h8,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [const Text('MwSt.'), Text('${invoice.totalPositions.taxAmount.toMyCurrencyStringToShow()} €')],
        ),
        Gaps.h8,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [const Text('Brutto'), Text('${invoice.totalPositions.grossAmount.toMyCurrencyStringToShow()} €')],
        ),
      ],
    );
  }
}
