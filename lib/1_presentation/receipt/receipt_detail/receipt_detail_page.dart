import 'dart:math';

import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '/2_application/database/main_settings/main_settings_bloc.dart';
import '/3_domain/entities/marketplace/abstract_marketplace.dart';
import '/3_domain/entities/receipt/receipt.dart';
import '/3_domain/enums/enums.dart';
import '/constants.dart';
import '../../../2_application/database/receipt_detail/receipt_detail_bloc.dart';
import '../../../2_application/database/receipt_detail_products/receipt_detail_products_bloc.dart';
import '../../core/functions/dialogs.dart';
import '../../core/widgets/my_circular_progress_indicator.dart';
import '../../core/widgets/my_form_field_small.dart';
import '../../core/widgets/my_outlined_button.dart';
import '../widgets/receipt_detail_address_card.dart';
import '../widgets/receipt_detail_carrier_card.dart';
import '../widgets/receipt_detail_general_card.dart';
import '../widgets/receipt_detail_payment_method_card.dart';
import '../widgets/receipt_detail_products_card.dart';
import '../widgets/receipt_detail_products_total_card.dart';
import 'receipt_detail_screen.dart';

class ReceiptDetailPage extends StatefulWidget {
  final ReceiptDetailBloc receiptDetailBloc;
  final ReceiptDetailProductsBloc receiptDetailProductsBloc;
  final List<AbstractMarketplace> listOfMarketplaces;
  final ReceiptCreateOrEdit receiptCreateOrEdit;
  final ReceiptType receiptTyp;

  const ReceiptDetailPage({
    super.key,
    required this.receiptDetailBloc,
    required this.receiptDetailProductsBloc,
    required this.listOfMarketplaces,
    required this.receiptCreateOrEdit,
    required this.receiptTyp,
  });

  @override
  State<ReceiptDetailPage> createState() => _ReceiptDetailPageState();
}

class _ReceiptDetailPageState extends State<ReceiptDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptDetailBloc, ReceiptDetailState>(
      bloc: widget.receiptDetailBloc,
      builder: (context, state) {
        final mainSettings = context.read<MainSettingsBloc>().state.mainSettings!;
        final screenWidth = MediaQuery.sizeOf(context).width;
        final responsiveness = screenWidth > 700 ? Responsiveness.isTablet : Responsiveness.isMobil;

        final appBar = AppBar(
          title: _getAppBarTitle(state.receipt!),
          centerTitle: responsiveness == Responsiveness.isTablet ? true : false,
          actions: [
            if (widget.receiptCreateOrEdit == ReceiptCreateOrEdit.edit)
              IconButton(
                onPressed: () => widget.receiptDetailBloc.add(
                  ReceiptDetailGetReceiptOrSetEmptyEvent(
                    receiptId: state.receipt!.id,
                    receiptType: widget.receiptTyp,
                  ),
                ),
                icon: const Icon(Icons.refresh, size: 30),
              ),
            responsiveness == Responsiveness.isTablet ? Gaps.w32 : Gaps.w8,
            if (widget.receiptTyp == ReceiptType.deliveryNote) ...[
              IconButton(
                onPressed: () => _createParcelLabel(state.receipt!.weight),
                icon: state.isLoadingParcelLabelOnCreate
                    ? const MyCircularProgressIndicator()
                    : const Icon(Icons.new_label, color: CustomColors.primaryColor),
              ),
              responsiveness == Responsiveness.isTablet ? Gaps.w32 : Gaps.w8,
            ],
            BlocBuilder<ReceiptDetailProductsBloc, ReceiptDetailProductsState>(
              bloc: widget.receiptDetailProductsBloc,
              builder: (context, stateReceiptDetail) {
                return MyOutlinedButton(
                  buttonText: 'Speichern',
                  onPressed: () async {
                    final isValid = await _validateReceiptOncreateOrUpdate(state, stateReceiptDetail);
                    if (!isValid) return;
                    if (widget.receiptCreateOrEdit == ReceiptCreateOrEdit.edit) {
                      final updatedAppointment = stateReceiptDetail.receipt.copyWith(
                        //* Hier kommen die Änderungen vom ReceiptBloc
                        //* Also Änderungen die oberhalb passieren bevor die Produkte anfangen
                        listOfReceiptProduct: stateReceiptDetail.listOfReceiptProducts,
                        marketplaceId: state.receipt!.marketplaceId,
                        receiptMarketplace: state.receipt!.receiptMarketplace,
                        paymentMethod: state.receipt!.paymentMethod,
                        paymentStatus: state.receipt!.paymentStatus,
                        receiptCarrier: state.receipt!.receiptCarrier,
                        addressDelivery: state.receipt!.addressDelivery,
                        addressInvoice: state.receipt!.addressInvoice,
                        receiptCustomer: state.receipt!.receiptCustomer,
                        isDeliveryBlocked: state.receipt!.isDeliveryBlocked,
                        lastEditingDate: DateTime.now(),
                      );
                      widget.receiptDetailBloc.add(ReceiptDetailUpdateReceiptEvent(
                        receipt: updatedAppointment,
                        oldListOfReceiptProducts: state.receipt!.listOfReceiptProduct,
                        newListOfReceiptProducts: stateReceiptDetail.listOfReceiptProducts,
                      ));
                    } else {
                      final toCreateReceipt = stateReceiptDetail.receipt.copyWith(
                        listOfReceiptProduct: stateReceiptDetail.listOfReceiptProducts,
                        marketplaceId: state.receipt!.marketplaceId,
                        receiptMarketplace: state.receipt!.receiptMarketplace,
                        paymentMethod: state.receipt!.paymentMethod,
                        paymentStatus: state.receipt!.paymentStatus,
                        receiptCarrier: state.receipt!.receiptCarrier,
                        addressDelivery: state.receipt!.addressDelivery,
                        addressInvoice: state.receipt!.addressInvoice,
                        receiptCustomer: state.receipt!.receiptCustomer,
                        isDeliveryBlocked: state.receipt!.isDeliveryBlocked,
                        lastEditingDate: DateTime.now(),
                        creationDate: DateTime.now(),
                        receiptTyp: widget.receiptTyp,
                        currency: mainSettings.currency,
                      );
                      widget.receiptDetailBloc.add(ReceiptDetailCreateReceiptManuallyEvent(receipt: toCreateReceipt));
                    }
                  },
                  isLoading: widget.receiptCreateOrEdit == ReceiptCreateOrEdit.edit ? state.isLoadingReceiptOnUpdate : state.isLoadingReceiptOnCreate,
                  buttonBackgroundColor: Colors.green,
                );
              },
            ),
            responsiveness == Responsiveness.isTablet ? Gaps.w32 : Gaps.w8,
          ],
        );

        return Scaffold(
          appBar: appBar,
          body: SafeArea(
            child: responsiveness == Responsiveness.isTablet
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: ReceiptDetailAddressCard(receipt: state.receipt!, receiptDetailBloc: widget.receiptDetailBloc)),
                              Gaps.w16,
                              Expanded(
                                child: ReceiptDetailGeneralCard(
                                  receipt: state.receipt!,
                                  receiptDetailBloc: widget.receiptDetailBloc,
                                  listOfMarketplaces: widget.listOfMarketplaces,
                                ),
                              ),
                            ],
                          ),
                          Gaps.h16,
                          ReceiptDetailProductsCard(
                              receiptDetailBloc: widget.receiptDetailBloc, receiptDetailProductsBloc: widget.receiptDetailProductsBloc),
                          Gaps.h16,
                          Row(
                            children: [
                              const Expanded(child: SizedBox()),
                              Gaps.w16,
                              Expanded(
                                child: ReceiptDetailProductsTotalCard(
                                  receiptDetailBloc: widget.receiptDetailBloc,
                                  receiptDetailProductsBloc: widget.receiptDetailProductsBloc,
                                ),
                              ),
                            ],
                          ),
                          Gaps.h16,
                          Row(
                            children: [
                              Expanded(child: ReceiptDetailPaymentMethodCard(receiptDetailBloc: widget.receiptDetailBloc)),
                              Gaps.w16,
                              Expanded(child: ReceiptDetailCarrierCard(receiptDetailBloc: widget.receiptDetailBloc)),
                            ],
                          ),
                          Gaps.h42,
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8),
                    child: Expanded(
                      child: ListView(
                        children: [
                          ReceiptDetailAddressCard(receipt: state.receipt!, receiptDetailBloc: widget.receiptDetailBloc),
                          Gaps.h16,
                          ReceiptDetailGeneralCard(
                            receipt: state.receipt!,
                            receiptDetailBloc: widget.receiptDetailBloc,
                            listOfMarketplaces: widget.listOfMarketplaces,
                          ),
                          Gaps.h16,
                          Scrollbar(
                            trackVisibility: true,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                width: (screenWidth + 1200) - 390,
                                child: ReceiptDetailProductsCard(
                                    receiptDetailBloc: widget.receiptDetailBloc, receiptDetailProductsBloc: widget.receiptDetailProductsBloc),
                              ),
                            ),
                          ),
                          Gaps.h16,
                          ReceiptDetailProductsTotalCard(
                              receiptDetailBloc: widget.receiptDetailBloc, receiptDetailProductsBloc: widget.receiptDetailProductsBloc),
                          Gaps.h16,
                          ReceiptDetailPaymentMethodCard(receiptDetailBloc: widget.receiptDetailBloc),
                          Gaps.h16,
                          ReceiptDetailCarrierCard(receiptDetailBloc: widget.receiptDetailBloc),
                          Gaps.h42,
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Text _getAppBarTitle(Receipt receipt) {
    return switch (receipt.receiptTyp) {
      ReceiptType.offer => Text(receipt.offerNumberAsString.isNotEmpty ? 'Angebot: ${receipt.offerNumberAsString}' : 'Neues Angebot'),
      ReceiptType.appointment =>
        Text(receipt.appointmentNumberAsString.isNotEmpty ? 'Auftrag: ${receipt.appointmentNumberAsString}' : 'Neuer Auftrag'),
      ReceiptType.deliveryNote =>
        Text(receipt.deliveryNoteNumberAsString.isNotEmpty ? 'Lieferschein: ${receipt.deliveryNoteNumberAsString}' : 'Neuer Lieferschein'),
      ReceiptType.invoice => Text(receipt.invoiceNumberAsString.isNotEmpty ? 'Rechnung: ${receipt.invoiceNumberAsString}' : 'Neue Rechnung'),
      ReceiptType.credit => Text(receipt.invoiceNumberAsString.isNotEmpty ? 'Guschrift: ${receipt.invoiceNumberAsString}' : 'Neue Gutschrift'),
    };
  }

  void _createParcelLabel(double weight) {
    WoltModalSheet.show(
      context: context,
      useSafeArea: false,
      pageListBuilder: (context) => [
        WoltModalSheetPage(
          isTopBarLayerAlwaysVisible: true,
          topBarTitle: const Text('Gewicht eingeben', style: TextStyles.h3Bold),
          child: _ParcelLabelWeight(receiptDetailBloc: widget.receiptDetailBloc, weight: weight),
        ),
      ],
    );
  }

  Future<bool> _validateReceiptOncreateOrUpdate(ReceiptDetailState stateReceiptDetail, ReceiptDetailProductsState stateReceiptDetailProducts) async {
    if (stateReceiptDetail.receipt!.marketplaceId == '') {
      await showMyDialogAlert(context: context, title: 'Achtung!', content: 'Ein Marktplatz muss ausgewählt werden');
      return false;
    }
    if (stateReceiptDetailProducts.listOfReceiptProducts.any((e) => e.articleNumber == '' || e.name == '')) {
      await showMyDialogAlert(
        context: context,
        title: 'Achtung!',
        content: 'Es dark kein Artikel mit leerer Artikelnummer oder leerem Artikelnamen vorhanden sein',
      );
      return false;
    }
    return true;
  }
}

class _ParcelLabelWeight extends StatelessWidget {
  final ReceiptDetailBloc receiptDetailBloc;
  final double weight;

  const _ParcelLabelWeight({required this.receiptDetailBloc, required this.weight});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: weight.toString());

    return Padding(
      padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: max(MediaQuery.paddingOf(context).bottom, 16)),
      child: Column(
        children: [
          SizedBox(width: 100, child: MyTextFormFieldSmall(controller: controller, suffix: const Text('kg'))),
          Gaps.h24,
          MyOutlinedButton(
            buttonText: 'Label erstellen',
            onPressed: () {
              receiptDetailBloc.add(ReceiptDetailCreateParcelLabelReceiptEvent(weight: controller.text.toMyDouble()));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
