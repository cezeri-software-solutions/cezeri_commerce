import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../2_application/database/main_settings/main_settings_bloc.dart';
import '../../../2_application/packing_station/packing_station_bloc.dart';
import '../../../3_domain/entities/carrier/carrier.dart';
import '../../../3_domain/entities/customer/customer.dart';
import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/entities/receipt/receipt_product.dart';
import '../../../constants.dart';
import '../../core/core.dart';

final ItemScrollController _itemScrollController = ItemScrollController();
final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

class PackingStationDetailPage extends StatefulWidget {
  final PackingStationBloc packingStationBloc;
  final AbstractMarketplace marketplace;

  const PackingStationDetailPage({super.key, required this.packingStationBloc, required this.marketplace});

  @override
  State<PackingStationDetailPage> createState() => _PackingStationDetailPageState();
}

class _PackingStationDetailPageState extends State<PackingStationDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackingStationBloc, PackingStationState>(
      bloc: widget.packingStationBloc,
      builder: (context, state) {
        if (state.isLoadingAppointmentOnObserve || state.isLoadingProductsOnObserve) {
          return const Center(child: MyCircularProgressIndicator());
        }
        if (state.firebaseFailure != null && state.isAnyFailure) {
          return const Expanded(child: Center(child: Text('Ein Fehler beim Laden des Auftrages ist aufgetreten!')));
        }
        if (state.appointment == null || state.listOfProducts == null) return const Center(child: MyCircularProgressIndicator());

        final appointment = state.appointment!;
        final carrier = Carrier.carrierList.where((e) => e.carrierTyp == appointment.receiptCarrier.carrierTyp).first;

        final listOfPackagingBoxes = context.read<MainSettingsBloc>().state.mainSettings!.listOfPackagingBoxes;
        final listOfPackagingBoxItems = listOfPackagingBoxes.map((e) => e.name).toList();
        listOfPackagingBoxItems.insert(0, '');

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  _PackingStationDetailInfoContainer(
                    appointment: appointment,
                    carrier: carrier,
                    marketplace: widget.marketplace,
                    customer: state.customer,
                  ),
                  Gaps.h8,
                  Row(
                    children: [
                      const Icon(Icons.qr_code_scanner),
                      Gaps.w16,
                      const Icon(Icons.barcode_reader, color: CustomColors.primaryColor),
                      Gaps.w4,
                      BarcodeKeyboardListener(
                        child: const Text('EAN/SKU Scannen'),
                        onBarcodeScanned: (barcode) {
                          widget.packingStationBloc.add(PackingStationOnEanScannedEvent(context: context, ean: barcode));
                          _onEanScanned(barcode, state.listOfProducts!, appointment.listOfReceiptProduct);
                        },
                      ),
                      Gaps.w16,
                      Checkbox.adaptive(
                        value: state.isPartiallyEnabled,
                        onChanged: (_) => widget.packingStationBloc.add(PackingStationIsPartiallyEnabledEvent()),
                      ),
                      Gaps.w8,
                      const Text('Teillieferung möglich?')
                    ],
                  ),
                ],
              ),
            ),
            Gaps.h8,
            const Divider(height: 0),
            Expanded(
              child: ScrollablePositionedList.builder(
                itemCount: appointment.listOfReceiptProduct.length,
                itemBuilder: (context, index) {
                  final sortedListOfProducts = appointment.listOfReceiptProduct..sort((a, b) => a.name.compareTo(b.name));
                  final product = sortedListOfProducts[index];

                  return Column(
                    children: [
                      if (index == 0) const Divider(height: 2),
                      _PackingStationDetailProductsContainer(
                        receiptProduct: product,
                        listOfProducts: state.listOfProducts!,
                        index: index,
                        packingStationBloc: widget.packingStationBloc,
                      ),
                      const Divider(height: 2),
                    ],
                  );
                },
                itemScrollController: _itemScrollController,
                itemPositionsListener: _itemPositionsListener,
              ),
            ),
            const Divider(height: 0),
            Gaps.h8,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Freiraum:'),
                    Text('${state.remainingVolumePercent}%'),
                    const Text(''),
                  ],
                ),
                Gaps.w16,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Empfohlener Karton:'),
                    if (state.smallesPackagingBox != null) ...[
                      Text(state.smallesPackagingBox!.shortName),
                      Text(state.smallesPackagingBox!.name),
                    ],
                  ],
                ),
                Gaps.w16,
                MyDropdownButtonSmall(
                  fieldTitle: 'Verpackungskarton:',
                  maxWidth: 200,
                  openToTop: true,
                  autoFocusOnSearch: false,
                  value: state.packagingBox.name,
                  onChanged: (value) => widget.packingStationBloc.add(PackingStationOnPackagingBoxChangedEvent(packagingBoxName: value!)),
                  items: state.listOfPackagingBoxes.map((e) => e.name).toList(),
                ),
                Gaps.w16,
                MyTextFormFieldSmall(
                  fieldTitle: 'Gewicht:',
                  maxWidth: 100,
                  controller: state.weightController,
                  onChanged: (value) => widget.packingStationBloc.add(PackingStationOnWeightControllerChangedEvent()),
                ),
                Gaps.w16,
                InkWell(
                  onTap: () => widget.packingStationBloc.add(PackingStationOnPickAllEvent()),
                  child: Container(
                    height: 60,
                    width: 160,
                    color: Colors.blue,
                    child: const Center(child: Text('Alle packen', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white))),
                  ),
                ),
                Gaps.w8,
                InkWell(
                  onTap: () => _onSendPressed(
                    context: context,
                    listOfReceiptProducts: state.appointment!.listOfReceiptProduct,
                    isPartiallyEnabled: state.isPartiallyEnabled,
                    packingStationBloc: widget.packingStationBloc,
                    customer: state.customer,
                  ),
                  child: Container(
                    height: 60,
                    width: 160,
                    color: Colors.green,
                    child: Center(
                        child: state.isLoadingOnGenerateAppointments
                            ? const MyCircularProgressIndicator(color: Colors.white)
                            : const Text('Senden', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white))),
                  ),
                ),
                Gaps.w8,
              ],
            ),
            Gaps.h8,
          ],
        );
      },
    );
  }

  void _onEanScanned(String value, List<Product> listOfProducts, List<ReceiptProduct> listOfReceiptProducts) async {
    if (value.length == 13) {
      final product = listOfProducts.where((e) => e.ean == value).firstOrNull;

      if (product == null) return;

      final receiptProduct = listOfReceiptProducts.where((e) => e.productId == product.id).firstOrNull;

      if (receiptProduct == null) return;

      final index = listOfReceiptProducts.indexWhere((e) => e.productId == receiptProduct.productId);

      await _scrollToIndex(index);
    }
  }

  void _onSendPressed({
    required BuildContext context,
    required List<ReceiptProduct> listOfReceiptProducts,
    required bool isPartiallyEnabled,
    required PackingStationBloc packingStationBloc,
    required Customer? customer,
  }) async {
    bool generateInvoice = true;
    if (customer != null && customer.customerInvoiceType == CustomerInvoiceType.collectiveInvoice) {
      generateInvoice = false;
    }

    if (listOfReceiptProducts.every((e) => e.shippedQuantity == e.quantity)) {
      packingStationBloc.add(PackingStationGenerateFromAppointmentEvent(generateInvoice: generateInvoice));
    } else if (listOfReceiptProducts.every((e) => e.shippedQuantity == 0)) {
      await showMyDialogAlert(
        context: context,
        title: 'ACHTUNG',
        content: 'Du kannst keinen Auftrag absenden, ohne einen einzigen Artikel zu packen.',
      );
    } else {
      if (isPartiallyEnabled) {
        packingStationBloc.add(PackingStationGenerateFromAppointmentEvent(generateInvoice: generateInvoice));
      } else {
        await showMyDialogAlert(
            context: context,
            title: 'ACHTUNG',
            content:
                'Du hast noch nicht den kompletten Auftrag gepackt.\nUm Teillieferungen zu ermöglichen, bitte\n\n"Teillieferung möglich?"\n\n aktivieren.');
      }
    }
  }

  Future<void> _scrollToIndex(int index) async {
    // Überprüfen Sie die aktuell sichtbaren Elemente.
    var positions = _itemPositionsListener.itemPositions.value;
    bool isIndexVisible =
        positions.any((ItemPosition position) => position.index == index && position.itemLeadingEdge >= 0 && position.itemTrailingEdge <= 1);

    // Scrollen Sie nur, wenn das Element nicht sichtbar ist oder außerhalb des akzeptablen Bereichs liegt.
    if (!isIndexVisible) {
      await _itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}

//? #########################################################################################################################################

class _PackingStationDetailInfoContainer extends StatelessWidget {
  final Receipt appointment;
  final Carrier carrier;
  final AbstractMarketplace marketplace;
  final Customer? customer;

  const _PackingStationDetailInfoContainer({required this.appointment, required this.carrier, required this.marketplace, required this.customer});

  @override
  Widget build(BuildContext context) {
    return MyFormFieldContainer(
      width: double.infinity,
      borderRadius: 6,
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Auftrag: ${appointment.appointmentNumberAsString}', style: TextStyles.defaultBold),
          Row(
            children: [
              const Text('Kunde:  ', style: TextStyles.defaultBold),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (customer != null && customer!.customerNumber != 0) Text(customer!.customerNumber.toString()),
                  if (appointment.receiptCustomer.company != null && appointment.receiptCustomer.company != '')
                    Text(appointment.receiptCustomer.company.toString()),
                  Text(appointment.receiptCustomer.name),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Text(DateFormat('EE dd.MM.yyy - HH:mm', 'de').format(appointment.creationDateMarektplace)),
              Text(DateFormat('EE dd.MM.yyy - HH:mm', 'de').format(appointment.creationDate)),
            ],
          ),
          Column(
            children: [
              Image.asset(carrier.imagePath, height: 25, width: 65, fit: BoxFit.scaleDown),
              Text(appointment.receiptCarrier.carrierProduct.productName),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 25,
                width: 65,
                child: MyAvatar(
                  name: marketplace.shortName,
                  imageUrl: marketplace.logoUrl,
                  shape: BoxShape.rectangle,
                  fit: BoxFit.scaleDown,
                ),
              ),
              Text(marketplace.name),
            ],
          ),
        ],
      ),
    );
  }
}

class _PackingStationDetailProductsContainer extends StatelessWidget {
  final PackingStationBloc packingStationBloc;
  final ReceiptProduct receiptProduct;
  final int index;
  final List<Product> listOfProducts;

  const _PackingStationDetailProductsContainer({
    required this.receiptProduct,
    required this.listOfProducts,
    required this.index,
    required this.packingStationBloc,
  });

  @override
  Widget build(BuildContext context) {
    final product = listOfProducts.where((e) => e.id == receiptProduct.productId).firstOrNull;

    return Container(
      color: receiptProduct.shippedQuantity != receiptProduct.quantity ? Colors.white : Colors.green[200],
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Gaps.w8,
          product != null
              ? MyAvatar(
                  name: product.name,
                  imageUrl: product.listOfProductImages.isNotEmpty ? product.listOfProductImages.where((e) => e.isDefault).first.fileUrl : null,
                  fit: BoxFit.scaleDown,
                )
              : const SizedBox(height: 50, width: 50, child: Icon(Icons.question_mark)),
          Gaps.w8,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(receiptProduct.articleNumber),
                MyText(receiptProduct.name),
              ],
            ),
          ),
          Text('${receiptProduct.shippedQuantity} / ${receiptProduct.quantity}', style: TextStyles.h2Bold),
          Gaps.w16,
          InkWell(
            onTap: () => packingStationBloc.add(PackingStationOnPickingQuantityChanged(index: index, isSubtract: true, pickCompletely: false)),
            child: Container(
              color: Colors.orange,
              height: 50,
              width: 50,
              child: const Icon(Icons.remove, color: Colors.white),
            ),
          ),
          Gaps.w8,
          InkWell(
            onTap: () => packingStationBloc.add(PackingStationOnPickingQuantityChanged(index: index, isSubtract: false, pickCompletely: false)),
            child: Container(
              color: Colors.green,
              height: 50,
              width: 50,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
          Gaps.w8,
          InkWell(
            onTap: () => packingStationBloc.add(PackingStationOnPickingQuantityChanged(index: index, isSubtract: false, pickCompletely: true)),
            child: Container(
              color: Colors.blue,
              height: 50,
              width: 50,
              child: const Icon(Icons.checklist, color: Colors.white),
            ),
          ),
          Gaps.w8,
        ],
      ),
    );
  }
}
