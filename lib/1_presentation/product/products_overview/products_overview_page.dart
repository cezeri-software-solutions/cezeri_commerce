import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:cezeri_commerce/1_presentation/core/widgets/my_outlined_button.dart';
import 'package:cezeri_commerce/constants.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/product/product_bloc.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/enums/enums.dart';
import '../../../routes/router.gr.dart';
import '../../core/widgets/my_avatar.dart';
import '../product_detail/product_detail_screen.dart';

class ProductOverviewPage extends StatelessWidget {
  final ProductBloc productBloc;

  const ProductOverviewPage({super.key, required this.productBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state.isLoadingProductsOnObserve) {
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }
        if (state.firebaseFailure != null && state.isAnyFailure) {
          return switch (state.firebaseFailure.runtimeType) {
            EmptyFailure => const Expanded(child: Center(child: Text('Du hast noch keine Artikel angelegt oder importiert!'))),
            (_) => const Expanded(child: Center(child: Text('Ein Fehler ist aufgetreten!'))),
          };
        }

        return Expanded(
          child: ListView.builder(
            itemCount: state.listOfFilteredProducts!.length,
            itemBuilder: (context, index) {
              final curProduct = state.listOfFilteredProducts![index];
              return Column(
                children: [
                  _ProductContainer(product: curProduct, index: index, productBloc: productBloc),
                  const Divider(),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _ProductContainer extends StatelessWidget {
  final Product product;
  final int index;
  final ProductBloc productBloc;

  const _ProductContainer({required this.product, required this.index, required this.productBloc});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final responsiveness = screenWidth > 700 ? Responsiveness.isTablet : Responsiveness.isMobil;
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                value: state.selectedProducts.any((e) => e.id == product.id),
                onChanged: (_) => productBloc.add(OnProductSelectedEvent(product: product)),
              ),
              MyAvatar(
                name: product.name,
                imageUrl: product.listOfProductImages.isNotEmpty ? product.listOfProductImages.where((e) => e.isDefault).first.fileUrl : null,
                radius: responsiveness == Responsiveness.isTablet ? 35 : 30,
                fontSize: responsiveness == Responsiveness.isTablet ? 25 : 20,
                onTap: product.listOfProductImages.isNotEmpty
                    ? () => context.router.push(MyFullscreenImageRoute(
                        imagePaths: product.listOfProductImages.map((e) => e.fileUrl).toList(), initialIndex: 0, isNetworkImage: true))
                    : null,
              ),
              responsiveness == Responsiveness.isTablet ? Gaps.w16 : Gaps.w8,
              Expanded(
                //width: screenWidth / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.articleNumber),
                    TextButton(
                      onPressed: () {
                        context.read<ProductBloc>().add(GetProductEvent(id: product.id));
                        context.router.push(ProductDetailRoute(productBloc: productBloc, productCreateOrEdit: ProductCreateOrEdit.edit));
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      child: Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                    Text('EAN: ${product.ean}'),
                  ],
                ),
              ),
              if (responsiveness == Responsiveness.isTablet) ...[
                Gaps.w16,
                SizedBox(
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('EK: ${product.wholesalePrice.toMyCurrencyStringToShow()}'),
                      Text('VK-Netto: ${product.netPrice.toMyCurrencyStringToShow()}'),
                      Text('VK-Brutto: ${product.grossPrice.toMyCurrencyStringToShow()}'),
                      Text((product.netPrice - product.wholesalePrice).toMyCurrencyStringToShow(), style: TextStyles.defaultBold.copyWith(color: Colors.green))
                    ],
                  ),
                ),
              ],
              responsiveness == Responsiveness.isTablet ? Gaps.w16 : Gaps.w8,
              Column(
                children: [
                  Text(product.warehouseStock.toString()),
                  TextButton(
                      onPressed: () => showDialog(
                            context: context,
                            builder: (_) => BlocProvider.value(value: productBloc, child: MyDialog(product: product)),
                          ),
                      child: Text(product.availableStock.toString())),
                ],
              ),
              if (responsiveness == Responsiveness.isTablet) ...[
                Gaps.w16,
                SizedBox(
                  height: 80,
                  width: 100,
                  child: ListView.builder(
                    itemCount: product.productMarketplaces.length,
                    itemBuilder: (context, index) {
                      final productMarketplace = product.productMarketplaces[index];
                      return Text(productMarketplace.shortNameMarketplace!);
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

enum QuantityUpdateWay { edit, set }

class MyDialog extends StatefulWidget {
  final Product product;

  const MyDialog({super.key, required this.product});

  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  QuantityUpdateWay _quantityUpdateWay = QuantityUpdateWay.edit;
  int quantity = 0;
  int editedQuantity = 0;

  @override
  void initState() {
    super.initState();
    setState(() => quantity = widget.product.availableStock);
  }

  @override
  Widget build(BuildContext context) {
    int newQuantity = quantity + editedQuantity;
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return Dialog(
          child: SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.product.articleNumber, style: TextStyles.defaultBold),
                  Text(widget.product.name, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                  Gaps.h32,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FilterChip(
                        label: const Text('Menge + / -'),
                        labelStyle: const TextStyle(color: Colors.black),
                        selected: _quantityUpdateWay == QuantityUpdateWay.edit ? true : false,
                        selectedColor: CustomColors.chipSelectedColor,
                        backgroundColor: CustomColors.chipBackgroundColor,
                        onSelected: (bool isSelected) => isSelected ? setState(() => _quantityUpdateWay = QuantityUpdateWay.edit) : null,
                      ),
                      FilterChip(
                        label: const Text('Bestand ändern'),
                        labelStyle: const TextStyle(color: Colors.black),
                        selected: _quantityUpdateWay == QuantityUpdateWay.set ? true : false,
                        selectedColor: CustomColors.chipSelectedColor,
                        backgroundColor: CustomColors.chipBackgroundColor,
                        onSelected: (bool isSelected) => isSelected ? setState(() => _quantityUpdateWay = QuantityUpdateWay.set) : null,
                      ),
                    ],
                  ),
                  Gaps.h32,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(onPressed: () => setState(() => editedQuantity--), icon: const Icon(Icons.remove, color: Colors.red, size: 40)),
                      Text(editedQuantity.toString(), style: TextStyles.h1),
                      IconButton(onPressed: () => setState(() => editedQuantity++), icon: const Icon(Icons.add, color: Colors.green, size: 40)),
                    ],
                  ),
                  Gaps.h32,
                  const Text('Neuer Bestand:', style: TextStyles.h2),
                  Gaps.h16,
                  Text(newQuantity.toString(), style: TextStyles.h1),
                  Gaps.h32,
                  MyOutlinedButton(
                    buttonText: 'Speichern',
                    onPressed: () => context.read<ProductBloc>().add(UpdateQuantityOfProductEvent(product: widget.product, newQuantity: newQuantity)),
                    buttonBackgroundColor: Colors.green,
                    isLoading: state.isLoadingProductOnUpdate,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
