import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/product_detail/product_detail_bloc.dart';
import '../../../../3_domain/entities/product/product.dart';
import '../../../../constants.dart';
import '../../../../routes/router.gr.dart';
import '../../../core/core.dart';
import '../functions/has_set_articles_mismatch.dart';
import 'set_articles/show_select_product_sheet.dart';

class ProductDetailSetArticleBar extends StatelessWidget {
  final ProductDetailBloc productDetailBloc;

  const ProductDetailSetArticleBar({super.key, required this.productDetailBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      bloc: productDetailBloc,
      builder: (context, state) {
        if (state.product == null) return const MyCircularProgressIndicator();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(thickness: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Set-Artikel', style: TextStyles.h2Bold),
                Row(
                  children: [
                    if (state.product!.isSetArticle) ...[
                      IconButton(
                        onPressed: () {
                          if (state.listOfAllProducts != null) {
                            showSelectProductSheet(context, productDetailBloc);
                          } else {
                            productDetailBloc.add(GetListOfProductsEvent());
                            showMyDialogLoading(context: context, text: 'Artikel werden geladen...');
                          }
                        },
                        icon: const Icon(Icons.edit, color: Colors.blue),
                      ),
                      Gaps.w16,
                    ],
                    Switch.adaptive(value: state.product!.isSetArticle, onChanged: (value) => _setIsSetArticle(context, state.product!, value)),
                  ],
                ),
              ],
            ),
            if (state.product!.isSetArticle || state.product!.listOfProductIdWithQuantity.isNotEmpty)
              hasSetArticlesMismatch(state.product!.listOfProductIdWithQuantity, state.listOfAllProducts ?? state.listOfSetPartProducts)
                  ? const MyCircularProgressIndicator()
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.product!.listOfProductIdWithQuantity.length,
                      itemBuilder: (context, index) {
                        final product = (state.listOfAllProducts ?? state.listOfSetPartProducts)!
                            .where((e) => e.id == state.product!.listOfProductIdWithQuantity[index].productId)
                            .first;
                        final productIdWithQuantity = state.product!.listOfProductIdWithQuantity[index];
                        return Column(
                          children: [
                            if (index == 0) const Divider(color: CustomColors.backgroundLightGrey, height: 0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            left: BorderSide(color: CustomColors.backgroundLightGrey),
                                            right: BorderSide(color: CustomColors.backgroundLightGrey),
                                          ),
                                        ),
                                        child: MyAvatar(
                                          name: product.name,
                                          radius: 30,
                                          imageUrl: product.listOfProductImages.isNotEmpty
                                              ? product.listOfProductImages.where((e) => e.isDefault).first.fileUrl
                                              : null,
                                          shape: BoxShape.rectangle,
                                          fit: BoxFit.scaleDown,
                                          onTap: product.listOfProductImages.isNotEmpty
                                              ? () => context.router.push(MyFullscreenImageRoute(
                                                  imagePaths: product.listOfProductImages.map((e) => e.fileUrl).toList(),
                                                  initialIndex: 0,
                                                  isNetworkImage: true))
                                              : null,
                                        ),
                                      ),
                                      Gaps.w8,
                                      Expanded(child: Text(product.name, overflow: TextOverflow.ellipsis)),
                                    ],
                                  ),
                                ),
                                Gaps.w16,
                                Text(
                                  '${productIdWithQuantity.quantity} x',
                                  style: TextStyles.defaultBold.copyWith(color: CustomColors.primaryColor),
                                )
                              ],
                            ),
                            const Divider(color: CustomColors.backgroundLightGrey, height: 0),
                          ],
                        );
                      },
                    ),
          ],
        );
      },
    );
  }

  void _setIsSetArticle(BuildContext context, Product product, bool value) {
    if (product.haveVariants && value) {
      showMyDialogAlert(context: context, title: 'Achtung', content: 'Ein Artikel kann kein Variantenartikel und Set-Artikel zugleich sein');
      return;
    }

    productDetailBloc.add(OnProductSetIsSetArticleEvent());
  }
}
