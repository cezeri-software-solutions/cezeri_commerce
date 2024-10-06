import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class ProductProfitText extends StatelessWidget {
  final double netPrice;
  final double wholesalePrice;

  const ProductProfitText({super.key, required this.netPrice, required this.wholesalePrice});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '${(netPrice - wholesalePrice).toMyCurrencyStringToShow()} €',
            style: TextStyles.defaultBold.copyWith(color: Colors.green),
          ),
          const TextSpan(text: ' | ', style: TextStyles.defaultBold),
          if (netPrice > 0)
            TextSpan(
              text: '${((1 - (wholesalePrice / netPrice)) * 100).toMyCurrencyStringToShow()} %',
              style: TextStyles.defaultBold.copyWith(color: CustomColors.primaryColor),
            ),
        ],
      ),
    );
  }
}
