import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../3_domain/entities/incoming_invoice/incoming_invoice.dart';
import '../../../../constants.dart';

class IncomingInvoicesAppBarTitle extends StatelessWidget {
  final List<IncomingInvoice>? listOfInvoices;
  final List<IncomingInvoice> selectedInvoices;

  const IncomingInvoicesAppBarTitle({super.key, this.listOfInvoices, required this.selectedInvoices});

  @override
  Widget build(BuildContext context) {
    if (listOfInvoices == null || selectedInvoices.isEmpty) return const Text('Eingangsrechnungen');

    final isTabletOrLarger = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);

    final mainTitle = Text.rich(TextSpan(children: [
      const TextSpan(text: 'Artikel'),
      const TextSpan(text: ' '),
      TextSpan(text: '(${listOfInvoices!.length})', style: TextStyles.h3),
    ]));

    if (selectedInvoices.isEmpty) return mainTitle;

    return InkWell(
      onTap: () {}, // showMyDialogProducts(context: context, productsList: selectedProducts),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text.rich(TextSpan(children: [
          if (isTabletOrLarger) const TextSpan(text: 'Ausgewählte Eingangsrechnungen'),
          const TextSpan(text: ' '),
          TextSpan(text: '(${selectedInvoices.length})', style: TextStyles.h3),
        ])),
      ),
    );
  }
}
