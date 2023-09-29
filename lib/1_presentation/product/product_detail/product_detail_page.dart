import 'package:cezeri_commerce/1_presentation/core/extensions/string_to_double.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:cezeri_commerce/1_presentation/core/widgets/my_outlined_button.dart';
import 'package:cezeri_commerce/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/product/product_bloc.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/enums/enums.dart';
import 'product_detail_screen.dart';
import 'widgets/edit_product_marketplace.dart';
import 'widgets/product_detail_widgets.dart';

class ProductDetailPage extends StatefulWidget {
  final Product? product;
  final ProductBloc productBloc;
  final ProductCreateOrEdit productCreateOrEdit;

  const ProductDetailPage({super.key, this.product, required this.productBloc, required this.productCreateOrEdit});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late TextEditingController _articleNumberController = TextEditingController();
  late TextEditingController _eanController = TextEditingController();
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _wholesalePriceController = TextEditingController();
  late TextEditingController _supplierController = TextEditingController();
  late TextEditingController _supplierArticleNumberController = TextEditingController();
  late TextEditingController _manufacturerController = TextEditingController();
  late TextEditingController _netPriceController = TextEditingController();
  late TextEditingController _grossPriceController = TextEditingController();
  late TextEditingController _recommendedRetailPriceController = TextEditingController();
  late TextEditingController _unityController = TextEditingController();
  late TextEditingController _unitPriceController = TextEditingController();
  late TextEditingController _weightController = TextEditingController();
  late TextEditingController _widthController = TextEditingController();
  late TextEditingController _heightController = TextEditingController();
  late TextEditingController _depthController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      _articleNumberController = TextEditingController(text: widget.product!.articleNumber);
      _eanController = TextEditingController(text: widget.product!.ean);
      _nameController = TextEditingController(text: widget.product!.name);
      _wholesalePriceController = TextEditingController(text: widget.product!.wholesalePrice.toMyCurrency());
      _supplierController = TextEditingController(text: widget.product!.supplier);
      _supplierArticleNumberController = TextEditingController(text: widget.product!.supplierArticleNumber);
      _manufacturerController = TextEditingController(text: widget.product!.manufacturer);
      _netPriceController = TextEditingController(text: widget.product!.netPrice.toMyCurrency());
      _grossPriceController = TextEditingController(text: widget.product!.grossPrice.toMyCurrency());
      _recommendedRetailPriceController = TextEditingController(text: widget.product!.recommendedRetailPrice.toMyCurrency());
      _unityController = TextEditingController(text: widget.product!.unity);
      _unitPriceController = TextEditingController(text: widget.product!.unitPrice.toMyCurrency());
      _weightController = TextEditingController(text: widget.product!.weight.toMyCurrency());
      _widthController = TextEditingController(text: widget.product!.width.toMyCurrency());
      _heightController = TextEditingController(text: widget.product!.height.toMyCurrency());
      _depthController = TextEditingController(text: widget.product!.depth.toMyCurrency());
    } else {
      _articleNumberController = TextEditingController();
      _eanController = TextEditingController();
      _nameController = TextEditingController();
      _wholesalePriceController = TextEditingController();
      _supplierController = TextEditingController();
      _supplierArticleNumberController = TextEditingController();
      _manufacturerController = TextEditingController();
      _netPriceController = TextEditingController();
      _grossPriceController = TextEditingController();
      _recommendedRetailPriceController = TextEditingController();
      _unityController = TextEditingController();
      _unitPriceController = TextEditingController();
      _weightController = TextEditingController();
      _widthController = TextEditingController();
      _heightController = TextEditingController();
      _depthController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      bloc: widget.productBloc,
      builder: (context, state) {
        final screenWidth = MediaQuery.sizeOf(context).width;
        final responsiveness = screenWidth > 700 ? Responsiveness.isTablet : Responsiveness.isMobil;

        final appBar = AppBar(
          title: const Text('Artikel'),
          centerTitle: responsiveness == Responsiveness.isTablet ? true : false,
          actions: [
            if (widget.product != null)
              IconButton(
                onPressed: () => widget.productBloc.add(GetProductEvent(id: widget.product!.id)),
                icon: const Icon(Icons.refresh, size: 30),
              ),
            responsiveness == Responsiveness.isTablet ? Gaps.w32 : Gaps.w8,
            MyOutlinedButton(
              buttonText: 'Speichern',
              onPressed: () {
                if (widget.product != null) {
                  widget.productBloc.add(OnEditProductInPresta(product: _getProductOnEdit()));
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
                                    ProductMasterCard(
                                      articleNumberController: _articleNumberController,
                                      eanController: _eanController,
                                      nameController: _nameController,
                                    ),
                                    Gaps.h16,
                                    PurchaseCard(
                                      wholesalePriceController: _wholesalePriceController,
                                      supplierController: _supplierController,
                                      supplierArticleNumberController: _supplierArticleNumberController,
                                      manufacturerController: _manufacturerController,
                                    ),
                                  ],
                                ),
                              ),
                              Gaps.w16,
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    SellingCard(
                                      netPriceController: _netPriceController,
                                      grossPriceController: _grossPriceController,
                                      recommendedRetailPriceController: _recommendedRetailPriceController,
                                      unitPriceController: _unitPriceController,
                                      unityController: _unityController,
                                    ),
                                    Gaps.h16,
                                    WeightAndDimensionsCard(
                                      weightController: _weightController,
                                      widthController: _widthController,
                                      heightController: _heightController,
                                      depthController: _depthController,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Gaps.h16,
                          ProductDetailMarketplaces(widget: widget),
                          Gaps.h16,
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        ProductMasterCard(
                          articleNumberController: _articleNumberController,
                          eanController: _eanController,
                          nameController: _nameController,
                        ),
                        Gaps.h16,
                        PurchaseCard(
                          wholesalePriceController: _wholesalePriceController,
                          supplierController: _supplierController,
                          supplierArticleNumberController: _supplierArticleNumberController,
                          manufacturerController: _manufacturerController,
                        ),
                        Gaps.h16,
                        SellingCard(
                          netPriceController: _netPriceController,
                          grossPriceController: _grossPriceController,
                          recommendedRetailPriceController: _recommendedRetailPriceController,
                          unitPriceController: _unitPriceController,
                          unityController: _unityController,
                        ),
                        Gaps.h16,
                        WeightAndDimensionsCard(
                          weightController: _weightController,
                          widthController: _widthController,
                          heightController: _heightController,
                          depthController: _depthController,
                        ),
                        Gaps.h16,
                        ProductDetailMarketplaces(widget: widget),
                        Gaps.h16,
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  Product _getProductOnEdit() {
    final product = widget.product!.copyWith(
      articleNumber: _articleNumberController.text,
      ean: _eanController.text,
      name: _nameController.text,
      wholesalePrice: _wholesalePriceController.text.toDouble(),
      supplier: _supplierController.text,
      supplierArticleNumber: _supplierArticleNumberController.text,
      manufacturer: _manufacturerController.text,
      netPrice: _netPriceController.text.toDouble(),
      grossPrice: _grossPriceController.text.toDouble(),
      recommendedRetailPrice: _recommendedRetailPriceController.text.toDouble(),
      unity: _unityController.text,
      unitPrice: _unitPriceController.text.toDouble(),
      weight: _weightController.text.toDouble(),
      width: _widthController.text.toDouble(),
      height: _heightController.text.toDouble(),
      depth: _depthController.text.toDouble(),
    );
    return product;
  }
}

class ProductDetailMarketplaces extends StatelessWidget {
  const ProductDetailMarketplaces({
    super.key,
    required this.widget,
  });

  final ProductDetailPage widget;

  @override
  Widget build(BuildContext context) {
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
            itemCount: widget.product!.productMarketplaces.length,
            itemBuilder: (context, index) {
              final mp = widget.product!.productMarketplaces[index];
              return Row(
                children: [
                  InkWell(
                    onTap: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => BlocProvider.value(
                        value: widget.productBloc,
                        child: EditProductMarketplace(productMarketplace: mp),
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
                              child: Text(mp.nameMarketplace!, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                            ),
                            Container(
                              height: 5.0,
                              decoration: BoxDecoration(
                                color: mp.active! ? Colors.green : Colors.grey,
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
  }
}
