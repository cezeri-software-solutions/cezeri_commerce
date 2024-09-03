import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../2_application/database/product_detail/product_detail_bloc.dart';
import '../../../../../constants.dart';
import '../../../../../routes/router.gr.dart';
import '../../../../core/core.dart';

class ProductDetailSelectPartsOfSetArticle extends StatelessWidget {
  final ProductDetailBloc productDetailBloc;

  const ProductDetailSelectPartsOfSetArticle({super.key, required this.productDetailBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      bloc: productDetailBloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18, left: 18, right: 18, bottom: 8),
              child: Row(
                children: [
                  const Text('Alle Artikel', style: TextStyles.h2Bold),
                  Gaps.w16,
                  Expanded(
                    child: CupertinoSearchTextField(
                      controller: state.partOfSetProductSearchController,
                      onChanged: (_) => productDetailBloc.add(OnPartOfSetProductControllerChangedEvent()),
                      onSuffixTap: () => productDetailBloc.add(OnPartOfSetProductControllerClearedEvent()),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.listOfFilteredProducts.length,
                itemBuilder: (context, index) {
                  final product = state.listOfFilteredProducts[index];
                  return ListTile(
                    leading: SizedBox(
                      width: 60,
                      child: MyAvatar(
                        name: product.name,
                        imageUrl: product.listOfProductImages.isNotEmpty ? product.listOfProductImages.where((e) => e.isDefault).first.fileUrl : null,
                        radius: 25,
                        fontSize: 18,
                        shape: BoxShape.circle,
                        fit: BoxFit.scaleDown,
                        onTap: product.listOfProductImages.isNotEmpty
                            ? () => context.router.push(MyFullscreenImageRoute(
                                imagePaths: product.listOfProductImages.map((e) => e.fileUrl).toList(), initialIndex: 0, isNetworkImage: true))
                            : null,
                      ),
                    ),
                    title: Text(product.name),
                    trailing: IconButton(
                      onPressed: () => productDetailBloc.add(OnAddProductToSetArticleEvent(product: product)),
                      icon: const Icon(Icons.add, color: Colors.green),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 18, left: 18, right: 18, bottom: 8),
              child: Text.rich(TextSpan(children: [
                const TextSpan(text: 'Einzelartikel Set:', style: TextStyles.h2Bold),
                const TextSpan(text: ' ', style: TextStyles.h2Bold),
                TextSpan(
                    text: state.product!.name,
                    style: TextStyles.defaultBold.copyWith(color: CustomColors.primaryColor, overflow: TextOverflow.ellipsis)),
              ])),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.product!.listOfProductIdWithQuantity.length,
                      itemBuilder: (context, index) {
                        final product =
                            state.listOfAllProducts!.where((e) => e.id == state.product!.listOfProductIdWithQuantity[index].productId).first;
                        final productIdWithQuantity = state.product!.listOfProductIdWithQuantity[index];
                        return ListTile(
                          leading: SizedBox(
                            width: 60,
                            child: MyAvatar(
                              name: product.name,
                              imageUrl:
                                  product.listOfProductImages.isNotEmpty ? product.listOfProductImages.where((e) => e.isDefault).first.fileUrl : null,
                              radius: 25,
                              fontSize: 18,
                              shape: BoxShape.circle,
                              fit: BoxFit.scaleDown,
                              onTap: product.listOfProductImages.isNotEmpty
                                  ? () => context.router.push(MyFullscreenImageRoute(
                                      imagePaths: product.listOfProductImages.map((e) => e.fileUrl).toList(), initialIndex: 0, isNetworkImage: true))
                                  : null,
                            ),
                          ),
                          title: Text(product.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (productIdWithQuantity.quantity == 1) {
                                    showMyDialogDelete(
                                      context: context,
                                      content: 'Willst du diesen Artikel wirklich aus dem Set entfernen?',
                                      onConfirm: () {
                                        productDetailBloc.add(OnSetArticleQuantityChangedEvent(
                                          productId: productIdWithQuantity.productId,
                                          isIncrease: false,
                                        ));
                                        context.router.pop();
                                      },
                                    );
                                    return;
                                  }
                                  productDetailBloc.add(OnSetArticleQuantityChangedEvent(
                                    productId: productIdWithQuantity.productId,
                                    isIncrease: false,
                                  ));
                                },
                                icon: const Icon(Icons.remove, color: CustomColors.primaryColor),
                              ),
                              Text(productIdWithQuantity.quantity.toString(), style: TextStyles.defaultBold),
                              IconButton(
                                onPressed: () => productDetailBloc.add(OnSetArticleQuantityChangedEvent(
                                  productId: productIdWithQuantity.productId,
                                  isIncrease: true,
                                )),
                                icon: const Icon(Icons.add, color: Colors.green),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: MyOutlinedButton(buttonText: 'Schließen', onPressed: () => context.router.pop()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
