import 'package:cezeri_commerce/2_application/firebase/product/product_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../2_application/firebase/main_settings/main_settings_bloc.dart';
import '../../../2_application/prestashop/product_import/product_import_bloc.dart';
import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../3_domain/entities/product/marketplace_product_presta.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../constants.dart';
import '../../core/widgets/my_avatar.dart';
import '../../core/widgets/my_outlined_button.dart';

class ProductImportPage extends StatelessWidget {
  final ProductImportBloc productImportBloc;
  final Marketplace marketplace;
  final void Function(int id) importProductById;
  final void Function(int id) importProductByIdAsJson;

  const ProductImportPage({
    super.key,
    required this.productImportBloc,
    required this.marketplace,
    required this.importProductById,
    required this.importProductByIdAsJson,
  });

  @override
  Widget build(BuildContext context) {
    final idController = TextEditingController();
    final logger = Logger();

    return BlocBuilder<ProductImportBloc, ProductImportState>(
      builder: (context, state) {
        final mainSettings = context.read<MainSettingsBloc>().state.mainSettings!;
        print(state.productPresta);
        print(state.isLoadingProductPrestaOnObserve);
        print(state.isAnyFailure);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.prestaFailure != null && state.isAnyFailure) const Text('Ein Fehler ist aufgetreten'),
              if (state.isLoadingProductPrestaOnObserve && !state.isAnyFailure) const CircularProgressIndicator(),
              if (state.productPresta != null && !state.isLoadingProductPrestaOnObserve && !state.isAnyFailure) ...[
                ListTile(
                  leading: Text(state.productPresta!.id.toString()),
                  title: Text(
                    state.productPresta!.name!,
                  ),
                  subtitle: Text(state.productPresta!.quantity.toString()),
                  trailing: TextButton(
                    onPressed: () {
                      final product = Product.fromProductPresta(
                        productPresta: state.productPresta!,
                        marketplace: marketplace,
                        mainSettings: mainSettings,
                      );
                      context.read<ProductBloc>().add(CreateProductEvent(product: product, productPresta: state.productPresta));
                    },
                    child: const Text('Speichern'),
                  ),
                ),
                MyOutlinedButton(
                    buttonText: 'Product.toJson',
                    onPressed: () {
                      final product = Product.fromProductPresta(
                        productPresta: state.productPresta!,
                        marketplace: marketplace,
                        mainSettings: mainSettings,
                      );
                      final marketplaceProductPresta = product.productMarketplaces.first.marketplaceProduct as MarketplaceProductPresta;
                    }),
                TextButton(onPressed: () => importProductById(2), child: const Text('Try Again')),
                Text('id: ------- ${state.productPresta!.id} --- ${state.productPresta!.id.runtimeType}'),
                Text('idManufacturer: ------- ${state.productPresta!.idManufacturer}'),
                Text('idSupplier: ------- ${state.productPresta!.idSupplier}'),
                Text('idCategoryDefault: ------- ${state.productPresta!.idCategoryDefault}'),
                // Text('isNew: ------- ${state.productPresta!.isNew}'),
                Text('cacheDefaultAttribute: ------- ${state.productPresta!.cacheDefaultAttribute}'),
                Text('idDefaultImage: ------- ${state.productPresta!.idDefaultImage}'),
                Text('idDefaultCombination: ------- ${state.productPresta!.idDefaultCombination}'),
                Text('idTaxRulesGroup: ------- ${state.productPresta!.idTaxRulesGroup}'),
                Text('positionInCategory: ------- ${state.productPresta!.positionInCategory}'),
                Text('manufacturerName: ------- ${state.productPresta!.manufacturerName}'),
                Text('quantity: ------- ${state.productPresta!.quantity}'),
                Text('type: ------- ${state.productPresta!.type}'),
                Text('idShopDefault: ------- ${state.productPresta!.idShopDefault}'),
                Text('reference: ------- ${state.productPresta!.reference}'),
                Text('supplierReference: ------- ${state.productPresta!.supplierReference}'),
                Text('location: ------- ${state.productPresta!.location} --- ${state.productPresta!.location.runtimeType}'),
                Text('width: ------- ${state.productPresta!.width}'),
                Text('height: ------- ${state.productPresta!.height}'),
                Text('depth: ------- ${state.productPresta!.depth}'),
                Text('weight: ------- ${state.productPresta!.weight}'),
                Text('quantityDiscount: ------- ${state.productPresta!.quantityDiscount}'),
                Text('ean13: ------- ${state.productPresta!.ean13}'),
                Text('isbn: ------- ${state.productPresta!.isbn}'),
                Text('upc: ------- ${state.productPresta!.upc}'),
                Text('mpn: ------- ${state.productPresta!.mpn}'),
                Text('cacheIsPack: ------- ${state.productPresta!.cacheIsPack}'),
                Text('cacheHasAttachments: ------- ${state.productPresta!.cacheHasAttachments}'),
                Text('isVirtual: ------- ${state.productPresta!.isVirtual}'),
                Text('state: ------- ${state.productPresta!.state}'),
                Text('additionalDeliveryTimes: ------- ${state.productPresta!.additionalDeliveryTimes}'),
                Text('deliveryInStock: ------- ${state.productPresta!.deliveryInStock}'),
                Text('deliveryOutStock: ------- ${state.productPresta!.deliveryOutStock}'),
                Text('onSale: ------- ${state.productPresta!.onSale}'),
                Text('onlineOnly: ------- ${state.productPresta!.onlineOnly}'),
                Text('ecotax: ------- ${state.productPresta!.ecotax}'),
                Text('minimalQuantity: ------- ${state.productPresta!.minimalQuantity}'),
                Text('lowStockThreshold: ------- ${state.productPresta!.lowStockThreshold}'),
                Text('lowStockAlert: ------- ${state.productPresta!.lowStockAlert}'),
                Text('price: ------- ${state.productPresta!.price}'),
                Text('wholesalePrice: ------- ${state.productPresta!.wholesalePrice}'),
                Text(
                  'unity: ------- ${state.productPresta!.unity}',
                  style: const TextStyle(color: Colors.red),
                ),
                Text('unitPriceRatio: ------- ${state.productPresta!.unitPriceRatio}'), // netPrice / unitPrice
                Text('additionalShippingCost: ------- ${state.productPresta!.additionalShippingCost}'),
                Text('customizable: ------- ${state.productPresta!.customizable}'),
                Text('textFields: ------- ${state.productPresta!.textFields}'),
                Text('uploadableFiles: ------- ${state.productPresta!.uploadableFiles}'),
                Text('active: ------- ${state.productPresta!.active}'),
                Text('redirectType: ------- ${state.productPresta!.redirectType}'),
                Text('idTypeRedirected: ------- ${state.productPresta!.idTypeRedirected}'),
                Text('availableForOrder: ------- ${state.productPresta!.availableForOrder}'),
                Text('availableDate: ------- ${state.productPresta!.availableDate}'),
                Text('showCondition: ------- ${state.productPresta!.showCondition}'),
                Text('condition: ------- ${state.productPresta!.condition}'),
                Text('showPrice: ------- ${state.productPresta!.showPrice}'),
                Text('indexed: ------- ${state.productPresta!.indexed}'),
                Text('visibility: ------- ${state.productPresta!.visibility}'),
                Text('advancedStockManagement: ------- ${state.productPresta!.advancedStockManagement}'),
                Text('dateAdd: ------- ${state.productPresta!.dateAdd}'),
                Text('dateUpd: ------- ${state.productPresta!.dateUpd}'),
                Text('packStockType: ------- ${state.productPresta!.packStockType}'),
                Text('metaDescription: ------- ${state.productPresta!.metaDescription}'),
                Text('metaKeywords: ------- ${state.productPresta!.metaKeywords}'),
                Text('metaTitle: ------- ${state.productPresta!.metaTitle}'),
                Text('linkRewrite: ------- ${state.productPresta!.linkRewrite}'),
                Text('name: ------- ${state.productPresta!.name}'),
                Text('name: ------- ${state.productPresta!.nameMultilanguage}'),
                // Text('listOfName: ------- ${state.productPresta!.listOfName}'),
                Text('description: ------- ${state.productPresta!.description}'),
                Text('descriptionShort: ------- ${state.productPresta!.descriptionShort}'),
                Text('availableNow: ------- ${state.productPresta!.availableNow}'),
                Text('availableLater: ------- ${state.productPresta!.availableLater}'),
                // Text('categoryIds original: ------- ${state.productPresta!.categoryIds}'),
                // Text('imageIds original: ------- ${state.productPresta!.imageIds}'),
                // Text('categoryIds original: ------- ${state.productPresta!.categories}'),
                // Text('images original: ------- ${state.productPresta!.images}'),
                // Text('categoryIds original: ------- ${state.productPresta!.combinations}'),
                // Text('categoryIds original: ------- ${state.productPresta!.productOptionValues}'),
                // Text('categoryIds original: ------- ${state.productPresta!.productFeatures}'),
                // Text('categoryIds original: ------- ${state.productPresta!.tags}'),
                // Text('categoryIds original: ------- ${state.productPresta!.stockAvailables}'),
                // Text('categoryIds original: ------- ${state.productPresta!.accessories}'),
                // Text('categoryIds original: ------- ${state.productPresta!.productBundle}'),
                MyAvatar(name: 'name', file: state.productPresta!.imageFiles!.first.imageFile),
              ],
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Gaps.h16,
                  const Text('Gib die ID des Artikels ein, welches importiert werden soll.', style: TextStyles.h3),
                  Gaps.h16,
                  SizedBox(
                      width: 100,
                      child: CupertinoTextField(
                        controller: idController,
                        keyboardType: TextInputType.number,
                        onSubmitted: (value) => importProductById(int.parse(idController.text)),
                      )),
                  Gaps.h16,
                  OutlinedButton(
                    onPressed: () => importProductById(int.parse(idController.text)),
                    child: const Text('Import Als Starten'),
                  ),
                  Gaps.h16,
                  OutlinedButton(
                    onPressed: () => importProductByIdAsJson(int.parse(idController.text)),
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
