import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../2_application/database/receipt_detail/receipt_detail_bloc.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../constants.dart';
import '../../../routes/router.gr.dart';
import '../../core/core.dart';
import '../sheets/generate_pdf_from_receipt.dart';

class ReceiptDetailSameReceiptsCard extends StatelessWidget {
  final ReceiptDetailBloc receiptDetailBloc;
  final ReceiptDetailState state;

  const ReceiptDetailSameReceiptsCard({super.key, required this.receiptDetailBloc, required this.state});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(alignment: Alignment.center, child: Text('Dazugehörige Belege', style: TextStyles.h3BoldPrimary)),
            const Divider(height: 30),
            _ReceiptsList(receiptDetailBloc: receiptDetailBloc, state: state),
          ],
        ),
      ),
    );
  }
}

class _ReceiptsList extends StatelessWidget {
  final ReceiptDetailBloc receiptDetailBloc;
  final ReceiptDetailState state;

  const _ReceiptsList({required this.receiptDetailBloc, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingSameReceiptsOnObserve) return const SizedBox(height: 100, child: Center(child: MyCircularProgressIndicator()));
    if (state.sameReceiptsFailure != null) return Center(child: Text(state.sameReceiptsFailure.toString()));
    if (state.listOfSameReceipts == null) return const SizedBox(height: 100, child: Center(child: MyCircularProgressIndicator()));

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.listOfSameReceipts!.length,
      separatorBuilder: (context, index) => const Divider(height: 0),
      itemBuilder: (context, index) {
        final receipt = state.listOfSameReceipts![index];
        final marketplace = state.listOfMarketplaces!.where((e) => e.id == receipt.marketplaceId).firstOrNull;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () =>
                      context.router.push(ReceiptDetailRoute(receiptId: receipt.id, newEmptyReceipt: null, receiptTyp: receipt.receiptTyp)),
                  child: Text(_getReceptTitle(receipt)),
                ),
                if (state.receipt!.id == receipt.id) const Text('(Aktueller Beleg)', style: TextStyles.infoOnTextFieldSmall)
              ],
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: marketplace == null
                  ? null
                  : () async => await onGeneratePdfFromReceipt(context: context, receipt: receipt, marketplace: marketplace),
              icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
            ),
          ],
        );
      },
    );
  }

  String _getReceptTitle(Receipt receipt) => switch (receipt.receiptTyp) {
        ReceiptType.offer => receipt.offerNumberAsString,
        ReceiptType.appointment => receipt.appointmentNumberAsString,
        ReceiptType.deliveryNote => receipt.deliveryNoteNumberAsString,
        ReceiptType.invoice => receipt.invoiceNumberAsString,
        ReceiptType.credit => receipt.creditNumberAsString,
      };
}
