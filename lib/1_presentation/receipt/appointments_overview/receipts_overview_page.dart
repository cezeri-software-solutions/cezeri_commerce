import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:cezeri_commerce/1_presentation/core/widgets/my_circular_progress_indicator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:printing/printing.dart';

import '../../../2_application/firebase/appointment/appointment_bloc.dart';
import '../../../2_application/firebase/marketplace/marketplace_bloc.dart';
import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/entities/receipt/receipt_product.dart';
import '../../../3_domain/enums/enums.dart';
import '../../../3_domain/pdf/pdf_api_mobile.dart';
import '../../../3_domain/pdf/pdf_api_web.dart';
import '../../../3_domain/pdf/pdf_receipt_generator.dart';
import '../../../constants.dart';
import '../../../core/firebase_failures.dart';
import '../../../routes/router.gr.dart';
import '../../core/functions/mixed_functions.dart';
import '../../core/widgets/my_avatar.dart';
import '../../core/widgets/my_country_flag.dart';
import '../appointment_detail/appointment_detail_screen.dart';
import '../widgets/receipts_overview_carrier_bar.dart';

class ReceiptsOverviewPage extends StatefulWidget {
  final AppointmentBloc appointmentBloc;
  final MarketplaceBloc marketplaceBloc;
  final ReceiptTyp receiptTyp;

  const ReceiptsOverviewPage({super.key, required this.appointmentBloc, required this.marketplaceBloc, required this.receiptTyp});

  @override
  State<ReceiptsOverviewPage> createState() => _ReceiptsOverviewPageState();
}

class _ReceiptsOverviewPageState extends State<ReceiptsOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        return BlocBuilder<MarketplaceBloc, MarketplaceState>(
          builder: (context, stateMarketplace) {
            if (state.isLoadingReceiptsOnObserve || stateMarketplace.isLoadingMarketplacesOnObserve) {
              return const Expanded(child: Center(child: CircularProgressIndicator()));
            }
            if (state.firebaseFailure != null && state.isAnyFailure) {
              return switch (state.firebaseFailure.runtimeType) {
                EmptyFailure => const Expanded(child: Center(child: Text('Du hast noch keine Dokumente angelegt oder importiert!'))),
                (_) => const Expanded(child: Center(child: Text('Ein Fehler beim Laden der Artikel ist aufgetreten!'))),
              };
            }

            if (stateMarketplace.firebaseFailure != null && stateMarketplace.isAnyFailure) {
              return switch (stateMarketplace.firebaseFailure.runtimeType) {
                EmptyFailure => const Expanded(child: Center(child: Text('Du hast noch keine Marktplätze angelegt!'))),
                (_) => const Expanded(child: Center(child: Text('Ein Fehler beim Laden der Marktplätze ist aufgetreten!'))),
              };
            }

            if (state.listOfAllReceipts == null || state.listOfFilteredReceipts == null || stateMarketplace.listOfMarketplace == null) {
              return const Expanded(child: Center(child: CircularProgressIndicator()));
            }

            return Expanded(
              child: ListView.separated(
                itemCount: state.listOfFilteredReceipts!.length,
                itemBuilder: (context, index) {
                  final curAppointment = state.listOfFilteredReceipts![index];
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox.adaptive(
                          value: state.isAllReceiptsSeledcted,
                          onChanged: (value) => widget.appointmentBloc.add(OnSelectAllAppointmentsEvent(isSelected: value!)),
                        ),
                        const Divider(),
                        _AppointmentContainer(
                          receipt: curAppointment,
                          index: index,
                          appointmentBloc: widget.appointmentBloc,
                          listOfMarketplaces: stateMarketplace.listOfMarketplace!,
                          receiptTyp: widget.receiptTyp,
                        ),
                      ],
                    );
                  }
                  return _AppointmentContainer(
                    receipt: curAppointment,
                    index: index,
                    appointmentBloc: widget.appointmentBloc,
                    listOfMarketplaces: stateMarketplace.listOfMarketplace!,
                    receiptTyp: widget.receiptTyp,
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
            );
          },
        );
      },
    );
  }
}

class _AppointmentContainer extends StatefulWidget {
  final Receipt receipt;
  final int index;
  final AppointmentBloc appointmentBloc;
  final List<Marketplace> listOfMarketplaces;
  final ReceiptTyp receiptTyp;

  const _AppointmentContainer({
    required this.receipt,
    required this.index,
    required this.appointmentBloc,
    required this.listOfMarketplaces,
    required this.receiptTyp,
  });

  @override
  State<_AppointmentContainer> createState() => __AppointmentContainerState();
}

class __AppointmentContainerState extends State<_AppointmentContainer> {
  bool _isLoadingPdf = false;

  @override
  Widget build(BuildContext context) {
    final logger = Logger();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final responsiveness = screenWidth > 700 ? Responsiveness.isTablet : Responsiveness.isMobil;
    final marketplace = widget.listOfMarketplaces.where((e) => e.id == widget.receipt.marketplaceId).first;
    //TODO: Löschen wenn alles passt
    // Address? deliveryAddress =
    //     widget.receipt.receiptCustomer.listOfAddress.where((e) => e.addressType == AddressType.delivery && e.isDefault).firstOrNull;
    // deliveryAddress ??=
    //     widget.receipt.receiptCustomer.listOfAddress.isNotEmpty ? widget.receipt.receiptCustomer.listOfAddress.first : Address.empty();
    // Address? invoiceAddress =
    //     widget.receipt.receiptCustomer.listOfAddress.where((e) => e.addressType == AddressType.invoice && e.isDefault).firstOrNull;
    // invoiceAddress ??= widget.receipt.receiptCustomer.listOfAddress.isNotEmpty ? widget.receipt.receiptCustomer.listOfAddress.first : Address.empty();
    final deliveryAddress = widget.receipt.addressDelivery;
    final invoiceAddress = widget.receipt.addressInvoice;
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox.adaptive(
                        value: state.selectedReceipts.any((e) => e.id == widget.receipt.id),
                        onChanged: (_) => widget.appointmentBloc.add(OnAppointmentSelectedEvent(appointment: widget.receipt)),
                      ),
                      SizedBox(
                        width: 60,
                        child: Column(
                          children: [
                            widget.receipt.listOfReceiptProduct.length > 1
                                ? Container(
                                    height: 20,
                                    width: 20,
                                    decoration: const BoxDecoration(
                                      color: CustomColors.backgroundLightGreen,
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Center(child: Text(widget.receipt.listOfReceiptProduct.length.toString())),
                                  )
                                : const SizedBox(),
                            //Gaps.h10,
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => widget.appointmentBloc.add(SetAppointmentIsExpandedEvent(index: widget.index)),
                              icon: switch (state.isExpanded[widget.index]) {
                                true => const Icon(Icons.arrow_drop_down_circle, size: 30, color: CustomColors.primaryColor),
                                false => Transform.rotate(
                                    angle: -pi / 2,
                                    child: const Icon(Icons.arrow_drop_down_circle, size: 30, color: Colors.grey, grade: 25),
                                  ),
                              },
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 30),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () async => await _onPdfPressed(marketplace: marketplace),
                                icon: _isLoadingPdf ? const MyCircularProgressIndicator() : const Icon(Icons.picture_as_pdf, color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                context.read<AppointmentBloc>().add(GetAppointmentEvent(appointment: widget.receipt));
                                context.router.push(
                                  AppointmentDetailRoute(
                                    appointmentBloc: widget.appointmentBloc,
                                    listOfMarketplaces: widget.listOfMarketplaces,
                                    receiptCreateOrEdit: ReceiptCreateOrEdit.edit,
                                    receiptTyp: widget.receiptTyp,
                                  ),
                                );
                              },
                              child: Text(switch (widget.receipt.receiptTyp) {
                                ReceiptTyp.offer => widget.receipt.offerNumberAsString,
                                ReceiptTyp.appointment => widget.receipt.appointmentNumberAsString,
                                ReceiptTyp.deliveryNote => widget.receipt.deliveryNoteNumberAsString,
                                ReceiptTyp.invoice => widget.receipt.invoiceNumberAsString,
                                ReceiptTyp.credit => widget.receipt.invoiceNumberAsString,
                              }),
                              // Text(switch (widget.receipt.receiptTyp) {
                              //   ReceiptTyp.offer => 'Angebot ${widget.receipt.offerNumberAsString}',
                              //   ReceiptTyp.appointment => 'Auftrag ${widget.receipt.appointmentNumberAsString}',
                              //   ReceiptTyp.deliveryNote => 'Lieferschein ${widget.receipt.deliveryNoteNumberAsString}',
                              //   ReceiptTyp.invoice => 'Rechnung ${widget.receipt.invoiceNumberAsString}',
                              //   ReceiptTyp.credit => 'Gutschrift ${widget.receipt.invoiceNumberAsString}',
                              // }),
                            ),
                            Text(DateFormat('dd.MM.yyy', 'de').format(widget.receipt.creationDate)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.watch_later_outlined, size: 16),
                                const Text(' '),
                                Text(DateFormat('Hm', 'de').format(widget.receipt.creationDate)),
                              ],
                            ),
                            Text('${widget.receipt.totalGross.toMyCurrencyStringToShow()} €', style: TextStyles.defaultBold)
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (deliveryAddress.companyName != '') Text(deliveryAddress.companyName),
                        Text(deliveryAddress.name),
                        Text(deliveryAddress.street),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: deliveryAddress.postcode),
                              const TextSpan(text: ' '),
                              TextSpan(text: deliveryAddress.city),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(deliveryAddress.country.name),
                            Gaps.w8,
                            MyCountryFlag(country: deliveryAddress.country, size: 12),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: Column(
                      children: [
                        MyAvatar(
                          name: marketplace.shortName,
                          radius: 12,
                          fontSize: 12,
                          imageUrl: marketplace.logoUrl,
                          shape: BoxShape.rectangle,
                          fit: BoxFit.scaleDown,
                        ),
                        Text(marketplace.name),
                        Text(DateFormat('dd.MM.yyy', 'de').format(widget.receipt.creationDateMarektplace)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.watch_later_outlined, size: 16),
                            const Text(' '),
                            Text(DateFormat('Hm', 'de').format(widget.receipt.creationDateMarektplace)),
                          ],
                        ),
                        Text(widget.receipt.receiptMarketplaceReference),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.receipt.receiptCustomer.company != null) Text(widget.receipt.receiptCustomer.company!),
                        Text(widget.receipt.receiptCustomer.name),
                        Text(invoiceAddress.street),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: invoiceAddress.postcode),
                              const TextSpan(text: ' '),
                              TextSpan(text: invoiceAddress.city),
                            ],
                          ),
                        ),
                        Text(invoiceAddress.country.name),
                      ],
                    ),
                  ),
                  ReceiptsOverviewCarrierBar(receipt: widget.receipt),
                  SizedBox(
                    width: 140,
                    child: Column(
                      children: [
                        Tooltip(
                          message: 'Bezahlter Betrag: ${widget.receipt.totalPaidGross} €',
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: switch (widget.receipt.paymentStatus) {
                                PaymentStatus.open => CustomColors.backgroundLightGrey,
                                PaymentStatus.partiallyPaid => CustomColors.backgroundLightOrange,
                                PaymentStatus.paid => CustomColors.backgroundLightGreen,
                              },
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Center(
                                child: switch (widget.receipt.paymentStatus) {
                                  PaymentStatus.open => const Text('Offen'),
                                  PaymentStatus.partiallyPaid => const Text('Teilweise bezahlt'),
                                  PaymentStatus.paid => const Text('Komplett bezahlt'),
                                },
                              ),
                            ),
                          ),
                        ),
                        Gaps.h2,
                        _loadImage(widget.receipt.paymentMethod.logoPath),
                        Gaps.h2,
                        Text('${widget.receipt.profit.toMyCurrencyStringToShow()} ${widget.receipt.currency}'),
                        Text('${calcDiscountPercentage(widget.receipt.totalNet, widget.receipt.profit).toMyCurrencyStringToShow()} %'),
                      ],
                    ),
                  ),
                  const SizedBox(),
                ],
              ),
              if (state.isExpanded[widget.index])
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Expanded(flex: RowWidthsROP.pos, child: Text('Pos', style: TextStyles.defaultBold)),
                              Spacer(),
                              Expanded(flex: RowWidthsROP.articleNumber, child: Text('Artikelnummer', style: TextStyles.defaultBold)),
                              Spacer(),
                              Expanded(flex: RowWidthsROP.ean, child: Text('EAN', style: TextStyles.defaultBold)),
                              Spacer(),
                              Expanded(flex: RowWidthsROP.articleName, child: Text('Name', style: TextStyles.defaultBold)),
                              Spacer(),
                              Expanded(flex: RowWidthsROP.openQuantity, child: Text('Offen', style: TextStyles.defaultBold)),
                              Spacer(),
                              Expanded(flex: RowWidthsROP.quantity, child: Text('Anzahl', style: TextStyles.defaultBold)),
                            ],
                          ),
                          const Divider(),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.receipt.listOfReceiptProduct.length,
                            itemBuilder: (context, index) {
                              return _AppointmentProdcutsContainer(appointmentProduct: widget.receipt.listOfReceiptProduct[index], index: index);
                            },
                            separatorBuilder: (context, index) => const Divider(),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }

  Future<void> _onPdfPressed({required Marketplace marketplace}) async {
    setState(() => _isLoadingPdf = true);
    final receiptName = switch (widget.receipt.receiptTyp) {
      ReceiptTyp.offer => widget.receipt.offerNumberAsString,
      ReceiptTyp.appointment => widget.receipt.appointmentNumberAsString,
      ReceiptTyp.deliveryNote => widget.receipt.deliveryNoteNumberAsString,
      ReceiptTyp.invoice || ReceiptTyp.credit => widget.receipt.invoiceNumberAsString,
    };
    final generatedPdf = await PdfReceiptGenerator.generate(
      receipt: widget.receipt,
      logoUrl: marketplace.logoUrl,
    );

    if (mounted) {
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
                      if (kIsWeb) {
                        await PdfApiWeb.saveDocument(name: '$receiptName.pdf', byteList: generatedPdf, showInBrowser: true);
                      } else {
                        await PdfApiMobile.saveDocument(name: '$receiptName.pdf', byteList: generatedPdf);
                      }
                      if (mounted) context.router.pop();
                    },
                  ),
                  if (kIsWeb)
                    ListTile(
                      leading: const Icon(Icons.download),
                      title: const Text('Herunterladen'),
                      onTap: () async {
                        await PdfApiWeb.saveDocument(name: '$receiptName.pdf', byteList: generatedPdf, showInBrowser: false);
                        if (mounted) context.router.pop();
                      },
                    ),
                  ListTile(
                    leading: const Icon(Icons.print),
                    title: const Text('Drucken'),
                    onTap: () async {
                      await Printing.layoutPdf(onLayout: (_) => generatedPdf);
                      if (mounted) context.router.pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    setState(() => _isLoadingPdf = false);
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
}

class _AppointmentProdcutsContainer extends StatelessWidget {
  final ReceiptProduct appointmentProduct;
  final int index;

  const _AppointmentProdcutsContainer({required this.appointmentProduct, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(flex: RowWidthsROP.pos, child: Text((index + 1).toString(), style: TextStyles.defaultBold)),
        const Spacer(),
        Expanded(flex: RowWidthsROP.articleNumber, child: Text(appointmentProduct.articleNumber, overflow: TextOverflow.ellipsis)),
        const Spacer(),
        Expanded(flex: RowWidthsROP.ean, child: Text(appointmentProduct.ean, overflow: TextOverflow.ellipsis)),
        const Spacer(),
        Expanded(flex: RowWidthsROP.articleName, child: Text(appointmentProduct.name, overflow: TextOverflow.ellipsis)),
        const Spacer(),
        Expanded(
            flex: RowWidthsROP.openQuantity,
            child: Center(
                child: switch (appointmentProduct.quantity - appointmentProduct.shippedQuantity) {
              0 => Text(
                  (appointmentProduct.quantity - appointmentProduct.shippedQuantity).toString(),
                  style: TextStyles.defaultBold.copyWith(
                    color: Colors.green,
                  ),
                ),
              (_) => Text(
                  (appointmentProduct.quantity - appointmentProduct.shippedQuantity).toString(),
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
            })),
        const Spacer(),
        Expanded(flex: RowWidthsROP.quantity, child: Center(child: Text(appointmentProduct.quantity.toString()))),
      ],
    );
  }
}
