import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/3_domain/entities/receipt/receipt_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/receipt_detail/receipt_detail_bloc.dart';
import '../../../2_application/database/receipt_detail_products/receipt_detail_products_bloc.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../constants.dart';
import '../../core/core.dart';
import 'receipt_detail_select_products.dart';

class ReceiptDetailProductsCard extends StatefulWidget {
  final ReceiptDetailBloc receiptDetailBloc;
  final ReceiptDetailProductsBloc receiptDetailProductsBloc;

  const ReceiptDetailProductsCard({super.key, required this.receiptDetailBloc, required this.receiptDetailProductsBloc});

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
        BlocListener<ReceiptDetailBloc, ReceiptDetailState>(
          bloc: widget.receiptDetailBloc,
          listenWhen: (p, c) => p.fosProductOnObserveOption != c.fosProductOnObserveOption,
          listener: (context, state) {
            state.fosProductOnObserveOption.fold(
              () => null,
              (a) => a.fold(
                (failure) => setState(() => _errorMessageEanNotFound = 'Artikel konnten nicht aus der Datenbank geladen werden'),
                (product) {
                  widget.receiptDetailProductsBloc.add(AddProductToReceiptProductsEvent(receiptProduct: ReceiptProduct.fromProduct(product)));
                  setState(() => _errorMessageEanNotFound = '');
                },
              ),
            );
          },
        ),
      ],
      child: BlocBuilder<ReceiptDetailProductsBloc, ReceiptDetailProductsState>(
        bloc: widget.receiptDetailProductsBloc,
        builder: (context, state) {
          return BlocBuilder<ReceiptDetailBloc, ReceiptDetailState>(
            bloc: widget.receiptDetailBloc,
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
                            onTap: () => widget.receiptDetailProductsBloc.add(SetIsInScanModeEvent(isInScanMode: true)),
                            onTapOutside: (_) => widget.receiptDetailProductsBloc.add(SetIsInScanModeEvent(isInScanMode: false)),
                            onChanged: (value) => _onEanScanned(value, stateProduct.productByEan, state.listOfReceiptProducts),
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
                                      onChanged: (_) => widget.receiptDetailProductsBloc.add(SetArticleNumberControllerEvent(index: index)),
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
                                      onChanged: (_) => widget.receiptDetailProductsBloc.add(SetArticleNameControllerEvent(index: index)),
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
                                      onChanged: (value) => widget.receiptDetailProductsBloc.add(SetQuantityControllerEvent(index: index)),
                                      onTapOutside: (_) {
                                        widget.receiptDetailProductsBloc.add(SetAllControllersEvent());
                                        FocusScope.of(context).unfocus();
                                      },
                                    ),
                                  ),
                                  Gaps.w8,
                                  Expanded(
                                    flex: RWRDP.unitPriceNet,
                                    child: MyTextFormFieldSmallDouble(
                                      controller: state.unitPriceNetControllers[index],
                                      onChanged: (_) => widget.receiptDetailProductsBloc.add(SetUnitPriceNetControllerEvent(index: index)),
                                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                                    ),
                                  ),
                                  Gaps.w8,
                                  Expanded(
                                    flex: RWRDP.discountGrossUnit,
                                    child: MyTextFormFieldSmallDouble(
                                      controller: state.posDiscountPercentControllers[index],
                                      onChanged: (_) => widget.receiptDetailProductsBloc.add(SetPosDiscountPercentControllerEvent(index: index)),
                                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                                      suffix: const Text('% '),
                                    ),
                                  ),
                                  Gaps.w8,
                                  Expanded(
                                    flex: RWRDP.unitPriceGross,
                                    child: MyTextFormFieldSmallDouble(
                                      controller: state.unitPriceGrossControllers[index],
                                      onChanged: (_) => widget.receiptDetailProductsBloc.add(SetUnitPriceGrossControllerEvent(index: index)),
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
                                          widget.receiptDetailProductsBloc.add(RemoveProductFromReceiptProductsEvent(index: index));
                                          context.router.maybePop();
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
                            onPressed: () => showReceiptDetailSelectProducts(context, widget.receiptDetailProductsBloc),
                          ),
                          TextButton.icon(
                            onPressed: () =>
                                widget.receiptDetailProductsBloc.add(AddProductToReceiptProductsEvent(receiptProduct: ReceiptProduct.empty())),
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

  void _onEanScanned(String value, Product? product, List<ReceiptProduct> listOfReceiptProducts) {
    if (value.length == 13) {
      if (product != null && product.ean == value) {
        widget.receiptDetailProductsBloc.add(AddProductToReceiptProductsEvent(receiptProduct: ReceiptProduct.fromProduct(product)));
        return;
      }
      if (listOfReceiptProducts.any((e) => e.ean == value)) {
        final index = listOfReceiptProducts.indexWhere((e) => e.ean == value);
        widget.receiptDetailProductsBloc.add(AddProductToReceiptProductsEvent(receiptProduct: listOfReceiptProducts[index]));
        return;
      }
      widget.receiptDetailBloc.add(ReceiptDetailGetProductByEanEvent(ean: value));
    }
  }
}
