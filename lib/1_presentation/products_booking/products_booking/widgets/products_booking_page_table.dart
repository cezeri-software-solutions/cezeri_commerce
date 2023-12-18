import 'package:flutter/material.dart';

import '../../../../2_application/firebase/products_booking/products_booking_bloc.dart';
import '../../../../3_domain/entities/product/booking_product.dart';
import '../../../core/widgets/my_text_form_field_small_double.dart';

Table productsBookingPageTable({
  required ProductsBookingBloc productsBookingBloc,
  required ProductsBookingState state,
  required List<BookingProduct> bookingProductsList,
  required double screenWidth,
}) {
  final paddingRight = bookingProductsList.isEmpty ? screenWidth / 10 : 20.0;
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
    const SizedBox(),
    Padding(padding: padding, child: const Text('Artikelnummer', style: TextStyle(fontWeight: FontWeight.bold))),
    Padding(padding: padding, child: const Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
    Padding(padding: padding, child: const Text('EAN', style: TextStyle(fontWeight: FontWeight.bold))),
    Padding(padding: padding, child: const Text('Akt. Bestand', style: TextStyle(fontWeight: FontWeight.bold))),
    Padding(padding: padding, child: const Text('Menge', style: TextStyle(fontWeight: FontWeight.bold))),
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

  for (final bookingProduct in bookingProductsList) {
    BoxDecoration? rowDecoration;
    if (rowIndex % 2 == 1) rowDecoration = const BoxDecoration(color: Color.fromARGB(255, 229, 244, 251));

    // Datenzeile hinzufügen
    rows.add(TableRow(
      decoration: rowDecoration,
      children: [
        ConstrainedBox(
          constraints: constraints,
          child: InkWell(
            onTap: () {},
            child: const Icon(Icons.delete, color: Colors.red),
          ),
        ),
        Padding(padding: padding, child: Text(bookingProduct.articleNumber)),
        Padding(padding: padding, child: Text(bookingProduct.name)),
        Padding(padding: padding, child: Text(bookingProduct.ean)),
        Padding(padding: padding, child: const Text('')),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(padding: padding, child: MyTextFormFieldSmallDouble(hintText: bookingProduct.openQuantity.toString())),
        ),
        Padding(padding: padding, child: Text(bookingProduct.reorderId)),
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
