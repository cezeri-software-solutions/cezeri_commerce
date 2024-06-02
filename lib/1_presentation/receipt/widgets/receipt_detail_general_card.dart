import 'package:cezeri_commerce/1_presentation/core/widgets/my_dropdown_button_small.dart';
import 'package:cezeri_commerce/1_presentation/core/widgets/my_form_field_small.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../2_application/database/receipt/receipt_bloc.dart';
import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../constants.dart';

class ReceiptDetailGeneralCard extends StatefulWidget {
  final Receipt receipt;
  final ReceiptBloc receiptBloc;
  final List<AbstractMarketplace> listOfMarketplaces;

  const ReceiptDetailGeneralCard({super.key, required this.receipt, required this.receiptBloc, required this.listOfMarketplaces});

  @override
  State<ReceiptDetailGeneralCard> createState() => _ReceiptDetailGeneralCardState();
}

class _ReceiptDetailGeneralCardState extends State<ReceiptDetailGeneralCard> {
  late TextEditingController customerEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    customerEmailController = TextEditingController(text: widget.receipt.receiptCustomer.email);
  }

  @override
  Widget build(BuildContext context) {
    if (customerEmailController.text != widget.receipt.receiptCustomer.email) {
      customerEmailController = TextEditingController(text: widget.receipt.receiptCustomer.email);
    }

    final marketplaceNames = widget.listOfMarketplaces.map((e) => e.name).toList();
    marketplaceNames.add(MarketplacePresta.empty().name);

    final receiptHeader = switch (widget.receipt.receiptTyp) {
      ReceiptTyp.offer => 'Angebot: ${widget.receipt.offerNumberAsString}',
      ReceiptTyp.appointment => 'Auftrag: ${widget.receipt.appointmentNumberAsString}',
      ReceiptTyp.deliveryNote => 'Lieferschein: ${widget.receipt.deliveryNoteNumberAsString}',
      ReceiptTyp.invoice => 'Rechnung: ${widget.receipt.invoiceNumberAsString}',
      ReceiptTyp.credit => 'Gutschrift: ${widget.receipt.creditNumberAsString}',
    };

    final selectedMarketplace = widget.listOfMarketplaces.where((e) => e.id == widget.receipt.marketplaceId).firstOrNull;
    String selectedMarketplaceName = switch (selectedMarketplace) {
      null => MarketplacePresta.empty().name,
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
                      // InkWell(
                      //   onLongPress: () => Clipboard.setData(ClipboardData(text: widget.receipt.receiptCustomer.email)),
                      //   child: Text(widget.receipt.receiptCustomer.email),
                      // ),
                      Row(
                        children: [
                          Expanded(
                            child: MyTextFormFieldSmall(
                              controller: customerEmailController,
                              // initialValue: widget.receipt.receiptCustomer.email,
                              onChanged: (mail) => widget.receiptBloc.add(OnReceiptCustomerEmailChangedEvent(email: customerEmailController.text)),
                            ),
                          ),
                          Gaps.w8,
                          InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: widget.receipt.receiptCustomer.email));
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Row(
                                children: [
                                  Icon(Icons.check_circle_rounded, color: Colors.green),
                                  Gaps.w8,
                                  Expanded(child: Text('E-Mail wurde kopiert')),
                                ],
                              )));
                            },
                            child: const Icon(Icons.copy, color: CustomColors.primaryColor),
                          ),
                          Gaps.w8,
                        ],
                      ),
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
                widget.receiptBloc.add(
                  OnAppointmentMarketplaceChangedEvent(marketplace: widget.listOfMarketplaces.where((e) => e.name == marketplaceName).first),
                );
              },
              items: marketplaceNames,
            ),
            Gaps.h8,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Liefersperre:'),
                Checkbox.adaptive(
                  value: widget.receipt.isDeliveryBlocked,
                  onChanged: (value) => widget.receiptBloc.add(SetIsDeliveryBlockedEvent(value: value!)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
