import 'package:flutter/material.dart';

import '../../../2_application/database/receipt/receipt_bloc.dart';
import '../../../3_domain/entities/address.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../constants.dart';
import '../../core/widgets/my_address_update_sheet.dart';

enum ReceiptDetailAddressTyp { shipping, invoice }

class ReceiptDetailAddressCard extends StatefulWidget {
  final ReceiptBloc receiptBloc;
  final Receipt receipt;

  const ReceiptDetailAddressCard({super.key, required this.receipt, required this.receiptBloc});

  @override
  State<ReceiptDetailAddressCard> createState() => _ReceiptDetailAddressCardState();
}

class _ReceiptDetailAddressCardState extends State<ReceiptDetailAddressCard> {
  ReceiptDetailAddressTyp _addressType = ReceiptDetailAddressTyp.shipping;

  @override
  Widget build(BuildContext context) {
    final shownAddress = switch (_addressType) {
      ReceiptDetailAddressTyp.shipping => widget.receipt.addressDelivery,
      ReceiptDetailAddressTyp.invoice => widget.receipt.addressInvoice,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Align(alignment: Alignment.center, child: Text(widget.receipt.receiptCustomer.name, style: TextStyles.h3BoldPrimary)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.receipt.receiptCustomer.customerNumber.toString(), style: TextStyles.defaultBold),
                Text(widget.receipt.receiptCustomer.name, style: TextStyles.h3BoldPrimary),
                InkWell(onTap: () {}, child: const Icon(Icons.edit, color: CustomColors.primaryColor)),
              ],
            ),
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
            _ReceiptDetailCustomerAddressContainer(address: shownAddress, receiptBloc: widget.receiptBloc)
          ],
        ),
      ),
    );
  }
}

class _ReceiptDetailCustomerAddressContainer extends StatelessWidget {
  final ReceiptBloc receiptBloc;
  final Address address;

  const _ReceiptDetailCustomerAddressContainer({required this.address, required this.receiptBloc});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (address.companyName.isNotEmpty) Text(address.companyName),
            if (address.name.isNotEmpty) Text(address.name),
            if (address.street.isNotEmpty) Text(address.street),
            if (address.street2.isNotEmpty) Text(address.street2),
            if (address.postcode.isNotEmpty && address.city.isNotEmpty)
              Text.rich(TextSpan(children: [
                TextSpan(text: address.postcode),
                const TextSpan(text: ' '),
                TextSpan(text: address.city),
              ])),
            if (address.country.name.isNotEmpty) Text(address.country.name),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => MyAddressUpdateSheet(
              address: address,
              onSave: (newAddress) {
                print('onSave ausgeführt');
                receiptBloc.add(OnEditAddressReceiptDetailEvent(address: newAddress));
              },
            ),
          ),
          icon: const Icon(Icons.edit, color: CustomColors.primaryColor),
        ),
      ],
    );
  }
}
