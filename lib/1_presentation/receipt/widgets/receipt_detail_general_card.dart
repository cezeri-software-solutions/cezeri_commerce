import 'package:cezeri_commerce/1_presentation/core/widgets/my_dropdown_button_small.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../2_application/firebase/appointment/appointment_bloc.dart';
import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../constants.dart';

class ReceiptDetailGeneralCard extends StatefulWidget {
  final Receipt receipt;
  final AppointmentBloc appointmentBloc;
  final List<Marketplace> listOfMarketplaces;

  const ReceiptDetailGeneralCard({super.key, required this.receipt, required this.appointmentBloc, required this.listOfMarketplaces});

  @override
  State<ReceiptDetailGeneralCard> createState() => _ReceiptDetailGeneralCardState();
}

class _ReceiptDetailGeneralCardState extends State<ReceiptDetailGeneralCard> {
  @override
  Widget build(BuildContext context) {
    final marketplaceNames = widget.listOfMarketplaces.map((e) => e.name).toList();
    marketplaceNames.add(Marketplace.empty().name);
    final receiptHeader = switch (widget.receipt.receiptTyp) {
      ReceiptTyp.offer => 'Angebot: ${widget.receipt.offerNumberAsString}',
      ReceiptTyp.appointment => 'Auftrag: ${widget.receipt.appointmentNumberAsString}',
      ReceiptTyp.invoice => 'Rechnung: ${widget.receipt.invoiceNumberAsString}',
      ReceiptTyp.credit => 'Gutschrift: ${widget.receipt.creditNumberAsString}',
    };

    final selectedMarketplace = widget.listOfMarketplaces.where((e) => e.id == widget.receipt.marketplaceId).firstOrNull;
    String selectedMarketplaceName = switch (selectedMarketplace) {
      null => Marketplace.empty().name,
      _ => selectedMarketplace.name,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(alignment: Alignment.center, child: Text(receiptHeader, style: TextStyles.h3BoldPrimary)),
            const Divider(height: 30),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Belegdatum', style: TextStyles.infoOnTextField),
                      Text(DateFormat('dd.MM.yyy', 'de').format(widget.receipt.creationDate)),
                      Text(DateFormat('Hm', 'de').format(widget.receipt.creationDate)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Belegdatum Marktplatz', style: TextStyles.infoOnTextField),
                      Text(DateFormat('dd.MM.yyy', 'de').format(widget.receipt.creationDateMarektplace)),
                      Text(DateFormat('Hm', 'de').format(widget.receipt.creationDateMarektplace)),
                    ],
                  ),
                ),
              ],
            ),
            Gaps.h16,
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('E-Mail', style: TextStyles.infoOnTextField),
                      Text(widget.receipt.receiptCustomer.email),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Bestellnummer Marktplatz', style: TextStyles.infoOnTextField),
                      Text.rich(TextSpan(children: [
                        const TextSpan(text: 'Id: ', style: TextStyles.infoOnTextField),
                        TextSpan(text: widget.receipt.receiptMarketplaceId.toString()),
                        const TextSpan(text: ' / '),
                        const TextSpan(text: 'Ref.: ', style: TextStyles.infoOnTextField),
                        TextSpan(text: widget.receipt.receiptMarketplaceReference),
                      ])),
                    ],
                  ),
                ),
              ],
            ),
            Gaps.h16,
            MyDropdownButtonSmall(
              labelText: 'Marktplatz',
              value: selectedMarketplaceName,
              onChanged: (marketplaceName) {
                //selectedMarketplaceName = marketplaceName!;
                widget.appointmentBloc.add(
                  OnAppointmentMarketplaceChangedEvent(marketplaceId: widget.listOfMarketplaces.where((e) => e.name == marketplaceName).first.id),
                );
              },
              items: marketplaceNames,
            )
          ],
        ),
      ),
    );
  }
}
