import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/home/home_product/home_product_bloc.dart';
import '../../../../routes/router.gr.dart';
import '../../../core/core.dart';

class HomeProductsStockFailuresExpanded extends StatelessWidget {
  final HomeProductBloc homeProductBloc;

  const HomeProductsStockFailuresExpanded({super.key, required this.homeProductBloc});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final expandedHeight = screenHeight / 3;

    return BlocBuilder<HomeProductBloc, HomeProductState>(
      builder: (context, state) {
        if (state.isLoadingHomeProductsOnObserve) {
          return MyAnimatedExpansionContainer(
              isExpanded: state.isExpandedProductsStockDiff,
              child: SizedBox(height: expandedHeight, child: const Center(child: MyCircularProgressIndicator())));
        } else if (state.firebaseFailure != null && state.isAnyFailure) {
          return MyAnimatedExpansionContainer(
              isExpanded: state.isExpandedProductsStockDiff,
              child: SizedBox(height: expandedHeight, child: const Center(child: Text('Beim Laden der Daten ist ein Fehler aufgetreten'))));
        } else if (state.listOfProductStockDifferences == null) {
          return MyAnimatedExpansionContainer(
              isExpanded: state.isExpandedProductsStockDiff,
              child: SizedBox(height: expandedHeight, child: const Center(child: MyCircularProgressIndicator())));
        }

        return MyAnimatedExpansionContainer(
          isExpanded: state.isExpandedProductsStockDiff,
          child: SizedBox(
            height: expandedHeight,
            child: state.listOfProductStockDifferences!.isEmpty
                ? const Center(child: Text('Keine Artikelabweichungen vorhanden!'))
                : ListView.builder(
                    itemCount: state.listOfProductStockDifferences!.length,
                    itemBuilder: (context, index) {
                      final productStockDiff = state.listOfProductStockDifferences![index];

                      return ListTile(
                        isThreeLine: true,
                        title: Text('${productStockDiff.articleNumber} | ${productStockDiff.name}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Lagerbestand: ${productStockDiff.warehouseStock} | Verfügbarer Bestand: ${productStockDiff.availableStock}'),
                            Text('Unterschied: ${productStockDiff.stockDifference} | Offen von Aufträgen: ${productStockDiff.salesQuantity ?? 0}'),
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () => context.router.push(ProductDetailRoute(productId: productStockDiff.id)),
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                        onLongPress: () => showMyProductQuickViewById(context: context, productId: productStockDiff.id, showStatProduct: true),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
