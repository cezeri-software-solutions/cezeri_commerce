import 'package:flutter/material.dart';

import '../../../../3_domain/entities/product/home_product.dart';
import '../../../../3_domain/entities/product/product.dart';
import '../../../../constants.dart';

class GroupedListOfSupplierByManufacturer extends StatelessWidget {
  final List<Product> listOfProducts;

  const GroupedListOfSupplierByManufacturer({super.key, required this.listOfProducts});

  @override
  Widget build(BuildContext context) {
    final dividerColor = Theme.of(context).dividerColor;

    List<HomeProduct> listOfHomeProducts = [];
    for (final product in listOfProducts) {
      final isManufacturerInList = listOfHomeProducts.any((e) => e.manufacturer == product.manufacturer);
      if (isManufacturerInList) {
        final index = listOfHomeProducts.indexWhere((e) => e.manufacturer == product.manufacturer);
        if (index == -1) continue;
        final products = listOfHomeProducts[index].listOfProducts..add(product);
        listOfHomeProducts[index] = listOfHomeProducts[index].copyWith(listOfProducts: products);
      } else {
        final newListOfHomeProduct = HomeProduct(supplier: '', manufacturer: product.manufacturer, listOfProducts: [product]);
        listOfHomeProducts.add(newListOfHomeProduct);
      }
    }

    List<Widget> listOfListViews = [];
    for (final homeProduct in listOfHomeProducts) {
      final listView = Column(
        children: [
          Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: CustomColors.ultraLightGrey,
                border: Border.symmetric(horizontal: BorderSide(color: dividerColor, width: 0.7)),
              ),
              child: Text(homeProduct.manufacturer, style: TextStyles.defaultBold)),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: homeProduct.listOfProducts.length,
            itemBuilder: (context, index) {
              final product = homeProduct.listOfProducts[index];

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                color: index % 2 == 1 ? CustomColors.ultraLightBlue : Colors.white,
                child: Text(product.name),
              );
            },
          ),
        ],
      );

      listOfListViews.add(listView);
    }

    return SingleChildScrollView(child: Column(children: listOfListViews));
  }
}
