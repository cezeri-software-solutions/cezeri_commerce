import 'package:flutter/material.dart';

import '../../../2_application/database/receipt_detail/receipt_detail_bloc.dart';
import '../../../3_domain/entities/address.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../constants.dart';
import '../../core/core.dart';
import '../sheets/receipt_detail_update_customer.dart';

enum ReceiptDetailAddressTyp { shipping, invoice }

class ReceiptDetailAddressCard extends StatefulWidget {
  final ReceiptDetailBloc receiptDetailBloc;
  final Receipt receipt;

  const ReceiptDetailAddressCard({super.key, required this.receipt, required this.receiptDetailBloc});

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.receipt.receiptCustomer.customerNumber.toString(), style: TextStyles.defaultBold),
                Text(widget.receipt.receiptCustomer.name, style: TextStyles.h3BoldPrimary),
                InkWell(
                  onTap: () => updateCustomerFromReceiptDetail(
                      context: context, receiptDetailBloc: widget.receiptDetailBloc, customerId: widget.receipt.customerId),
                  child: const Icon(Icons.edit, color: CustomColors.primaryColor),
                ),
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
            _ReceiptDetailCustomerAddressContainer(address: shownAddress, receiptDetailBloc: widget.receiptDetailBloc)
          ],
        ),
      ),
    );
  }
}

class _ReceiptDetailCustomerAddressContainer extends StatelessWidget {
  final ReceiptDetailBloc receiptDetailBloc;
  final Address address;

  const _ReceiptDetailCustomerAddressContainer({required this.address, required this.receiptDetailBloc});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddressColumn(address: address, showStreet2: true),
        const Spacer(),
        IconButton(
          onPressed: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => MyAddressUpdateSheet(
              address: address,
              onSave: (newAddress) => receiptDetailBloc.add(ReceiptDetailEditAddressEvent(address: newAddress)),
            ),
          ),
          icon: const Icon(Icons.edit, color: CustomColors.primaryColor),
        ),
      ],
    );
  }
}
