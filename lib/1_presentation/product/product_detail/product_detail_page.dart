import 'package:cezeri_commerce/1_presentation/core/widgets/my_avatar.dart';
import 'package:cezeri_commerce/1_presentation/core/widgets/my_outlined_button.dart';
import 'package:cezeri_commerce/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/product/product_bloc.dart';
import '../../../3_domain/entities/product/marketplace_product_presta.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/product/product_image.dart';
import '../../../3_domain/enums/enums.dart';
import 'product_detail_screen.dart';
import 'widgets/edit_product_marketplace.dart';
import 'widgets/product_detail_widgets.dart';

class ProductDetailPage extends StatelessWidget {
  final Product? product;
  final ProductBloc productBloc;
  final ProductCreateOrEdit productCreateOrEdit;

  const ProductDetailPage({super.key, this.product, required this.productBloc, required this.productCreateOrEdit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      bloc: productBloc,
      builder: (context, state) {
        final screenWidth = MediaQuery.sizeOf(context).width;
        final responsiveness = screenWidth > 700 ? Responsiveness.isTablet : Responsiveness.isMobil;

        final appBar = AppBar(
          title: const Text('Artikel'),
          centerTitle: responsiveness == Responsiveness.isTablet ? true : false,
          actions: [
            if (product != null)
              IconButton(
                onPressed: () => productBloc.add(GetProductEvent(id: product!.id)),
                icon: const Icon(Icons.refresh, size: 30),
              ),
            responsiveness == Responsiveness.isTablet ? Gaps.w32 : Gaps.w8,
            MyOutlinedButton(
              buttonText: 'Speichern',
              onPressed: () {
                if (product != null) {
                  productBloc.add(UpdateProductEvent());
                } else {
                  // TODO: Handle create new product
                }
              },
              isLoading: state.isLoadingProductOnUpdate,
              buttonBackgroundColor: Colors.green,
            ),
            responsiveness == Responsiveness.isTablet ? Gaps.w32 : Gaps.w8,
          ],
        );

        return Scaffold(
          appBar: appBar,
          body: SafeArea(
            child: responsiveness == Responsiveness.isTablet
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ProductMasterCard(productBloc: productBloc),
                                    Gaps.h16,
                                    PurchaseCard(productBloc: productBloc),
                                  ],
                                ),
                              ),
                              Gaps.w16,
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    SellingCard(productBloc: productBloc),
                                    Gaps.h16,
                                    WeightAndDimensionsCard(productBloc: productBloc),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Bilder', style: TextStyles.h2Bold),
                              MyOutlinedButton(
                                buttonText: 'Hochladen',
                                onPressed: () {},
                              ),
                            ],
                          ),
                          ReorderableListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.listOfProductImages.length,
                            itemBuilder: (context, index) {
                              List<ProductImage> images = List.from(state.listOfProductImages);
                              images.sort((a, b) => a.sortId.compareTo(b.sortId));
                              final image = images[index];
                              return ListTile(
                                key: ValueKey(image),
                                leading: SizedBox(
                                  width: 60,
                                  child: MyAvatar(name: image.fileName, imageUrl: image.fileUrl, shape: BoxShape.rectangle),
                                ),
                                title: Text(image.fileName, style: image.isDefault ? TextStyles.defaultBold : TextStyles.defaultt),
                              );
                            },
                            onReorder: (oldIndex, newIndex) => productBloc.add(OnReorderProductImagesEvent(oldIndex: oldIndex, newIndex: newIndex)),
                          ),
                          ProductDetailMarketplaces(productBloc: productBloc),
                          Gaps.h16,
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        ProductMasterCard(productBloc: productBloc),
                        Gaps.h16,
                        PurchaseCard(productBloc: productBloc),
                        Gaps.h16,
                        SellingCard(productBloc: productBloc),
                        Gaps.h16,
                        WeightAndDimensionsCard(productBloc: productBloc),
                        Gaps.h16,
                        ProductDetailMarketplaces(productBloc: productBloc),
                        Gaps.h16,
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class ProductDetailMarketplaces extends StatelessWidget {
  final ProductBloc productBloc;

  const ProductDetailMarketplaces({super.key, required this.productBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      bloc: productBloc,
      builder: (context, state) {
        return Column(
          children: [
            const Divider(),
            const Text(
              'Marktplätze',
              style: TextStyles.h2,
            ),
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
                        onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => BlocProvider.value(
                            value: productBloc,
                            child: EditProductMarketplace(productMarketplace: pm),
                          ),
                        ),
                        child: SizedBox(
                          height: 110,
                          width: 200,
                          child: Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
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
