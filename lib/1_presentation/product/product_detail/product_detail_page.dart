import 'package:cezeri_commerce/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../2_application/database/product_detail/product_detail_bloc.dart';
import 'product_detail_screen.dart';
import 'widgets/charts/product_chart_card.dart';
import 'widgets/product_detail_set_article_bar.dart';
import 'widgets/product_detail_widgets.dart';
import 'widgets/product_images_container.dart';
import 'widgets/product_marketplace/product_detail_marketplaces_bar.dart';
import 'widgets/product_properties_card.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductDetailBloc productDetailBloc;
  final ProductCreateOrEdit productCreateOrEdit;

  const ProductDetailPage({super.key, required this.productDetailBloc, required this.productCreateOrEdit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      bloc: productDetailBloc,
      builder: (context, state) {
        if (ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET)) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ProductMasterCard(productDetailBloc: productDetailBloc),
                            Gaps.h16,
                            PurchaseCard(productDetailBloc: productDetailBloc),
                            Gaps.h16,
                            if (productCreateOrEdit == ProductCreateOrEdit.edit) ProductChartCard(productDetailBloc: productDetailBloc),
                          ],
                        ),
                      ),
                      Gaps.w16,
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            SellingCard(productDetailBloc: productDetailBloc),
                            Gaps.h16,
                            WeightAndDimensionsCard(productDetailBloc: productDetailBloc),
                            Gaps.h16,
                            ProductPropertiesCard(productDetailBloc: productDetailBloc),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (productCreateOrEdit == ProductCreateOrEdit.edit) ...[
                    ProductImagesContainer(productDetailBloc: productDetailBloc),
                    ProductDetailSetArticleBar(productDetailBloc: productDetailBloc),
                    ProductDetailMarketplacesBar(productDetailBloc: productDetailBloc),
                    Gaps.h16,
                  ],
                ],
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                ProductMasterCard(productDetailBloc: productDetailBloc),
                Gaps.h16,
                PurchaseCard(productDetailBloc: productDetailBloc),
                Gaps.h16,
                SellingCard(productDetailBloc: productDetailBloc),
                Gaps.h16,
                WeightAndDimensionsCard(productDetailBloc: productDetailBloc),
                Gaps.h16,
                ProductPropertiesCard(productDetailBloc: productDetailBloc),
                Gaps.h16,
                ProductChartCard(productDetailBloc: productDetailBloc),
                Gaps.h16,
                ProductImagesContainer(productDetailBloc: productDetailBloc),
                Gaps.h16,
                ProductDetailSetArticleBar(productDetailBloc: productDetailBloc),
                Gaps.h16,
                ProductDetailMarketplacesBar(productDetailBloc: productDetailBloc),
                Gaps.h16,
              ],
            ),
          );
        }
      },
    );
  }
}
