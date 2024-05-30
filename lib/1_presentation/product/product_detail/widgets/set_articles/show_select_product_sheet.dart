import 'package:flutter/material.dart';

import '../../../../../2_application/database/product_detail/product_detail_bloc.dart';
import 'product_detail_select_parts_of_set_article.dart';

void showSelectProductSheet(BuildContext context, ProductDetailBloc productDetailBloc) {
  // WoltModalSheet.show(
  //   context: context,
  //   pageListBuilder: (context) {
  //     return [
  //       WoltModalSheetPage(child: ProductDetailSelectPartsOfSetArticle(productDetailBloc: productDetailBloc)),
  //     ];
  //   },
  // );
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final screenWidth = MediaQuery.sizeOf(context).width;
      return Dialog(
        child: SizedBox(
          width: screenWidth > 700 ? 1000 : screenWidth,
          child: ProductDetailSelectPartsOfSetArticle(productDetailBloc: productDetailBloc),
        ),
      );
    },
  );
}
