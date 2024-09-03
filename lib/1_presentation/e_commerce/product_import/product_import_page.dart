import 'package:cezeri_commerce/3_domain/entities/marketplace/marketplace_presta.dart';
import 'package:cezeri_commerce/3_domain/entities/marketplace/marketplace_shopify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/marketplace/product_import/product_import_bloc.dart';
import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/entities/product/product_presta.dart';
import '../../../4_infrastructur/repositories/shopify_api/shopify.dart';
import '../../../constants.dart';
import '../../core/core.dart';

class ProductImportPage extends StatelessWidget {
  final ProductImportBloc productImportBloc;
  final AbstractMarketplace marketplace;

  const ProductImportPage({
    super.key,
    required this.productImportBloc,
    required this.marketplace,
  });

  @override
  Widget build(BuildContext context) {
    final idController = TextEditingController();

    return BlocBuilder<ProductImportBloc, ProductImportState>(
      builder: (context, state) {
        void onImportProductPressed() {
          productImportBloc.add(
            LoadProductFromMarketplaceEvent(
              value: idController.text,
              marketplace: switch (state.selectedMarketplace!.marketplaceType) {
                MarketplaceType.prestashop => state.selectedMarketplace! as MarketplacePresta,
                MarketplaceType.shopify => state.selectedMarketplace! as MarketplaceShopify,
                MarketplaceType.shop => throw Exception('Should not be selectable!'),
              },
            ),
          );
        }

        if (state.marketplaceFailure != null && state.isAnyFailure) const Text('Ein Fehler ist aufgetreten');
        if (state.isLoadingProductPrestaOnObserve) const CircularProgressIndicator();
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.marketplaceProducts != null && !state.isLoadingProductPrestaOnObserve && !state.isAnyFailure) ...[
                if (state.marketplaceProducts!.first.runtimeType == ProductPresta)
                  _MarketplaceProductPrestaRenderer(productImportBloc: productImportBloc, product: state.marketplaceProducts!.first as ProductPresta),
                if (state.marketplaceProducts!.first.runtimeType == ProductShopify)
                  _MarketplaceProductShopifyRenderer(
                      productImportBloc: productImportBloc, products: state.marketplaceProducts as List<ProductShopify>),
              ],
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gaps.h16,
                  const Text('Gib die ID des Artikels ein, welches importiert werden soll.', style: TextStyles.h3),
                  Gaps.h16,
                  SizedBox(
                      width: 100,
                      child: CupertinoTextField(
                        controller: idController,
                        keyboardType: TextInputType.number,
                        onSubmitted: (_) => onImportProductPressed(),
                      )),
                  Gaps.h16,
                  OutlinedButton(
                    onPressed: onImportProductPressed,
                    child: const Text('Import Neu Starten'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MarketplaceProductPrestaRenderer extends StatelessWidget {
  final ProductImportBloc productImportBloc;
  final ProductPresta product;

  const _MarketplaceProductPrestaRenderer({required this.productImportBloc, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductImportBloc, ProductImportState>(
      builder: (context, state) {
        if (state.isLoadingProductPrestaOnObserve) const CircularProgressIndicator();
        return ListTile(
          leading: MyAvatar(
            name: 'name',
            file: product.imageFiles != null && product.imageFiles!.isNotEmpty ? product.imageFiles!.first.imageFile : null,
          ),
          title: Text(product.name!),
          subtitle: Text('ID: ${product.id} / Artikelnummer: ${product.reference}'),
          trailing: MyOutlinedButton(
            buttonText: 'Artikel speichern',
            isLoading: state.isLoadingProductOnCreate,
            onPressed: () =>
                !state.isLoadingProductOnCreate ? productImportBloc.add(OnUploadProductToFirestoreEvent(marketplaceProduct: product)) : null,
          ),
        );
      },
    );
  }
}

class _MarketplaceProductShopifyRenderer extends StatelessWidget {
  final ProductImportBloc productImportBloc;
  final List<ProductShopify> products;

  const _MarketplaceProductShopifyRenderer({required this.productImportBloc, required this.products});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductImportBloc, ProductImportState>(
      builder: (context, state) {
        if (state.isLoadingProductPrestaOnObserve) const CircularProgressIndicator();
        return ListView.builder(
          shrinkWrap: true,
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
              leading: MyAvatar(
                name: 'name',
                imageUrl: product.images.isNotEmpty ? product.images.first.src : null,
              ),
              title: Text(product.title),
              subtitle: Text('ID: ${product.id} / Artikelnummer: ${product.variants.first.sku}'),
              trailing: MyOutlinedButton(
                buttonText: 'Artikel speichern',
                isLoading: state.isLoadingProductOnCreate,
                onPressed: () =>
                    !state.isLoadingProductOnCreate ? productImportBloc.add(OnUploadProductToFirestoreEvent(marketplaceProduct: product)) : null,
              ),
            );
          },
        );
      },
    );
  }
}
