import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../3_domain/entities/product/product.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

Widget getProductsAppBarTitle(BuildContext context, List<Product>? listOfFilteredProducts, List<Product> selectedProducts) {
  if (listOfFilteredProducts == null) return const Text('Artikel');
  final isTabletOrLarger = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);

  final mainTitle = Text.rich(TextSpan(children: [
    const TextSpan(text: 'Artikel'),
    const TextSpan(text: ' '),
    TextSpan(text: '(${listOfFilteredProducts.length})', style: TextStyles.h3),
  ]));

  final row = Row(
    children: [
      mainTitle,
      Gaps.w8,
      InkWell(
        onTap: () => showMyDialogProducts(context: context, productsList: selectedProducts),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text.rich(TextSpan(children: [
            if (isTabletOrLarger) const TextSpan(text: 'Ausgewählte Artikel'),
            const TextSpan(text: ' '),
            TextSpan(text: '(${selectedProducts.length})', style: TextStyles.h3),
          ])),
        ),
      ),
    ],
  );

  return switch (selectedProducts.length) {
    0 => mainTitle,
    _ => row,
  };
}
