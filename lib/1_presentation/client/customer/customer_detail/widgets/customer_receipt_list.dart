import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../2_application/database/customer_detail/customer_detail_bloc.dart';
import '../../../../../3_domain/entities/receipt/receipt.dart';
import '../../../../../constants.dart';

class CustomerReceiptList extends StatelessWidget {
  final CustomerDetailBloc customerDetailBloc;
  final CustomerDetailState state;

  const CustomerReceiptList({super.key, required this.customerDetailBloc, required this.state});

  @override
  Widget build(BuildContext context) {
    final receiptList = switch (state.shownReceiptType) {
      ReceiptType.offer => state.listOfCustomerOffers,
      ReceiptType.appointment => state.listOfCustomerAppointments,
      ReceiptType.deliveryNote => state.listOfCustomerDeliveryNotes,
      ReceiptType.invoice || ReceiptType.credit => state.listOfCustomerInvoices,
    };

    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Wrap(
            spacing: 10,
            runSpacing: 6,
            children: [
              FilterChip(
                label: const Text('Angebote'),
                labelStyle: const TextStyle(color: Colors.black),
                selected: state.shownReceiptType == ReceiptType.offer,
                selectedColor: CustomColors.chipSelectedColor,
                backgroundColor: CustomColors.chipBackgroundColor,
                onSelected: (_) => state.shownReceiptType != ReceiptType.offer
                    ? customerDetailBloc.add(CustomerDetailShownReceiptTypeChangedEvent(type: ReceiptType.offer))
                    : null,
              ),
              FilterChip(
                label: const Text('Aufträge'),
                labelStyle: const TextStyle(color: Colors.black),
                selected: state.shownReceiptType == ReceiptType.appointment,
                selectedColor: CustomColors.chipSelectedColor,
                backgroundColor: CustomColors.chipBackgroundColor,
                onSelected: (_) => state.shownReceiptType != ReceiptType.appointment
                    ? customerDetailBloc.add(CustomerDetailShownReceiptTypeChangedEvent(type: ReceiptType.appointment))
                    : null,
              ),
              FilterChip(
                label: const Text('Lieferscheine'),
                labelStyle: const TextStyle(color: Colors.black),
                selected: state.shownReceiptType == ReceiptType.deliveryNote,
                selectedColor: CustomColors.chipSelectedColor,
                backgroundColor: CustomColors.chipBackgroundColor,
                onSelected: (_) => state.shownReceiptType != ReceiptType.deliveryNote
                    ? customerDetailBloc.add(CustomerDetailShownReceiptTypeChangedEvent(type: ReceiptType.deliveryNote))
                    : null,
              ),
              FilterChip(
                label: const Text('Rechnungen'),
                labelStyle: const TextStyle(color: Colors.black),
                selected: state.shownReceiptType == ReceiptType.invoice || state.shownReceiptType == ReceiptType.credit,
                selectedColor: CustomColors.chipSelectedColor,
                backgroundColor: CustomColors.chipBackgroundColor,
                onSelected: (_) => state.shownReceiptType != ReceiptType.invoice && state.shownReceiptType != ReceiptType.credit
                    ? customerDetailBloc.add(CustomerDetailShownReceiptTypeChangedEvent(type: ReceiptType.invoice))
                    : null,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: receiptList.length,
            separatorBuilder: (context, index) => const Divider(height: 0, indent: 18, endIndent: 18),
            itemBuilder: (context, index) {
              final receipt = receiptList[index];

              return ListTile(
                title: Text(_getTitle(receipt)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat('dd.MM.yyy', 'de').format(receipt.creationDate)),
                    Text(
                      '${receipt.totalGross.toMyCurrencyStringToShow()} €',
                      style: TextStyles.defaultBold.copyWith(color: _getPaymentStatusColor(receipt)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getTitle(Receipt receipt) {
    return switch (receipt.receiptTyp) {
      ReceiptType.offer => receipt.offerNumberAsString,
      ReceiptType.appointment => receipt.appointmentNumberAsString,
      ReceiptType.deliveryNote => receipt.deliveryNoteNumberAsString,
      ReceiptType.invoice => receipt.invoiceNumberAsString,
      ReceiptType.credit => receipt.creditNumberAsString,
    };
  }

  Color _getPaymentStatusColor(Receipt receipt) {
    return switch (receipt.paymentStatus) {
      PaymentStatus.open => Colors.grey,
      PaymentStatus.partiallyPaid => Colors.orange,
      PaymentStatus.paid => Colors.green,
    };
  }
}
