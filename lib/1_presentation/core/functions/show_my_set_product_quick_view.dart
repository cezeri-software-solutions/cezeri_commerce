import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/product/product_id_with_quantity.dart';
import '../../../3_domain/repositories/firebase/product_repository.dart';
import '../../../constants.dart';
import '../../../routes/router.gr.dart';
import '../core.dart';

void showMySetProductQuickView({required BuildContext context, required String productId}) async {
  showMyDialogLoading(context: context, text: 'Artikel werden geladen...', canPop: true);

  Product? mainProduct;
  List<Product>? listOfPartProducts;

  final productRepository = GetIt.I.get<ProductRepository>();

  final fosMainProduct = await productRepository.getProduct(productId);
  if (fosMainProduct.isLeft()) {
    if (!context.mounted) return;
    _onError(context);
    return;
  }
  mainProduct = fosMainProduct.getRight();

  final setPartIds = mainProduct.listOfProductIdWithQuantity.map((e) => e.productId).toList();
  final fosListOfProducts = await productRepository.getListOfProductsByIds(setPartIds);
  if (fosListOfProducts.isLeft()) {
    if (!context.mounted) return;
    _onError(context);
    return;
  }
  listOfPartProducts = fosListOfProducts.getRight();

  final leading = Padding(
    padding: const EdgeInsets.all(0),
    child: _ProductPicture(product: mainProduct),
  );

  final trailing = IconButton(
    padding: const EdgeInsets.only(right: 24),
    icon: const Icon(Icons.close),
    onPressed: () => context.router.maybePop(),
  );

  if (context.mounted) Navigator.of(context).pop();

  if (!context.mounted) return;
  WoltModalSheet.show(
    context: context,
    useSafeArea: false,
    pageListBuilder: (woltContext) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: true,
          isTopBarLayerAlwaysVisible: true,
          topBarTitle: Text(mainProduct != null ? mainProduct.name : 'Fehler', style: TextStyles.h3Bold),
          leadingNavBarWidget: leading,
          trailingNavBarWidget: trailing,
          child: mainProduct == null
              ? const Center(child: MyCircularProgressIndicator())
              : _SetProductQuickView(mainProduct: mainProduct, listOfPartProducts: listOfPartProducts!),
        ),
      ];
    },
  );
}

class _SetProductQuickView extends StatelessWidget {
  final Product mainProduct;
  final List<Product> listOfPartProducts;

  const _SetProductQuickView({required this.mainProduct, required this.listOfPartProducts});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: listOfPartProducts.length,
        itemBuilder: (context, index) {
          final product = listOfPartProducts[index];

          return _ProductItem(product: product, quantityWithIds: mainProduct.listOfProductIdWithQuantity);
        },
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final Product product;
  final List<ProductIdWithQuantity> quantityWithIds;

  const _ProductItem({required this.product, required this.quantityWithIds});

  @override
  Widget build(BuildContext context) {
    int? quantity;
    final phPartQuantity = quantityWithIds.where((e) => e.productId == product.id).firstOrNull;
    if (phPartQuantity != null) quantity = phPartQuantity.quantity;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              _ProductPicture(product: product),
              Gaps.w8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: quantity != null ? '${quantity}x' : '',
                            style: TextStyles.defaultBold.copyWith(color: CustomColors.primaryColor),
                          ),
                          const TextSpan(text: ' '),
                          TextSpan(text: product.name, style: TextStyles.defaultBold),
                        ],
                      ),
                    ),
                    Text(product.articleNumber),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 50,
          child: Column(
            children: [
              Text(product.warehouseStock.toString(), style: product.warehouseStock == 0 ? TextStyles.defaultBold.copyWith(color: Colors.red) : null),
              Text(product.availableStock.toString(), style: product.availableStock == 0 ? TextStyles.defaultBold.copyWith(color: Colors.red) : null),
            ],
          ),
        )
      ],
    );
  }
}

class _ProductPicture extends StatelessWidget {
  final Product product;

  const _ProductPicture({required this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET) ? 70 : 60,
      child: MyAvatar(
        name: product.name,
        imageUrl: product.listOfProductImages.isNotEmpty ? product.listOfProductImages.where((e) => e.isDefault).first.fileUrl : null,
        radius: ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET) ? 35 : 30,
        fontSize: ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET) ? 25 : 20,
        shape: BoxShape.circle,
        onTap: product.listOfProductImages.isNotEmpty
            ? () => context.router.push(
                MyFullscreenImageRoute(imagePaths: product.listOfProductImages.map((e) => e.fileUrl).toList(), initialIndex: 0, isNetworkImage: true))
            : null,
      ),
    );
  }
}

void _onError(BuildContext context) {
  showMyDialogAlert(context: context, title: 'Fehler', content: 'Beim Laden der Produkte ist ein Fehler aufgetreten');
}
