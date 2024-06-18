import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:cezeri_commerce/1_presentation/core/functions/dialogs.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/3_domain/entities/receipt/receipt.dart';
import '/3_domain/entities/receipt/receipt_product.dart';
import '/3_domain/pdf/pdf_api_mobile.dart';
import '/3_domain/pdf/pdf_api_web.dart';
import '/3_domain/pdf/pdf_receipt_generator.dart';
import '/constants.dart';
import '/routes/router.gr.dart';
import '../../../2_application/database/receipt/receipt_bloc.dart';
import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../core/functions/mixed_functions.dart';
import '../../core/functions/show_my_product_quick_view.dart';
import '../../core/widgets/address_column.dart';
import '../../core/widgets/marketplace_column.dart';
import '../../core/widgets/my_animated_arrow_icon_button.dart';
import '../../core/widgets/my_animated_expansion_container.dart';
import '../widgets/receipts_overview_carrier_bar.dart';

class ReceiptsOverviewPage extends StatefulWidget {
  final ReceiptBloc receiptBloc;
  final ReceiptType receiptTyp;

  const ReceiptsOverviewPage({super.key, required this.receiptBloc, required this.receiptTyp});

  @override
  State<ReceiptsOverviewPage> createState() => _ReceiptsOverviewPageState();
}

class _ReceiptsOverviewPageState extends State<ReceiptsOverviewPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<ReceiptBloc, ReceiptState>(
      bloc: widget.receiptBloc,
      builder: (context, state) {
        if (state.isLoadingReceiptsOnObserve) {
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }
        if (state.firebaseFailure != null && state.isAnyFailure) {
          return const Expanded(child: Center(child: Text('Ein Fehler beim Laden der Artikel ist aufgetreten!')));
        }

        if (state.listOfAllReceipts == null || state.listOfFilteredReceipts == null) {
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }

        if (state.listOfAllReceipts!.isEmpty || state.listOfFilteredReceipts!.isEmpty) {
          return const Expanded(child: Center(child: Text('Keine Dokumente vorhanden')));
        }

        return Expanded(
          child: Scrollbar(
            child: ListView.separated(
              itemCount: state.listOfFilteredReceipts!.length,
              separatorBuilder: (context, index) => const Divider(indent: 45, endIndent: 20),
              itemBuilder: (context, index) {
                final curAppointment = state.listOfFilteredReceipts![index];

                if (ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET)) {
                  return _AppointmentContainer(
                    receipt: curAppointment,
                    index: index,
                    receiptBloc: widget.receiptBloc,
                    listOfMarketplaces: state.listOfMarketpaces!,
                    receiptTyp: widget.receiptTyp,
                  );
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: (screenWidth + 1040) - 390,
                    child: _AppointmentContainer(
                      receipt: curAppointment,
                      index: index,
                      receiptBloc: widget.receiptBloc,
                      listOfMarketplaces: state.listOfMarketpaces!,
                      receiptTyp: widget.receiptTyp,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _AppointmentContainer extends StatelessWidget {
  final Receipt receipt;
  final int index;
  final ReceiptBloc receiptBloc;
  final List<AbstractMarketplace> listOfMarketplaces;
  final ReceiptType receiptTyp;

  const _AppointmentContainer({
    required this.receipt,
    required this.index,
    required this.receiptBloc,
    required this.listOfMarketplaces,
    required this.receiptTyp,
  });

  @override
  Widget build(BuildContext context) {
    final marketplace = listOfMarketplaces.where((e) => e.id == receipt.marketplaceId).first;

    final deliveryAddress = receipt.addressDelivery;
    final invoiceAddress = receipt.addressInvoice;
    return BlocBuilder<ReceiptBloc, ReceiptState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox.adaptive(
                      value: state.selectedReceipts.any((e) => e.id == receipt.id),
                      onChanged: (_) => receiptBloc.add(OnAppointmentSelectedEvent(appointment: receipt)),
                    ),
                    _IconColumn(
                      receiptBloc: receiptBloc,
                      receipt: receipt,
                      marketplace: marketplace,
                      isExpanded: state.isExpanded,
                      index: index,
                    ),
                    _ReceiptInfoColumn(
                      receiptBloc: receiptBloc,
                      receipt: receipt,
                      receiptTyp: receiptTyp,
                      listOfMarketplaces: listOfMarketplaces,
                    ),
                  ],
                ),
                AddressColumn(address: deliveryAddress, width: 200),
                MarketplaceColumn(marketplace: marketplace, receipt: receipt, width: 140),
                AddressColumn(
                  address: invoiceAddress,
                  companyName: receipt.receiptCustomer.company,
                  name: receipt.receiptCustomer.name,
                  width: 200,
                ),
                ReceiptsOverviewCarrierBar(receipt: receipt),
                _PaymentColumn(receipt: receipt),
                const SizedBox(),
              ],
            ),
            MyAnimatedExpansionContainer(
              isExpanded: state.isExpanded[index],
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Expanded(flex: RWROP.pos, child: Text('Pos', style: TextStyles.defaultBold)),
                            Spacer(),
                            Expanded(flex: RWROP.articleNumber, child: Text('Artikelnummer', style: TextStyles.defaultBold)),
                            Spacer(),
                            Expanded(flex: RWROP.ean, child: Text('EAN', style: TextStyles.defaultBold)),
                            Spacer(),
                            Expanded(flex: RWROP.articleName, child: Text('Name', style: TextStyles.defaultBold)),
                            Spacer(),
                            Expanded(flex: RWROP.openQuantity, child: Text('Offen', style: TextStyles.defaultBold)),
                            Spacer(),
                            Expanded(flex: RWROP.quantity, child: Text('Anzahl', style: TextStyles.defaultBold)),
                          ],
                        ),
                        const Divider(),
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: receipt.listOfReceiptProduct.length,
                          itemBuilder: (context, index) {
                            return _AppointmentProdcutsContainer(appointmentProduct: receipt.listOfReceiptProduct[index], index: index);
                          },
                          separatorBuilder: (context, index) => const Divider(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

Future<void> _onPdfPressed({required BuildContext context, required Receipt receipt, required AbstractMarketplace marketplace}) async {
  showMyDialogLoading(context: context, text: 'PDF wird erstellt...', canPop: true);

  final receiptName = switch (receipt.receiptTyp) {
    ReceiptType.offer => receipt.offerNumberAsString,
    ReceiptType.appointment => receipt.appointmentNumberAsString,
    ReceiptType.deliveryNote => receipt.deliveryNoteNumberAsString,
    ReceiptType.invoice || ReceiptType.credit => receipt.invoiceNumberAsString,
  };
  final generatedPdf = await PdfReceiptGenerator.generate(
    receipt: receipt,
    logoUrl: marketplace.logoUrl,
  );

  if (context.mounted) Navigator.of(context).pop();

  if (!context.mounted) return;
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.open_in_browser),
                title: const Text(kIsWeb ? 'Im Browser öffnen' : 'Öffnen'),
                onTap: () async {
                  if (context.mounted) context.router.maybePop();
                  if (kIsWeb) {
                    await PdfApiWeb.saveDocument(name: '$receiptName.pdf', byteList: generatedPdf, showInBrowser: true);
                  } else {
                    await PdfApiMobile.saveDocument(name: '$receiptName.pdf', byteList: generatedPdf);
                  }
                },
              ),
              if (kIsWeb)
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Herunterladen'),
                  onTap: () async {
                    if (context.mounted) context.router.maybePop();
                    await PdfApiWeb.saveDocument(name: '$receiptName.pdf', byteList: generatedPdf, showInBrowser: false);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.print),
                title: const Text('Drucken'),
                onTap: () async {
                  if (context.mounted) context.router.maybePop();
                  await Printing.layoutPdf(onLayout: (_) => generatedPdf);
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _AppointmentProdcutsContainer extends StatelessWidget {
  final ReceiptProduct appointmentProduct;
  final int index;

  const _AppointmentProdcutsContainer({required this.appointmentProduct, required this.index});

  @override
  Widget build(BuildContext context) {
    final bool isCompletelyShipped = appointmentProduct.quantity - appointmentProduct.shippedQuantity == 0;

    return InkWell(
      onLongPress: () => showMyProductQuickViewById(context: context, productId: appointmentProduct.productId, showStatProduct: true),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(flex: RWROP.pos, child: Text((index + 1).toString(), style: TextStyles.defaultBold)),
          const Spacer(),
          Expanded(flex: RWROP.articleNumber, child: Text(appointmentProduct.articleNumber, overflow: TextOverflow.ellipsis)),
          const Spacer(),
          Expanded(flex: RWROP.ean, child: Text(appointmentProduct.ean, overflow: TextOverflow.ellipsis)),
          const Spacer(),
          Expanded(flex: RWROP.articleName, child: Text(appointmentProduct.name, overflow: TextOverflow.ellipsis)),
          const Spacer(),
          Expanded(
            flex: RWROP.openQuantity,
            child: Center(
              child: Text(
                (appointmentProduct.quantity - appointmentProduct.shippedQuantity).toString(),
                style: isCompletelyShipped ? TextStyles.defaultBold.copyWith(color: Colors.green) : const TextStyle(color: Colors.red),
              ),
            ),
          ),
          const Spacer(),
          Expanded(flex: RWROP.quantity, child: Center(child: Text(appointmentProduct.quantity.toString()))),
        ],
      ),
    );
  }
}

class _IconColumn extends StatelessWidget {
  final ReceiptBloc receiptBloc;
  final Receipt receipt;
  final AbstractMarketplace marketplace;
  final List<bool> isExpanded;
  final int index;

  const _IconColumn({required this.receiptBloc, required this.receipt, required this.marketplace, required this.isExpanded, required this.index});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          receipt.listOfReceiptProduct.length > 1
              ? Container(
                  height: 20,
                  width: 20,
                  decoration: const BoxDecoration(
                    color: CustomColors.backgroundLightGreen,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Center(child: Text(receipt.listOfReceiptProduct.length.toString())),
                )
              : const SizedBox(),
          MyAnimatedIconButtonArrow(
            boolValue: isExpanded[index],
            onPressed: () => receiptBloc.add(SetAppointmentIsExpandedEvent(index: index)),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 30),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () async => await _onPdfPressed(context: context, receipt: receipt, marketplace: marketplace),
              icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentColumn extends StatelessWidget {
  final Receipt receipt;

  const _PaymentColumn({required this.receipt});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        children: [
          Tooltip(
            message: 'Bezahlter Betrag: ${receipt.totalPaidGross} €',
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                color: switch (receipt.paymentStatus) {
                  PaymentStatus.open => CustomColors.backgroundLightGrey,
                  PaymentStatus.partiallyPaid => CustomColors.backgroundLightOrange,
                  PaymentStatus.paid => CustomColors.backgroundLightGreen,
                },
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Center(
                  child: switch (receipt.paymentStatus) {
                    PaymentStatus.open => const Text('Offen'),
                    PaymentStatus.partiallyPaid => const Text('Teilweise bezahlt'),
                    PaymentStatus.paid => const Text('Komplett bezahlt'),
                  },
                ),
              ),
            ),
          ),
          Gaps.h2,
          _loadImage(receipt.paymentMethod.logoPath),
          Gaps.h2,
          Text('${receipt.profit.toMyCurrencyStringToShow()} ${receipt.currency}'),
          Text('${calcDiscountPercentage(receipt.totalNet, receipt.profit).toMyCurrencyStringToShow()} %'),
        ],
      ),
    );
  }
}

Widget _loadImage(String path) {
  return Image.asset(
    path,
    height: 25,
    width: 65,
    fit: BoxFit.scaleDown,
    errorBuilder: (context, exception, stackTrace) {
      return const SizedBox(
        height: 25,
        width: 65,
        child: Center(child: Icon(Icons.question_mark)),
      );
    },
  );
}

class _ReceiptInfoColumn extends StatelessWidget {
  final ReceiptBloc receiptBloc;
  final Receipt receipt;
  final ReceiptType receiptTyp;
  final List<AbstractMarketplace> listOfMarketplaces;

  const _ReceiptInfoColumn({required this.receiptBloc, required this.receipt, required this.receiptTyp, required this.listOfMarketplaces});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              receiptBloc.add(GetReceiptEvent(appointment: receipt));
              context.router.push(ReceiptDetailRoute(receiptId: receipt.id, receiptTyp: receiptTyp));
            },
            child: Text(
              switch (receipt.receiptTyp) {
                ReceiptType.offer => receipt.offerNumberAsString,
                ReceiptType.appointment => receipt.appointmentNumberAsString,
                ReceiptType.deliveryNote => receipt.deliveryNoteNumberAsString,
                ReceiptType.invoice => receipt.invoiceNumberAsString,
                ReceiptType.credit => receipt.invoiceNumberAsString,
              },
              style: receipt.isDeliveryBlocked ? const TextStyle().copyWith(color: Colors.red) : null,
            ),
          ),
          Text(DateFormat('dd.MM.yyy', 'de').format(receipt.creationDate)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.watch_later_outlined, size: 16),
              const Text(' '),
              Text(DateFormat('Hm', 'de').format(receipt.creationDate)),
            ],
          ),
          Text('${receipt.totalGross.toMyCurrencyStringToShow()} €', style: TextStyles.defaultBold)
        ],
      ),
    );
  }
}
