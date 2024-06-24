import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../../2_application/database/customer_detail/customer_detail_bloc.dart';
import '../../../../../3_domain/entities/receipt/receipt.dart';
import '../../../../../constants.dart';
import '../../../../../routes/router.gr.dart';
import '../../../../core/core.dart';

class CustomerReceiptList extends StatelessWidget {
  final CustomerDetailBloc customerDetailBloc;
  final CustomerDetailState state;

  const CustomerReceiptList({super.key, required this.customerDetailBloc, required this.state});

  @override
  Widget build(BuildContext context) {
    final isTabletOrLarger = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isTabletOrLarger) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Dokumente', style: TextStyles.h2Bold),
              SizedBox(height: 50, child: _ReceiptFilterChips(customerDetailBloc: customerDetailBloc, state: state)),
            ],
          )
        ] else ...[
          const Text('Dokumente', style: TextStyles.h2Bold),
          Gaps.h16,
          SizedBox(height: 100, child: _ReceiptFilterChips(customerDetailBloc: customerDetailBloc, state: state)),
          Gaps.h16,
        ],
        _ReceiptsList(state: state),
      ],
    );
  }
}

class _ReceiptFilterChips extends StatelessWidget {
  final CustomerDetailBloc customerDetailBloc;
  final CustomerDetailState state;

  const _ReceiptFilterChips({required this.customerDetailBloc, required this.state});

  @override
  Widget build(BuildContext context) {
    return Wrap(
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
    );
  }
}

class _ReceiptsList extends StatelessWidget {
  final CustomerDetailState state;

  const _ReceiptsList({required this.state});

  @override
  Widget build(BuildContext context) {
    final isTabletOrLarger = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);

    if (state.isLoadingCustomerDetailOnObserveReceipts) return const SizedBox(height: 200, child: Center(child: MyCircularProgressIndicator()));
    if (state.receiptsFailure != null) return SizedBox(height: 200, child: Center(child: Text(state.receiptsFailure.toString())));

    final receiptList = switch (state.shownReceiptType) {
      ReceiptType.offer => state.listOfCustomerOffers,
      ReceiptType.appointment => state.listOfCustomerAppointments,
      ReceiptType.deliveryNote => state.listOfCustomerDeliveryNotes,
      ReceiptType.invoice || ReceiptType.credit => state.listOfCustomerInvoices,
    };

    if (isTabletOrLarger) {
      return Expanded(
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: receiptList.length,
          separatorBuilder: (context, index) => const Divider(height: 0, indent: 18, endIndent: 18),
          itemBuilder: (context, index) => _ReceiptItem(receipt: receiptList[index]),
        ),
      );
    } else {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: receiptList.length,
        separatorBuilder: (context, index) => const Divider(height: 0, indent: 18, endIndent: 18),
        itemBuilder: (context, index) => _ReceiptItem(receipt: receiptList[index]),
      );
    }
  }
}

class _ReceiptItem extends StatelessWidget {
  final Receipt receipt;

  const _ReceiptItem({required this.receipt});

  @override
  Widget build(BuildContext context) {
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
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: () => context.router.push(ReceiptDetailRoute(receiptId: receipt.id, newEmptyReceipt: null, receiptTyp: receipt.receiptTyp)),
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
