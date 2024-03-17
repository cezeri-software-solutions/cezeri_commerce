import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

import '../../../../3_domain/entities/product/product.dart';
import '../../../../constants.dart';
import '../../../core/functions/dialogs.dart';

Widget getProductsAppBarTitle(BuildContext context, List<Product>? listOfFilteredProducts, List<Product> selectedProducts) {
    if (listOfFilteredProducts == null) return const Text('Artikel');
    final isTablet = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);

    final row = Row(
      children: switch (isTablet) {
        true => [
            Text('Artikel (${listOfFilteredProducts.length})'),
            Gaps.w8,
            InkWell(
              onTap: () => showMyDialogProducts(context: context, productsList: selectedProducts),
              child: Text('Ausgewählte Artikel (${selectedProducts.length})'),
            ),
          ],
        _ => [
            Text('Artikel (${listOfFilteredProducts.length})'),
            Gaps.w8,
            Tooltip(
              message: 'Ausgewählte Artikel',
              child: InkWell(
                onTap: () => showMyDialogProducts(context: context, productsList: selectedProducts),
                child: Text('(${selectedProducts.length})'),
              ),
            ),
          ],
      },
    );

    return switch (isTablet) {
      true => switch (selectedProducts.length) {
          0 => Text('Artikel (${listOfFilteredProducts.length})'),
          _ => row,
        },
      _ => switch (selectedProducts.length) {
          0 => Text('Artikel (${listOfFilteredProducts.length})'),
          _ => row,
        },
    };
  }