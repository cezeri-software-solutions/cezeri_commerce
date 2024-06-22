import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/marketplace/product_export/bloc/product_export_bloc.dart';
import '../../../../3_domain/entities/product/product.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

class ProductExportOverviewSheet extends StatelessWidget {
  final ProductExportBloc productExportBloc;

  const ProductExportOverviewSheet({super.key, required this.productExportBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductExportBloc, ProductExportState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  state.isLoadingOnExportProducts ? const MyCircularProgressIndicator() : const Icon(Icons.check_circle, color: Colors.green),
                  Gaps.w16,
                  Text(
                    state.isLoadingOnExportProducts
                        ? '${state.exportCounter} von ${state.selectedProducts.length} abgeschlossen'
                        : 'Export abgeschlossen',
                  ),
                ],
              ),
            ),
            if (state.listOfErrorProducts.isNotEmpty)
              _SucceededOrErrorProducts(title: 'Export fehlgeschlagen:', listOfProducts: state.listOfErrorProducts),
            if (state.listOfErrorImageProducts.isNotEmpty)
              _SucceededOrErrorProducts(title: 'Probleme mit Artikelbilder:', listOfProducts: state.listOfErrorImageProducts),
            if (state.listOfErrorCategoryProducts.isNotEmpty)
              _SucceededOrErrorProducts(title: 'Probleme mit Kategorien:', listOfProducts: state.listOfErrorCategoryProducts),
            if (state.listOfErrorStockProducts.isNotEmpty)
              _SucceededOrErrorProducts(title: 'Probleme mit Bestand:', listOfProducts: state.listOfErrorStockProducts),
            if (state.listOfErrorMarketplaceProducts.isNotEmpty)
              _SucceededOrErrorProducts(
                title: 'Exportierter Artikel konnte dem Cezeri Commerce Artikel nicht hinzugefügt werden:',
                listOfProducts: state.listOfErrorMarketplaceProducts,
              ),
            _SucceededOrErrorProducts(title: 'Erfolgreich exportiert:', listOfProducts: state.listOfSuccessfulProducts),
          ],
        );
      },
    );
  }
}

class _SucceededOrErrorProducts extends StatelessWidget {
  final String title;
  final List<Product> listOfProducts;

  const _SucceededOrErrorProducts({super.key, required this.title, required this.listOfProducts});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(title, style: TextStyles.h3Bold),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: listOfProducts.length,
          itemBuilder: (context, index) {
            final product = listOfProducts[index];
            return Column(
              children: [
                ListTile(
                  leading: SizedBox(
                    width: 40,
                    height: 40,
                    child: MyAvatar(
                        name: product.name,
                        imageUrl: product.listOfProductImages.isNotEmpty ? product.listOfProductImages.where((e) => e.isDefault).first.fileUrl : null,
                        fit: BoxFit.contain,
                        shape: BoxShape.rectangle),
                  ),
                  title: Text(product.name),
                  subtitle: Text(product.articleNumber),
                ),
                const Divider(),
              ],
            );
          },
        ),
      ],
    );
  }
}
