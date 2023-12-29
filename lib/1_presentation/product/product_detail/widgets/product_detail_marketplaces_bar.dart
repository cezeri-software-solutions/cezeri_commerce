import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/firebase/product_detail/product_detail_bloc.dart';
import '../../../../3_domain/entities/product/marketplace_product_presta.dart';
import '../../../../constants.dart';
import 'product_marketplace/edit_product_marketplace.dart';

class ProductDetailMarketplacesBar extends StatelessWidget {
  final ProductDetailBloc productDetailBloc;

  const ProductDetailMarketplacesBar({super.key, required this.productDetailBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      bloc: productDetailBloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const Text('Marktplätze', style: TextStyles.h2Bold),
            Gaps.h8,
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: state.product!.productMarketplaces.length,
                itemBuilder: (context, index) {
                  final pm = state.product!.productMarketplaces[index];
                  final marketplaceProduct = pm.marketplaceProduct as MarketplaceProductPresta;
                  return Row(
                    children: [
                      InkWell(
                        onTap: () => showEditProductInMarketplace(context, productDetailBloc, pm),

                        // showModalBottomSheet(
                        //   context: context,
                        //   isScrollControlled: true,
                        //   builder: (_) => BlocProvider.value(
                        //     value: productDetailBloc,
                        //     child: EditProductMarketplace(productMarketplace: pm),
                        //   ),
                        // ),
                        child: SizedBox(
                          height: 110,
                          width: 200,
                          child: Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(pm.nameMarketplace, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                                ),
                                Container(
                                  height: 5.0,
                                  decoration: BoxDecoration(
                                    color: marketplaceProduct.active == '1' ? Colors.green : Colors.grey,
                                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Gaps.w16,
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
