import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/repositories/database/product_repository.dart';
import '../../../constants.dart';
import '../../../routes/router.gr.dart';
import '../core.dart';

void showMyPartOfSetProductQuickView({required BuildContext context, required String productId}) async {
  showMyDialogLoading(context: context, text: 'Artikel werden geladen...', canPop: true);

  Product? mainProduct;
  List<Product>? listOfSetProducts;

  final productRepository = GetIt.I.get<ProductRepository>();

  final fosMainProduct = await productRepository.getProduct(productId);
  if (fosMainProduct.isLeft()) {
    if (!context.mounted) return;
    _onError(context);
    return;
  }
  mainProduct = fosMainProduct.getRight();

  final fosListOfProducts = await productRepository.getListOfProductsByIds(mainProduct.listOfIsPartOfSetIds);
  if (fosListOfProducts.isLeft()) {
    if (!context.mounted) return;
    _onError(context);
    return;
  }
  listOfSetProducts = fosListOfProducts.getRight();

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
              : _PartOfSetProductQuickView(mainProduct: mainProduct, listOfSetProducts: listOfSetProducts!),
        ),
      ];
    },
  );
}

class _PartOfSetProductQuickView extends StatelessWidget {
  final Product mainProduct;
  final List<Product> listOfSetProducts;

  const _PartOfSetProductQuickView({required this.mainProduct, required this.listOfSetProducts});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: listOfSetProducts.length,
        itemBuilder: (context, index) {
          final product = listOfSetProducts[index];

          return _ProductItem(mainProduct: mainProduct, setProduct: product);
        },
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final Product mainProduct;
  final Product setProduct;

  const _ProductItem({required this.mainProduct, required this.setProduct});

  @override
  Widget build(BuildContext context) {
    int? quantity;
    final phPartQuantity = setProduct.listOfProductIdWithQuantity.where((e) => e.productId == mainProduct.id).firstOrNull;
    if (phPartQuantity != null) quantity = phPartQuantity.quantity;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              _ProductPicture(product: setProduct),
              Gaps.w8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(setProduct.name, style: TextStyles.defaultBold),
                    Text(setProduct.articleNumber),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            if (quantity != null) SizedBox(width: 20, child: Text(quantity.toString(), style: TextStyles.h3BoldPrimary)),
            SizedBox(
              width: 20,
              child: Column(
                children: [
                  Text(setProduct.warehouseStock.toString(),
                      style: setProduct.warehouseStock == 0 ? TextStyles.defaultBold.copyWith(color: Colors.red) : null),
                  Text(setProduct.availableStock.toString(),
                      style: setProduct.availableStock == 0 ? TextStyles.defaultBold.copyWith(color: Colors.red) : null),
                ],
              ),
            ),
          ],
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
