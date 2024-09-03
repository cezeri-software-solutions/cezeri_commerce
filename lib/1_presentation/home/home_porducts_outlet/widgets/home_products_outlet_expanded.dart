import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/home/home_product/home_product_bloc.dart';
import '../../../core/core.dart';

class HomeProductsOutletExpanded extends StatelessWidget {
  final HomeProductBloc homeProductBloc;

  const HomeProductsOutletExpanded({super.key, required this.homeProductBloc});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final expandedHeight = screenHeight / 3;

    return BlocBuilder<HomeProductBloc, HomeProductState>(
      builder: (context, state) {
        if (state.isLoadingHomeProductsOnObserve) {
          return MyAnimatedExpansionContainer(
              isExpanded: state.isExpandedProductsOutlet,
              child: SizedBox(height: expandedHeight, child: const Center(child: MyCircularProgressIndicator())));
        } else if (state.firebaseFailure != null && state.isAnyFailure) {
          return MyAnimatedExpansionContainer(
              isExpanded: state.isExpandedProductsOutlet,
              child: SizedBox(height: expandedHeight, child: const Center(child: Text('Beim Laden der Daten ist ein Fehler aufgetreten'))));
        } else if (state.listOfProductsOutlet == null) {
          return MyAnimatedExpansionContainer(
              isExpanded: state.isExpandedProductsOutlet,
              child: SizedBox(height: expandedHeight, child: const Center(child: MyCircularProgressIndicator())));
        }

        return MyAnimatedExpansionContainer(
          isExpanded: state.isExpandedProductsOutlet,
          child: SizedBox(
            height: expandedHeight,
            child: state.listOfProductsOutlet!.isEmpty
                ? const Center(child: Text('Keine ausverkauften Auslaufartikel vorhanden!'))
                : ListView.builder(
                    itemCount: state.listOfProductsOutlet!.length,
                    itemBuilder: (context, index) {
                      final product = state.listOfProductsOutlet![index];

                      return ListTile(
                        title: Text(product.name),
                        trailing: IconButton(
                          onPressed: () => context.router.push(ProductDetailRoute(productId: product.id)),
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
