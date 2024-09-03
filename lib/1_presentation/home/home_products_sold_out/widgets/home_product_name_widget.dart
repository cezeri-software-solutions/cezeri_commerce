import 'package:cezeri_commerce/3_domain/entities/product/product.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../core/core.dart';

class HomeProductNameWidget extends StatelessWidget {
  final Product product;
  final int index;
  final int reorderedQuantity;

  const HomeProductNameWidget({super.key, required this.product, required this.index, required this.reorderedQuantity});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () => showMyProductQuickView(context: context, product: product, showStatProduct: true),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        color: index % 2 == 1 ? CustomColors.ultraLightBlue : Colors.white,
        child: Row(
          children: [
            Expanded(child: Text(product.name)),
            if (reorderedQuantity > 0) Text(reorderedQuantity.toString(), style: TextStyles.defaultBold.copyWith(color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
