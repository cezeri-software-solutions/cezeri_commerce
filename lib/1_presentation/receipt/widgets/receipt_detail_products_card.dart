import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:cezeri_commerce/1_presentation/core/widgets/my_circular_progress_indicator.dart';
import 'package:cezeri_commerce/3_domain/entities/receipt/receipt_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../2_application/database/product/product_bloc.dart';
import '../../../2_application/database/receipt/receipt_bloc.dart';
import '../../../2_application/database/receipt_detail/receipt_detail_bloc.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../constants.dart';
import '../../../injection.dart';
import '../../core/functions/dialogs.dart';
import '../../core/widgets/my_avatar.dart';
import '../../core/widgets/my_text_form_field_small_double.dart';
import '../../core/widgets/pages_pagination_bar.dart';

class ReceiptDetailProductsCard extends StatefulWidget {
  final ReceiptBloc receiptBloc;
  final ReceiptDetailBloc receiptDetailBloc;

  const ReceiptDetailProductsCard({super.key, required this.receiptBloc, required this.receiptDetailBloc});

  @override
  State<ReceiptDetailProductsCard> createState() => _ReceiptDetailProductsCardState();
}

class _ReceiptDetailProductsCardState extends State<ReceiptDetailProductsCard> {
  String _errorMessageEanNotFound = '';

  FocusNode scannerFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ReceiptBloc, ReceiptState>(
          bloc: widget.receiptBloc,
          listenWhen: (p, c) => p.fosProductOnObserveOption != c.fosProductOnObserveOption,
          listener: (context, state) {
            state.fosProductOnObserveOption.fold(
              () => null,
              (a) => a.fold(
                (failure) => setState(() => _errorMessageEanNotFound = 'Artikel konnten nicht aus der Datenbank geladen werden'),
                (product) {
                  widget.receiptDetailBloc.add(AddProductToReceiptProductsEvent(receiptProduct: ReceiptProduct.fromProduct(product)));
                  setState(() => _errorMessageEanNotFound = '');
                },
              ),
            );
          },
        ),
      ],
      child: BlocBuilder<ReceiptDetailBloc, ReceiptDetailState>(
        bloc: widget.receiptDetailBloc,
        builder: (context, state) {
          return BlocBuilder<ReceiptBloc, ReceiptState>(
            bloc: widget.receiptBloc,
            builder: (context, stateProduct) {
              if (state.isInScanMode) FocusScope.of(context).requestFocus(scannerFocusNode);

              if (state.listOfReceiptProducts.isEmpty || state.isEditable.isEmpty) return const MyCircularProgressIndicator();
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.qr_code_scanner),
                          Gaps.w16,
                          MyTextFormFieldSmallDouble(
                            maxWidth: 200,
                            focusNode: scannerFocusNode,
                            controller: state.barcodeScannerController,
                            onTap: () => widget.receiptDetailBloc.add(SetIsInScanModeEvent(isInScanMode: true)),
                            onTapOutside: (_) => widget.receiptDetailBloc.add(SetIsInScanModeEvent(isInScanMode: false)),
                            onChanged: (value) => _onEanScanned(
                              value,
                              stateProduct.listOfAllProducts,
                              stateProduct.product,
                              state.listOfReceiptProducts,
                            ),
                          ),
                          Gaps.w16,
                          stateProduct.isLoadingProductOnObserve
                              ? const MyCircularProgressIndicator()
                              : Text(_errorMessageEanNotFound, style: const TextStyle(color: Colors.red)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Expanded(
                            flex: RWRDP.articleNumber,
                            child: Text('Artikelnr.', style: TextStyles.s12Bold),
                          ),
                          Gaps.w8,
                          const Expanded(
                            flex: RWRDP.articleName,
                            child: Text('Name', style: TextStyles.s12Bold),
                          ),
                          Gaps.w8,
                          const Expanded(
                            flex: RWRDP.tax,
                            child: Text('Steuer', style: TextStyles.s12Bold),
                          ),
                          Gaps.w8,
                          const Expanded(
                            flex: RWRDP.quantity,
                            child: Text('Menge', style: TextStyles.s12Bold),
                          ),
                          Gaps.w8,
                          const Expanded(
                            flex: RWRDP.unitPriceNet,
                            child: Text('Netto Stk.', style: TextStyles.s12Bold),
                          ),
                          Gaps.w8,
                          const Expanded(
                            flex: RWRDP.discountGrossUnit,
                            child: Text('Rabatt %', style: TextStyles.s12Bold),
                          ),
                          Gaps.w8,
                          const Expanded(
                            flex: RWRDP.unitPriceGross,
                            child: Text('Brutto Stk.', style: TextStyles.s12Bold),
                          ),
                          Gaps.w8,
                          const Expanded(
                            flex: RWRDP.totalPriceGross,
                            child: Text('Gesamt Brutto', style: TextStyles.s12Bold),
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 28),
                            child: const IconButton(
                              onPressed: null,
                              padding: EdgeInsets.zero,
                              splashRadius: 0.0001,
                              constraints: BoxConstraints(),
                              icon: Icon(Icons.delete, color: Colors.transparent),
                            ),
                          ),
                        ],
                      ),
                      Gaps.h8,
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.listOfReceiptProducts.length,
                        itemBuilder: (context, index) {
                          final receiptProduct = state.listOfReceiptProducts[index];
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: RWRDP.articleNumber,
                                    child: MyTextFormFieldSmallDouble(
                                      readOnly: !state.isEditable[index],
                                      inputFormatters: const [],
                                      controller: state.articleNumberControllers[index],
                                      onChanged: (_) => widget.receiptDetailBloc.add(SetArticleNumberControllerEvent(index: index)),
                                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                                    ),
                                  ),
                                  Gaps.w8,
                                  Expanded(
                                    flex: RWRDP.articleName,
                                    child: MyTextFormFieldSmallDouble(
                                      readOnly: !state.isEditable[index],
                                      inputFormatters: const [],
                                      controller: state.articleNameControllers[index],
                                      onChanged: (_) => widget.receiptDetailBloc.add(SetArticleNameControllerEvent(index: index)),
                                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                                    ),
                                  ),
                                  Gaps.w8,
                                  Expanded(
                                    flex: RWRDP.tax,
                                    child: MyTextFormFieldSmallDouble(
                                      readOnly: true,
                                      hintText: state.listOfReceiptProducts[index].tax.taxName,
                                    ),
                                  ),
                                  Gaps.w8,
                                  Expanded(
                                    flex: RWRDP.quantity,
                                    child: MyTextFormFieldSmallDouble(
                                      controller: state.quantityControllers[index],
                                      onChanged: (value) => widget.receiptDetailBloc.add(SetQuantityControllerEvent(index: index)),
                                      onTapOutside: (_) {
                                        widget.receiptDetailBloc.add(SetAllControllersEvent());
                                        FocusScope.of(context).unfocus();
                                      },
                                    ),
                                  ),
                                  Gaps.w8,
                                  Expanded(
                                    flex: RWRDP.unitPriceNet,
                                    child: MyTextFormFieldSmallDouble(
                                      controller: state.unitPriceNetControllers[index],
                                      onChanged: (_) => widget.receiptDetailBloc.add(SetUnitPriceNetControllerEvent(index: index)),
                                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                                    ),
                                  ),
                                  Gaps.w8,
                                  Expanded(
                                    flex: RWRDP.discountGrossUnit,
                                    child: MyTextFormFieldSmallDouble(
                                      controller: state.posDiscountPercentControllers[index],
                                      onChanged: (_) => widget.receiptDetailBloc.add(SetPosDiscountPercentControllerEvent(index: index)),
                                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                                      suffix: const Text('% '),
                                    ),
                                  ),
                                  Gaps.w8,
                                  Expanded(
                                    flex: RWRDP.unitPriceGross,
                                    child: MyTextFormFieldSmallDouble(
                                      controller: state.unitPriceGrossControllers[index],
                                      onChanged: (_) => widget.receiptDetailBloc.add(SetUnitPriceGrossControllerEvent(index: index)),
                                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                                    ),
                                  ),
                                  Gaps.w8,
                                  Expanded(
                                    flex: RWRDP.totalPriceGross,
                                    child: MyTextFormFieldSmallDouble(
                                      readOnly: true,
                                      hintText: (receiptProduct.unitPriceGross * receiptProduct.quantity).toMyCurrencyStringToShow(),
                                    ),
                                  ),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxHeight: 28),
                                    child: IconButton(
                                      onPressed: () => showMyDialogDelete(
                                        context: context,
                                        content:
                                            'Bist du sicher, dass du den Artikel "//${state.listOfReceiptProducts[index].name}" unwiederruflich löschen willst?',
                                        onConfirm: () {
                                          widget.receiptDetailBloc.add(RemoveProductFromReceiptProductsEvent(index: index));
                                          context.router.pop();
                                        },
                                      ),
                                      padding: EdgeInsets.zero,
                                      splashRadius: 0.0001,
                                      constraints: const BoxConstraints(),
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                              Gaps.h8,
                            ],
                          );
                        },
                      ),
                      Gaps.h8,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton.icon(
                            icon: const Icon(Icons.add, color: Colors.green),
                            label: const Text('Aus Artikelliste'),
                            onPressed: () {
                              WoltModalSheet.show(
                                context: context,
                                useSafeArea: false,
                                pageListBuilder: (context) {
                                  return [
                                    WoltModalSheetPage(
                                      hasTopBarLayer: false,
                                      forceMaxHeight: true,
                                      isTopBarLayerAlwaysVisible: false,
                                      child: _SelectReceiptProducts(receiptDetailBloc: widget.receiptDetailBloc),
                                    ),
                                  ];
                                },
                              );
                            },
                          ),
                          TextButton.icon(
                            onPressed: () => widget.receiptDetailBloc.add(AddProductToReceiptProductsEvent(receiptProduct: ReceiptProduct.empty())),
                            icon: const Icon(Icons.add, color: Colors.green),
                            label: const Text('Leeres Feld'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _onEanScanned(String value, List<Product>? listOfAllProducts, Product? product, List<ReceiptProduct> listOfReceiptProducts) {
    if (value.length == 13) {
      if (product != null && product.ean == value) {
        widget.receiptDetailBloc.add(AddProductToReceiptProductsEvent(receiptProduct: ReceiptProduct.fromProduct(product)));
        return;
      }
      if (listOfReceiptProducts.any((e) => e.ean == value)) {
        final index = listOfReceiptProducts.indexWhere((e) => e.ean == value);
        widget.receiptDetailBloc.add(AddProductToReceiptProductsEvent(receiptProduct: listOfReceiptProducts[index]));
        return;
      }
      widget.receiptBloc.add(GetProductByEanEvent(ean: value));
    }
  }
}

class _SelectReceiptProducts extends StatelessWidget {
  final ReceiptDetailBloc receiptDetailBloc;

  const _SelectReceiptProducts({super.key, required this.receiptDetailBloc});

  @override
  Widget build(BuildContext context) {
    final productBloc = sl<ProductBloc>()..add(GetProductsPerPageEvent(isFirstLoad: true, calcCount: true, currentPage: 1));

    return BlocProvider.value(
      value: productBloc,
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: CupertinoSearchTextField(
                  controller: state.productSearchController,
                  onSubmitted: (value) => _onSearchFieldSubmitted(context, productBloc, value),
                  onSuffixTap: () => productBloc.add(OnSearchFieldClearedEvent()),
                ),
              ),
              _ProductItems(productBloc: productBloc, receiptDetailBloc: receiptDetailBloc),
              if (state.totalQuantity > 0) ...[
                const Divider(height: 0),
                PagesPaginationBar(
                  currentPage: state.currentPage,
                  totalPages: (state.totalQuantity / state.perPageQuantity).ceil(),
                  itemsPerPage: state.perPageQuantity,
                  totalItems: state.totalQuantity,
                  onPageChanged: (newPage) => state.productSearchController.text.isEmpty
                      ? productBloc.add(GetProductsPerPageEvent(isFirstLoad: false, calcCount: false, currentPage: newPage))
                      : productBloc.add(
                          GetFilteredProductsBySearchTextEvent(currentPage: newPage),
                        ),
                  onItemsPerPageChanged: (newValue) => productBloc.add(ItemsPerPageChangedEvent(value: newValue)),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  void _onSearchFieldSubmitted(BuildContext context, ProductBloc productBloc, String value) {
    if (value.isEmpty) {
      productBloc.add(GetProductsPerPageEvent(isFirstLoad: false, calcCount: true, currentPage: 1));
      return;
    }

    if (value.length < 3) {
      showMyDialogAlert(context: context, title: 'Achtung', content: 'Die Suche muss mindestens 3 Zeichen enthalten!');
      return;
    }

    productBloc.add(GetFilteredProductsBySearchTextEvent(currentPage: 1));
  }
}

class _ProductItems extends StatelessWidget {
  final ProductBloc productBloc;
  final ReceiptDetailBloc receiptDetailBloc;

  const _ProductItems({super.key, required this.productBloc, required this.receiptDetailBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      bloc: productBloc,
      builder: (context, state) {
        const onLoadingWidget = SizedBox(height: 1000, child: Center(child: MyCircularProgressIndicator()));
        const onErrorWidget = SizedBox(height: 1000, child: Center(child: Text('Ein Fehler ist aufgetreten!')));
        const onEmptyWidget = SizedBox(height: 1000, child: Center(child: Text('Es konnten keine Artikel gefunden werden.')));

        if (state.isLoadingProductsOnObserve) return onLoadingWidget;
        if (state.firebaseFailure != null && state.isAnyFailure) return onErrorWidget;
        if (state.listOfAllProducts == null) return onLoadingWidget;
        if (state.listOfAllProducts!.isEmpty) return onEmptyWidget;

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
                onPressed: () => receiptDetailBloc.add(AddProductToReceiptProductsEvent(receiptProduct: ReceiptProduct.fromProduct(product))),
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.green),
              ),
              onTap: () {
                context.router.maybePop();
                receiptDetailBloc.add(AddProductToReceiptProductsEvent(receiptProduct: ReceiptProduct.fromProduct(product)));
              },
            );
          },
        );
      },
    );
  }
}
