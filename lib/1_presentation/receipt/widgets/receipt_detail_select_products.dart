import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../2_application/database/product/product_bloc.dart';
import '../../../2_application/database/receipt_detail_products/receipt_detail_products_bloc.dart';
import '../../../3_domain/entities/receipt/receipt_product.dart';
import '../../../constants.dart';
import '../../../injection.dart';
import '../../core/core.dart';

void showReceiptDetailSelectProducts(BuildContext context, ReceiptDetailProductsBloc receiptDetailProductsBloc) {
  final productBloc = sl<ProductBloc>()..add(GetProductsPerPageEvent(isFirstLoad: true, calcCount: true, currentPage: 1));

  WoltModalSheet.show(
    context: context,
    useSafeArea: false,
    showDragHandle: false,
    pageListBuilder: (context) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: true,
          isTopBarLayerAlwaysVisible: true,
          forceMaxHeight: true,
          topBarTitle: const Text('Artikel auswählen', style: TextStyles.h2Bold),
          stickyActionBar: BlocProvider.value(
            value: productBloc,
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                return PagesPaginationBar(
                  currentPage: state.currentPage,
                  totalPages: (state.totalQuantity / state.perPageQuantity).ceil(),
                  itemsPerPage: state.perPageQuantity,
                  totalItems: state.totalQuantity,
                  onPageChanged: (newPage) => productBloc.add(GetProductsPerPageEvent(isFirstLoad: false, calcCount: false, currentPage: newPage)),
                  onItemsPerPageChanged: (newValue) => productBloc.add(ItemsPerPageChangedEvent(value: newValue)),
                );
              },
            ),
          ),
          child: BlocProvider.value(
            value: productBloc,
            child: _ReceiptDetailSelectProducts(receiptDetailProductsBloc: receiptDetailProductsBloc),
          ),
        ),
      ];
    },
  );
}

class _ReceiptDetailSelectProducts extends StatelessWidget {
  final ReceiptDetailProductsBloc receiptDetailProductsBloc;

  const _ReceiptDetailSelectProducts({required this.receiptDetailProductsBloc});

  @override
  Widget build(BuildContext context) {
    final productBloc = BlocProvider.of<ProductBloc>(context);

    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(bottom: max(MediaQuery.paddingOf(context).bottom, 16)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: CupertinoSearchTextField(
                  controller: state.productSearchController,
                  onSubmitted: (value) =>
                      productBloc.add(GetProductsPerPageEvent(isFirstLoad: false, calcCount: false, currentPage: state.currentPage)),
                  onSuffixTap: () => productBloc.add(OnSearchFieldClearedEvent()),
                ),
              ),
              _ProductItems(receiptDetailProductsBloc: receiptDetailProductsBloc),
            ],
          ),
        );
      },
    );
  }
}

class _ProductItems extends StatelessWidget {
  final ReceiptDetailProductsBloc receiptDetailProductsBloc;

  const _ProductItems({required this.receiptDetailProductsBloc});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final height = screenHeight - 200;

    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        final onLoadingWidget = SizedBox(height: height, child: const Center(child: MyCircularProgressIndicator()));
        final onErrorWidget = SizedBox(height: height, child: const Center(child: Text('Ein Fehler ist aufgetreten!')));
        final onEmptyWidget = SizedBox(height: height, child: const Center(child: Text('Es konnten keine Artikel gefunden werden.')));

        if (state.isLoadingProductsOnObserve) return onLoadingWidget;
        if (state.firebaseFailure != null && state.isAnyFailure) return onErrorWidget;
        if (state.listOfAllProducts == null) return onLoadingWidget;
        if (state.listOfAllProducts!.isEmpty) return onEmptyWidget;

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: state.listOfFilteredProducts!.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final product = state.listOfFilteredProducts![index];
            final imageUrl = product.listOfProductImages.isNotEmpty ? product.listOfProductImages.where((e) => e.isDefault).first.fileUrl : null;

            return ListTile(
              leading: SizedBox(
                width: 40,
                child: MyAvatar(name: product.name, imageUrl: imageUrl, radius: 20, fontSize: 16),
              ),
              title: Text(product.name, style: TextStyles.defaultt),
              trailing: IconButton(
                onPressed: () => receiptDetailProductsBloc.add(
                  AddProductToReceiptProductsEvent(receiptProduct: ReceiptProduct.fromProduct(product)),
                ),
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.green),
              ),
              onTap: () {
                context.router.maybePop();
                receiptDetailProductsBloc.add(AddProductToReceiptProductsEvent(receiptProduct: ReceiptProduct.fromProduct(product)));
              },
            );
          },
        );
      },
    );
  }
}
