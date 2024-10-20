import 'package:cezeri_commerce/3_domain/entities/incoming_invoice/incoming_invoice_supplier.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../core/core.dart';

class IncomingInvoiceSupplierView extends StatelessWidget {
  final IncomingInvoiceSupplier supplier;
  final double? containerWidth;

  const IncomingInvoiceSupplierView({super.key, required this.supplier, this.containerWidth});

  @override
  Widget build(BuildContext context) {
    return MyFormFieldContainer(
      padding: const EdgeInsets.all(10),
      borderRadius: 10,
      width: containerWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(supplier.company, style: TextStyles.defaultBoldPrimary), const Divider(), _SupplierView(supplier: supplier)],
      ),
    );
  }
}

class _SupplierView extends StatelessWidget {
  final IncomingInvoiceSupplier supplier;

  const _SupplierView({required this.supplier});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (supplier.company.isNotEmpty) Text(supplier.company),
        if (supplier.name.isNotEmpty) Text(supplier.name),
        if (supplier.street.isNotEmpty) Text(supplier.street),
        if (supplier.postcode.isNotEmpty || supplier.city.isNotEmpty)
          Text.rich(TextSpan(children: [
            if (supplier.postcode.isNotEmpty) TextSpan(text: supplier.postcode),
            if (supplier.postcode.isNotEmpty) const TextSpan(text: ' '),
            if (supplier.city.isNotEmpty) TextSpan(text: supplier.city),
          ])),
        if (supplier.country.isNotEmpty) Text(supplier.country),
      ],
    );
  }
}
