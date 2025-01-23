import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '/2_application/database/main_settings/main_settings_bloc.dart';
import '/3_domain/entities/marketplace/abstract_marketplace.dart';
import '/3_domain/entities/receipt/receipt.dart';
import '/constants.dart';
import '../../../2_application/database/receipt_detail/receipt_detail_bloc.dart';
import '../../../2_application/database/receipt_detail_products/receipt_detail_products_bloc.dart';
import '../../../3_domain/entities/settings/main_settings.dart';
import '../../core/core.dart';
import '../widgets/receipt_detail_address_card.dart';
import '../widgets/receipt_detail_carrier_card.dart';
import '../widgets/receipt_detail_comment_card.dart';
import '../widgets/receipt_detail_general_card.dart';
import '../widgets/receipt_detail_payment_method_card.dart';
import '../widgets/receipt_detail_products_card.dart';
import '../widgets/receipt_detail_products_total_card.dart';
import '../widgets/receipt_detail_same_receipts_card.dart';
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
        final screenWidth = context.screenWidth;
        final isTabletOrLarger = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);

        final appBar = AppBar(
          title: _getAppBarTitle(state.receipt!),
          centerTitle: isTabletOrLarger ? true : false,
          actions: [
            //* Set orderStatus in marketplace with one click
            //* Future as event in bloc
            // IconButton(
            //   onPressed: () async {
            //     final marketplaceEditRepository = GetIt.I<MarketplaceEditRepository>();
            //     final marketplaceRepository = GetIt.I<MarketplaceRepository>();
            //     final marketplace = await marketplaceRepository.getMarketplace(state.receipt!.marketplaceId);

            //     final response = await marketplaceEditRepository.setOrderStatusInMarketplace(
            //       marketplace.getRight() as MarketplaceShopify,
            //       state.receipt!.receiptMarketplaceId,
            //       OrderStatusUpdateType.onShipping,
            //       state.receipt!.listOfParcelTracking.isNotEmpty ? state.receipt!.listOfParcelTracking.first : null,
            //     );

            //     print(response);
            //   },
            //   icon: const Icon(Icons.abc),
            // ),
            if (widget.receiptCreateOrEdit == ReceiptCreateOrEdit.edit)
              IconButton(
                onPressed: () => widget.receiptDetailBloc.add(
                  ReceiptDetailGetReceiptEvent(
                    receiptId: state.receipt!.id,
                    receiptType: widget.receiptTyp,
                  ),
                ),
                icon: const Icon(Icons.refresh, size: 30),
              ),
            if (widget.receiptTyp == ReceiptType.deliveryNote) ...[
              IconButton(
                onPressed: () => _createParcelLabel(state.receipt!.weight),
                icon: state.isLoadingParcelLabelOnCreate
                    ? const MyCircularProgressIndicator()
                    : const Icon(Icons.new_label, color: CustomColors.primaryColor),
              ),
            ],
            BlocBuilder<ReceiptDetailProductsBloc, ReceiptDetailProductsState>(
              bloc: widget.receiptDetailProductsBloc,
              builder: (context, stateReceiptDetail) {
                final isLoading =
                    widget.receiptCreateOrEdit == ReceiptCreateOrEdit.edit ? state.isLoadingReceiptOnUpdate : state.isLoadingReceiptOnCreate;

                return isTabletOrLarger
                    ? MyOutlinedButton(
                        buttonText: 'Speichern',
                        onPressed: () => _onSavePressed(state, stateReceiptDetail, mainSettings),
                        isLoading: isLoading,
                        buttonBackgroundColor: Colors.green,
                      )
                    : MyIconButton(
                        onPressed: () => _onSavePressed(state, stateReceiptDetail, mainSettings),
                        isLoading: isLoading,
                        icon: const Icon(Icons.save, color: Colors.green),
                      );
              },
            ),
            isTabletOrLarger ? Gaps.w32 : Gaps.w8,
          ],
        );

        return Scaffold(
          appBar: appBar,
          body: SafeArea(
            child: isTabletOrLarger
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          // TODO: LÖSCHEN
                          Text(state.receipt!.tax.taxRate.toString()),
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
                          Gaps.h16,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ReceiptDetailCommentCard(
                                  receiptDetailBloc: widget.receiptDetailBloc,
                                  internalCommentController: state.internalCommentController,
                                  globalCommentController: state.globalCommentController,
                                ),
                              ),
                              if (state.listOfSameReceipts != null && state.listOfSameReceipts!.isNotEmpty) ...[
                                Gaps.w16,
                                Expanded(child: ReceiptDetailSameReceiptsCard(receiptDetailBloc: widget.receiptDetailBloc, state: state)),
                              ],
                            ],
                          ),
                          Gaps.h42,
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8),
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
                          receiptDetailBloc: widget.receiptDetailBloc,
                          receiptDetailProductsBloc: widget.receiptDetailProductsBloc,
                        ),
                        Gaps.h16,
                        ReceiptDetailPaymentMethodCard(receiptDetailBloc: widget.receiptDetailBloc),
                        Gaps.h16,
                        ReceiptDetailCarrierCard(receiptDetailBloc: widget.receiptDetailBloc),
                        Gaps.h16,
                        ReceiptDetailCommentCard(
                          receiptDetailBloc: widget.receiptDetailBloc,
                          internalCommentController: state.internalCommentController,
                          globalCommentController: state.globalCommentController,
                        ),
                        if (state.listOfSameReceipts != null && state.listOfSameReceipts!.isNotEmpty) ...[
                          Gaps.h16,
                          ReceiptDetailSameReceiptsCard(receiptDetailBloc: widget.receiptDetailBloc, state: state),
                        ],
                        Gaps.h42,
                      ],
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

  bool _validateReceiptOncreateOrUpdate(ReceiptDetailState stateReceiptDetail, ReceiptDetailProductsState stateReceiptDetailProducts) {
    if (stateReceiptDetail.receipt!.marketplaceId == '') {
      showMyDialogAlert(context: context, title: 'Achtung!', content: 'Ein Marktplatz muss ausgewählt werden');
      return false;
    }
    if (stateReceiptDetailProducts.listOfReceiptProducts.any((e) => e.articleNumber == '' || e.name == '')) {
      showMyDialogAlert(
        context: context,
        title: 'Achtung!',
        content: 'Es darf kein Artikel mit leerer Artikelnummer oder leerem Artikelnamen vorhanden sein',
      );
      return false;
    }
    return true;
  }

  void _onSavePressed(ReceiptDetailState receiptDetailState, ReceiptDetailProductsState receiptDetailProductsState, MainSettings mainSettings) {
    final isValid = _validateReceiptOncreateOrUpdate(receiptDetailState, receiptDetailProductsState);
    if (!isValid) return;
    if (widget.receiptCreateOrEdit == ReceiptCreateOrEdit.edit) {
      final updatedReceipt = receiptDetailProductsState.receipt.copyWith(
        //* Hier kommen die Änderungen vom ReceiptBloc
        //* Also Änderungen die oberhalb passieren bevor die Produkte anfangen
        listOfReceiptProduct: receiptDetailProductsState.listOfReceiptProducts,
        marketplaceId: receiptDetailState.receipt!.marketplaceId,
        receiptMarketplace: receiptDetailState.receipt!.receiptMarketplace,
        paymentMethod: receiptDetailState.receipt!.paymentMethod,
        paymentStatus: receiptDetailState.receipt!.paymentStatus,
        receiptCarrier: receiptDetailState.receipt!.receiptCarrier,
        addressDelivery: receiptDetailState.receipt!.addressDelivery,
        addressInvoice: receiptDetailState.receipt!.addressInvoice,
        receiptCustomer: receiptDetailState.receipt!.receiptCustomer,
        isDeliveryBlocked: receiptDetailState.receipt!.isDeliveryBlocked,
        commentInternal: receiptDetailState.internalCommentController.text,
        commentGlobal: receiptDetailState.globalCommentController.text,
        lastEditingDate: DateTime.now(),
      );
      widget.receiptDetailBloc.add(ReceiptDetailUpdateReceiptEvent(
        receipt: updatedReceipt,
        oldListOfReceiptProducts: receiptDetailState.receipt!.listOfReceiptProduct,
        newListOfReceiptProducts: receiptDetailProductsState.listOfReceiptProducts,
      ));
    } else {
      final toCreateReceipt = receiptDetailProductsState.receipt.copyWith(
        listOfReceiptProduct: receiptDetailProductsState.listOfReceiptProducts,
        marketplaceId: receiptDetailState.receipt!.marketplaceId,
        receiptMarketplace: receiptDetailState.receipt!.receiptMarketplace,
        paymentMethod: receiptDetailState.receipt!.paymentMethod,
        paymentStatus: receiptDetailState.receipt!.paymentStatus,
        receiptCarrier: receiptDetailState.receipt!.receiptCarrier,
        addressDelivery: receiptDetailState.receipt!.addressDelivery,
        addressInvoice: receiptDetailState.receipt!.addressInvoice,
        receiptCustomer: receiptDetailState.receipt!.receiptCustomer,
        isDeliveryBlocked: receiptDetailState.receipt!.isDeliveryBlocked,
        commentInternal: receiptDetailState.internalCommentController.text,
        commentGlobal: receiptDetailState.globalCommentController.text,
        lastEditingDate: DateTime.now(),
        creationDate: DateTime.now(),
        receiptTyp: widget.receiptTyp,
        currency: mainSettings.currency,
      );
      widget.receiptDetailBloc.add(ReceiptDetailCreateReceiptManuallyEvent(receipt: toCreateReceipt));
    }
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
