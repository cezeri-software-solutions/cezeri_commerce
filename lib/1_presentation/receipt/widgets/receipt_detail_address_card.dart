import 'package:flutter/material.dart';

import '../../../3_domain/entities/address.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../constants.dart';

enum ReceiptDetailAddressTyp { shipping, invoice }

class ReceiptDetailAddressCard extends StatefulWidget {
  final Receipt receipt;

  const ReceiptDetailAddressCard({super.key, required this.receipt});

  @override
  State<ReceiptDetailAddressCard> createState() => _ReceiptDetailAddressCardState();
}

class _ReceiptDetailAddressCardState extends State<ReceiptDetailAddressCard> {
  ReceiptDetailAddressTyp _addressType = ReceiptDetailAddressTyp.shipping;

  @override
  Widget build(BuildContext context) {
    final deliveryAddress = widget.receipt.receiptCustomer.listOfAddress.where((e) => e.addressType == AddressType.delivery && e.isDefault).first;
    final invoiceAddress = widget.receipt.receiptCustomer.listOfAddress.where((e) => e.addressType == AddressType.invoice && e.isDefault).first;
    final shownAddress = switch (_addressType) {
      ReceiptDetailAddressTyp.shipping => deliveryAddress,
      ReceiptDetailAddressTyp.invoice => invoiceAddress,
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(alignment: Alignment.center, child: Text(widget.receipt.receiptCustomer.name, style: TextStyles.h3BoldPrimary)),
            const Divider(height: 30),
            DefaultTabController(
              length: 2,
              child: TabBar(
                tabs: const [Tab(text: 'Lieferadresse'), Tab(text: 'Rechnungsadresse')],
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(),
                onTap: (value) =>
                    setState(() => value == 0 ? _addressType = ReceiptDetailAddressTyp.shipping : _addressType = ReceiptDetailAddressTyp.invoice),
              ),
            ),
            Gaps.h16,
            _ReceiptDetailCustomerAddressContainer(address: shownAddress)
          ],
        ),
      ),
    );
  }
}

class _ReceiptDetailCustomerAddressContainer extends StatelessWidget {
  final Address address;

  const _ReceiptDetailCustomerAddressContainer({required this.address});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(address.companyName),
        Text(address.name),
        Text(address.street),
        Text(address.street2),
        Text.rich(TextSpan(children: [
          TextSpan(text: address.postcode),
          const TextSpan(text: ' '),
          TextSpan(text: address.city),
        ])),
        Text(address.country.name),
      ],
    );
  }
}
