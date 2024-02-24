import 'package:cezeri_commerce/1_presentation/core/widgets/my_outlined_button.dart';
import 'package:cezeri_commerce/3_domain/entities/marketplace/marketplace_presta.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../2_application/firebase/main_settings/main_settings_bloc.dart';
import '../../../2_application/prestashop/product_import/product_import_bloc.dart';
import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/entities_presta/product_presta.dart';
import '../../../4_infrastructur/repositories/shopify_api/shopify.dart';
import '../../../constants.dart';
import '../../core/widgets/my_avatar.dart';

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
    final logger = Logger();

    return BlocBuilder<ProductImportBloc, ProductImportState>(
      builder: (context, state) {
        final mainSettings = context.read<MainSettingsBloc>().state.mainSettings!;
        print(state.marketplaceProduct);
        print(state.isLoadingProductPrestaOnObserve);
        print(state.isAnyFailure);

        void onImportProductPressed() {
          productImportBloc.add(LoadProductFromMarketplaceEvent(
            value: idController.text,
            marketplace: state.selectedMarketplace! as MarketplacePresta, //TODO: Shopify
          ));
        }

        if (state.prestaFailure != null && state.isAnyFailure) const Text('Ein Fehler ist aufgetreten');
        if (state.isLoadingProductPrestaOnObserve && !state.isAnyFailure) const CircularProgressIndicator();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.marketplaceProduct != null && !state.isLoadingProductPrestaOnObserve && !state.isAnyFailure) ...[
                if (state.marketplaceProduct.runtimeType == ProductPresta)
                  _MarketplaceProductPrestaRenderer(productImportBloc: productImportBloc, product: state.marketplaceProduct as ProductPresta),
                if (state.marketplaceProduct.runtimeType == ProductShopify)
                  _MarketplaceProductShopifyRenderer(productImportBloc: productImportBloc, product: state.marketplaceProduct as ProductShopify),
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
            onPressed: () => !state.isLoadingProductOnCreate ? productImportBloc.add(OnUploadProductToFirestoreEvent()) : null,
          ),
        );
      },
    );
  }
}

class _MarketplaceProductShopifyRenderer extends StatelessWidget {
  final ProductImportBloc productImportBloc;
  final ProductShopify product;

  const _MarketplaceProductShopifyRenderer({required this.productImportBloc, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductImportBloc, ProductImportState>(
      builder: (context, state) {
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
            onPressed: () => !state.isLoadingProductOnCreate ? productImportBloc.add(OnUploadProductToFirestoreEvent()) : null,
          ),
        );
      },
    );
  }
}
