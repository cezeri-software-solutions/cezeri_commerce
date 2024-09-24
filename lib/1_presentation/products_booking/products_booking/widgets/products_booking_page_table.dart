import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../2_application/database/products_booking/products_booking_bloc.dart';
import '../../../../3_domain/entities/product/booking_product.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

Table productsBookingPageTable({
  required BuildContext context,
  required ProductsBookingBloc productsBookingBloc,
  required ProductsBookingState state,
  required List<BookingProduct> bookingProductsList,
  required double screenWidth,
}) {
  final paddingRight = bookingProductsList.isEmpty ? screenWidth / 10 : 20.0;
  final padding = EdgeInsets.only(top: 7, right: paddingRight, left: 8);
  const constraints = BoxConstraints(maxHeight: 32);

  void showRemoveDialog(BookingProduct bookingProduct) {
    showMyDialogDelete(
      context: context,
      content: 'Bist du sicher, dass du "${bookingProduct.name}" aus der Liste löschen willst?',
      onConfirm: () {
        productsBookingBloc.add(OnProductsBookingRemoveFromSelectedReorderProductsEvent(bookingProduct: bookingProduct));
        context.maybePop();
      },
    );
  }

  final List<Widget> rowChildren = [
    const SizedBox.shrink(),
    const SizedBox.shrink(),
    const SizedBox.shrink(),
    const SizedBox.shrink(),
    const SizedBox.shrink(),
    const SizedBox.shrink(),
    const SizedBox.shrink(),
    const SizedBox.shrink(),
  ];

  List<Widget> headers = [
    const SizedBox(),
    Padding(padding: padding, child: const Text('Artikelnummer', style: TextStyle(fontWeight: FontWeight.bold))),
    Padding(padding: padding, child: const Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
    Tooltip(
      message: 'Verfügbarer Bestand / Lagerbestand',
      child: Padding(padding: padding, child: const Text('Akt. Bestand', style: TextStyle(fontWeight: FontWeight.bold))),
    ),
    Tooltip(
      message: 'Anzahl die zum Bestand hinzugefügt werden soll',
      child: Padding(padding: padding, child: const Text('Buchungsmenge', style: TextStyle(fontWeight: FontWeight.bold))),
    ),
    Tooltip(
      message: 'Offene Menge / Nachbestellte Menge',
      child: Padding(padding: padding, child: const Text('Menge', style: TextStyle(fontWeight: FontWeight.bold))),
    ),
    Padding(padding: padding, child: const Text('EAN', style: TextStyle(fontWeight: FontWeight.bold))),
    Padding(padding: padding, child: const Text('Bestellnummer', style: TextStyle(fontWeight: FontWeight.bold))),
  ];

  List<TableRow> rows = [
    TableRow(decoration: BoxDecoration(color: Colors.grey[200]), children: headers),
  ];

  rows.add(TableRow(
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.grey),
      ),
    ),
    children: rowChildren,
  ));

  int rowIndex = 0;

  BoxDecoration? getRowColor(BookingProduct bookingProduct, int rowIndex) {
    if (bookingProduct.productId.isEmpty || bookingProduct.productId.startsWith('00000')) {
      return const BoxDecoration(color: Color.fromARGB(255, 252, 238, 199));
    }
    if (rowIndex % 2 == 1) return const BoxDecoration(color: CustomColors.ultraLightBlue);
    return null;
  }

  for (final bookingProduct in bookingProductsList) {
    final product = state.listOfAllProducts?.where((e) => e.id == bookingProduct.productId).firstOrNull;
    final rowDecoration = getRowColor(bookingProduct, rowIndex);

    // Datenzeile hinzufügen
    rows.add(TableRow(
      decoration: rowDecoration,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5, right: paddingRight, left: 8),
          child: ConstrainedBox(
            constraints: constraints,
            child: InkWell(
              onTap: () => showRemoveDialog(bookingProduct),
              child: const Icon(Icons.delete, color: Colors.red),
            ),
          ),
        ),
        Padding(padding: padding, child: Text(bookingProduct.articleNumber)),
        Padding(padding: padding, child: Text(bookingProduct.name)),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: padding,
            child: state.isLoadingProductsBookingProductsOnObserve
                ? const SizedBox(height: 20, width: 20, child: MyCircularProgressIndicator())
                : Text(product != null ? '${product.availableStock} / ${product.warehouseStock}' : 'k.A.'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
          child: MyTextFormFieldSmallDouble(
            controller: state.quantityControllers[rowIndex],
            onChanged: (_) => productsBookingBloc.add(OnProductsBookingQuantityControllerChangedEvent()),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(padding: padding, child: Text('${bookingProduct.openQuantity} / ${bookingProduct.quantity}', style: TextStyles.defaultBold)),
        ),
        Padding(padding: padding, child: Text(bookingProduct.ean)),
        Padding(padding: padding, child: Text(bookingProduct.reorderNumber)),
      ],
    ));

    // Trennlinie als Zeilendekoration hinzufügen
    rows.add(TableRow(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      children: rowChildren,
    ));

    rowIndex++;
  }

  return Table(
    children: rows,
    columnWidths: Map.fromIterable(
      List.generate(headers.length, (index) => index),
      value: (index) => const IntrinsicColumnWidth(),
    ),
  );
}
