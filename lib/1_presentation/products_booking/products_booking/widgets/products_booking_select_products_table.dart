import 'package:flutter/material.dart';

import '../../../../2_application/database/products_booking/products_booking_bloc.dart';
import '../../../../3_domain/entities/product/booking_product.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

Table productsBookingSelectProductsTable({
  required ProductsBookingBloc productsBookingBloc,
  required ProductsBookingState state,
  required List<BookingProduct> listOfBookingProductsFromReorders,
  required double screenWidth,
}) {
  final paddingRight = listOfBookingProductsFromReorders.isEmpty ? screenWidth / 10 : 20.0;
  final padding = EdgeInsets.only(top: 7, right: paddingRight, left: 8);
  const constraints = BoxConstraints(maxHeight: 32);
  final List<Widget> rowChildren = [
    const SizedBox.shrink(),
    const SizedBox.shrink(),
    const SizedBox.shrink(),
    const SizedBox.shrink(),
    const SizedBox.shrink(),
    const SizedBox.shrink(),
    const SizedBox.shrink(),
  ];

  List<Widget> headers = [
    ConstrainedBox(
      constraints: constraints,
      child: Checkbox.adaptive(
        value: state.isAllReorderProductsSelected,
        onChanged: (value) => productsBookingBloc.add(OnProductsBookingSelectAllReorderProductsEvent(isSelected: value!)),
      ),
    ),
    Padding(padding: padding, child: const Text('Artikelnummer', style: TextStyle(fontWeight: FontWeight.bold))),
    Padding(padding: padding, child: const Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
    Tooltip(
      message: 'Verfügbarer Bestand / Lagerbestand',
      child: Padding(padding: padding, child: const Text('Akt. Bestand', style: TextStyle(fontWeight: FontWeight.bold))),
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
      return const BoxDecoration(color: CustomColors.ultraLightOrange);
    }
    if (rowIndex % 2 == 1) return const BoxDecoration(color: CustomColors.ultraLightBlue);
    return null;
  }

  for (final bookingProduct in listOfBookingProductsFromReorders) {
    final product = state.listOfAllProducts?.where((e) => e.id == bookingProduct.productId).firstOrNull;
    final rowDecoration = getRowColor(bookingProduct, rowIndex);

    // Datenzeile hinzufügen
    rows.add(TableRow(
      decoration: rowDecoration,
      children: [
        ConstrainedBox(
          constraints: constraints,
          child: Checkbox.adaptive(
            value: state.selectedReorderProducts.any((e) => e.id == bookingProduct.id),
            onChanged: (value) => productsBookingBloc.add(OnProductsBookingSelectReorderProductEvent(bookingProduct: bookingProduct)),
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
