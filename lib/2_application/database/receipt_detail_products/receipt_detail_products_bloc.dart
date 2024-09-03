import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '/1_presentation/core/core.dart';
import '../../../3_domain/entities/country.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/entities/receipt/receipt_product.dart';
import '../../../3_domain/entities/settings/tax.dart';

part 'receipt_detail_products_event.dart';
part 'receipt_detail_products_state.dart';

class ReceiptDetailProductsBloc extends Bloc<ReceiptDetailProductsEvent, ReceiptDetailProductsState> {
  ReceiptDetailProductsBloc() : super(ReceiptDetailProductsState.initial()) {
    on<SetReceiptReceiptDetailEvent>(_onSetReceiptReceiptDetail);
    on<SetListOfReceiptProductssReceiptDetailEvent>(_onSetListOfReceiptProductssReceiptDetail);
    on<AddProductToReceiptProductsEvent>(_onAddProductToReceiptProducts);
    on<RemoveProductFromReceiptProductsEvent>(_onRemoveProductFromReceiptProducts);
    on<SetIsInScanModeEvent>(_onSetIsInScanMode);
    on<SetTotalDiscountPercentControllerEvent>(_onSetTotalDiscountPercentController);
    on<SetTotalDiscountAmountGrossControllerEvent>(_onSetTotalDiscountAmountGrossController);
    on<SetShippingAmountGrossControllerEvent>(_onSetShippingAmountGrossController);
    on<SetAdditionalAmountGrossControllerEvent>(_onSetAdditionalAmountGrossController);
    on<OnReceiptDetailTotalControllerChangedEvent>(_onOnReceiptDetailTotalControllerChanged);
    on<SetControllerOnTapOutsideReceiptDetailEvent>(_onSetControllerOnTapOutsideReceiptDetail);
    // on<OnBarcodeScannedEvent>(_onOnBarcodeScanned);
    on<SetAllControllersEvent>(_onSetAllControllers);
    // on<SetTaxRuleEvent>(_onSetTaxRule);
    on<SetArticleNumberControllerEvent>(_onSetArticleNumberController);
    on<SetArticleNameControllerEvent>(_onSetArticleNameController);
    on<SetQuantityControllerEvent>(_onSetQuantityController);
    on<SetUnitPriceNetControllerEvent>(_onSetUnitPriceNetController);
    on<SetPosDiscountPercentControllerEvent>(_onSetPosDiscountPercentController);
    on<SetUnitPriceGrossControllerEvent>(_onSetUnitPriceGrossController);
  }
//? #########################################################################

  void _onSetReceiptReceiptDetail(SetReceiptReceiptDetailEvent event, Emitter<ReceiptDetailProductsState> emit) {
    emit(state.copyWith(
      receipt: event.receipt,
      listOfReceiptProducts: event.receipt.listOfReceiptProduct,
      discountPercentageController: TextEditingController(text: event.receipt.discountPercent.toMyCurrencyString()),
      discountAmountGrossController: TextEditingController(text: event.receipt.discountGross.toMyCurrencyString()),
      shippingAmountGrossController: TextEditingController(text: event.receipt.totalShippingGross.toMyCurrencyString()),
      additionalAmountGrossController: TextEditingController(text: event.receipt.additionalAmountGross.toMyCurrencyString()),
      taxRulesListFromSettings: event.listOfTaxRules,
    ));

    add(SetAllControllersEvent());
  }

//? #########################################################################

  void _onSetListOfReceiptProductssReceiptDetail(SetListOfReceiptProductssReceiptDetailEvent event, Emitter<ReceiptDetailProductsState> emit) {
    emit(state.copyWith(
      receipt: event.receipt,
      listOfReceiptProducts: [ReceiptProduct.empty().copyWith(tax: event.receipt.tax)],
      isEditable: [true],
      articleNumberControllers: [TextEditingController()],
      articleNameControllers: [TextEditingController()],
      quantityControllers: [TextEditingController(text: '1')],
      unitPriceNetControllers: [TextEditingController(text: '0.00')],
      posDiscountPercentControllers: [TextEditingController(text: '0.00')],
      unitPriceGrossControllers: [TextEditingController(text: '0.00')],
      taxRulesListFromSettings: event.listOfTaxRules,
    ));
  }

//? #########################################################################

  void _onAddProductToReceiptProducts(AddProductToReceiptProductsEvent event, Emitter<ReceiptDetailProductsState> emit) {
    state.barcodeScannerController.clear();

    final isFirstProductEmpty = state.listOfReceiptProducts.length == 1 &&
        state.listOfReceiptProducts.first.articleNumber == '' &&
        state.listOfReceiptProducts.first.name == '';

    //* Schaut ob sich der Artikel bereits im Warenkorb befindet
    int? index;
    for (int i = 0; i < state.listOfReceiptProducts.length; i++) {
      if (event.receiptProduct.productId == state.listOfReceiptProducts[i].productId &&
          event.receiptProduct.articleNumber == state.listOfReceiptProducts[i].articleNumber) {
        index = i;
        break;
      }
    }

    if (index != null) {
      List<TextEditingController> listOfQuantityControllers = List.from(state.quantityControllers);
      listOfQuantityControllers[index] = TextEditingController(text: (int.parse(listOfQuantityControllers[index].text) + 1).toString());
      emit(state.copyWith(quantityControllers: listOfQuantityControllers));
      add(SetQuantityControllerEvent(index: index));
      add(SetAllControllersEvent());
    } else {
      List<ReceiptProduct> listOfReceiptProducts = List.from(state.listOfReceiptProducts);
      Tax? tax = state.taxRulesListFromSettings.where((e) => e.taxRate == state.receipt.tax.taxRate).firstOrNull;
      tax ??=
          Tax(taxId: '', taxName: 'Vorsteuer ${state.receipt.tax}%', taxRate: state.receipt.tax.taxRate, country: Country.empty(), isDefault: false);
      ReceiptProduct newReceiptProduct = event.receiptProduct.copyWith(
        tax: tax,
        unitPriceGross: event.receiptProduct.unitPriceNet * taxToCalc(tax.taxRate),
      );
      listOfReceiptProducts.add(newReceiptProduct);

      add(SetAllControllersEvent(listOfReceiptProducts: listOfReceiptProducts));
    }

    if (isFirstProductEmpty) add(RemoveProductFromReceiptProductsEvent(index: 0));
  }

//? #########################################################################

  void _onRemoveProductFromReceiptProducts(RemoveProductFromReceiptProductsEvent event, Emitter<ReceiptDetailProductsState> emit) {
    List<ReceiptProduct> listOfReceiptProducts = List.from(state.listOfReceiptProducts);
    if (listOfReceiptProducts.length == 1) {
      add(SetListOfReceiptProductssReceiptDetailEvent(receipt: state.receipt, listOfTaxRules: state.taxRulesListFromSettings));
    } else {
      listOfReceiptProducts.removeAt(event.index);
      emit(state.copyWith(listOfReceiptProducts: listOfReceiptProducts));
    }

    add(SetAllControllersEvent());
  }

//? #########################################################################

  void _onSetIsInScanMode(SetIsInScanModeEvent event, Emitter<ReceiptDetailProductsState> emit) {
    emit(state.copyWith(isInScanMode: event.isInScanMode));
  }

//? #########################################################################

  void _onSetTotalDiscountPercentController(SetTotalDiscountPercentControllerEvent event, Emitter<ReceiptDetailProductsState> emit) {
    emit(state.copyWith(receipt: state.receipt.copyWith(discountPercent: event.value)));
    add(OnReceiptDetailTotalControllerChangedEvent());
  }

//? #########################################################################

  void _onSetTotalDiscountAmountGrossController(SetTotalDiscountAmountGrossControllerEvent event, Emitter<ReceiptDetailProductsState> emit) {
    emit(state.copyWith(receipt: state.receipt.copyWith(discountGross: event.value)));
    add(OnReceiptDetailTotalControllerChangedEvent());
  }

//? #########################################################################

  void _onSetShippingAmountGrossController(SetShippingAmountGrossControllerEvent event, Emitter<ReceiptDetailProductsState> emit) {
    emit(state.copyWith(receipt: state.receipt.copyWith(totalShippingGross: event.value)));
    add(OnReceiptDetailTotalControllerChangedEvent());
  }

//? #########################################################################

  void _onSetAdditionalAmountGrossController(SetAdditionalAmountGrossControllerEvent event, Emitter<ReceiptDetailProductsState> emit) {
    emit(state.copyWith(receipt: state.receipt.copyWith(additionalAmountGross: event.value)));
    add(OnReceiptDetailTotalControllerChangedEvent());
  }

//? #########################################################################

  void _onOnReceiptDetailTotalControllerChanged(OnReceiptDetailTotalControllerChangedEvent event, Emitter<ReceiptDetailProductsState> emit) {
    double profit = state.receipt.totalShippingNet;
    for (var product in state.listOfReceiptProducts) {
      profit += product.profit;
    }

    List<ReceiptProduct> receiptProductsList = [];
    for (int i = 0; i < state.listOfReceiptProducts.length; i++) {
      final discountPercentAmountGrossUnit =
          (calcPercentageAmount(state.listOfReceiptProducts[i].unitPriceGross, state.listOfReceiptProducts[i].discountPercent)).toMyRoundedDouble();
      final discountPercentAmountNetUnit =
          (discountPercentAmountGrossUnit / taxToCalc(state.listOfReceiptProducts[i].tax.taxRate)).toMyRoundedDouble();
      final receiptProdut = state.listOfReceiptProducts[i].copyWith(
        discountPercentAmountGrossUnit: discountPercentAmountGrossUnit,
        discountPercentAmountNetUnit: discountPercentAmountNetUnit,
        discountGross: ((discountPercentAmountGrossUnit + state.listOfReceiptProducts[i].discountGrossUnit) * state.listOfReceiptProducts[i].quantity)
            .toMyRoundedDouble(),
        discountNet: ((discountPercentAmountNetUnit + state.listOfReceiptProducts[i].discountNetUnit) * state.listOfReceiptProducts[i].quantity)
            .toMyRoundedDouble(),
      );
      receiptProductsList.add(receiptProdut);
    }

    emit(state.copyWith(
      listOfReceiptProducts: receiptProductsList,
      receipt: state.receipt.copyWith(
        discountPercentAmountGross: state.discountPercentageAmountGross,
        discountPercentAmountNet: (state.discountPercentageAmountGross / taxToCalc(state.receipt.tax.taxRate)).toMyRoundedDouble(),
        discountPercentAmountTax:
            (state.discountPercentageAmountGross - (state.discountPercentageAmountGross / taxToCalc(state.receipt.tax.taxRate))).toMyRoundedDouble(),
        discountNet: (state.receipt.discountGross / taxToCalc(state.receipt.tax.taxRate)).toMyRoundedDouble(),
        discountTax: (state.receipt.discountGross - (state.receipt.discountGross / taxToCalc(state.receipt.tax.taxRate))).toMyRoundedDouble(),
        totalShippingNet: (state.receipt.totalShippingGross / taxToCalc(state.receipt.tax.taxRate)).toMyRoundedDouble(),
        totalShippingTax:
            (state.receipt.totalShippingGross - (state.receipt.totalShippingGross / taxToCalc(state.receipt.tax.taxRate))).toMyRoundedDouble(),
        additionalAmountNet: (state.receipt.additionalAmountGross / taxToCalc(state.receipt.tax.taxRate)).toMyRoundedDouble(),
        additionalAmountTax:
            (state.receipt.additionalAmountGross - (state.receipt.additionalAmountGross / taxToCalc(state.receipt.tax.taxRate))).toMyRoundedDouble(),
        //
        totalGross: state.totalGross,
        totalNet: (state.totalGross / taxToCalc(state.receipt.tax.taxRate)).toMyRoundedDouble(),
        totalTax: state.taxAmount,
        subTotalGross: state.productsTotalGross,
        subTotalNet: state.productsTotalNet,
        subTotalTax: state.productsTotalGross - state.productsTotalNet,
        posDiscountPercentAmountGross: state.posDiscountPercentAmount,
        posDiscountPercentAmountNet: (state.posDiscountPercentAmount / taxToCalc(state.receipt.tax.taxRate)).toMyRoundedDouble(),
        posDiscountPercentAmountTax:
            (state.posDiscountPercentAmount - (state.posDiscountPercentAmount / taxToCalc(state.receipt.tax.taxRate))).toMyRoundedDouble(),
        profit: profit,
        profitExclShipping: profit - state.receipt.totalShippingNet,
        profitExclWrapping: profit - state.receipt.totalWrappingNet,
        profitExclShippingAndWrapping: profit - state.receipt.totalShippingNet - state.receipt.totalWrappingNet,
      ),
    ));
  }

//? #########################################################################

  void _onSetControllerOnTapOutsideReceiptDetail(SetControllerOnTapOutsideReceiptDetailEvent event, Emitter<ReceiptDetailProductsState> emit) {
    emit(state.copyWith(
      discountPercentageController: state.discountPercentageController.text == ''
          ? TextEditingController(text: '0.00')
          : TextEditingController(text: state.discountPercentageController.text),
      discountAmountGrossController: state.discountAmountGrossController.text == ''
          ? TextEditingController(text: '0.00')
          : TextEditingController(text: state.discountAmountGrossController.text),
      shippingAmountGrossController: state.shippingAmountGrossController.text == ''
          ? TextEditingController(text: '0.00')
          : TextEditingController(text: state.shippingAmountGrossController.text),
      additionalAmountGrossController: state.additionalAmountGrossController.text == ''
          ? TextEditingController(text: '0.00')
          : TextEditingController(text: state.additionalAmountGrossController.text),
    ));
  }

//? #########################################################################
//? #########################################################################
//? ############################ Controllers ################################
//? #########################################################################
//? #########################################################################

  void _onSetAllControllers(SetAllControllersEvent event, Emitter<ReceiptDetailProductsState> emit) {
    List<bool> isEditable = [];
    List<TextEditingController> articleNumberControllers = [];
    List<TextEditingController> articleNameControllers = [];
    List<Tax> taxRulesList = [];
    List<TextEditingController> quantityControllers = [];
    List<TextEditingController> unitPriceNetControllers = [];
    List<TextEditingController> posDiscountPercentControllers = [];
    List<TextEditingController> unitPriceGrossControllers = [];

    for (final product in event.listOfReceiptProducts ?? state.listOfReceiptProducts) {
      if (product.isFromDatabase) {
        isEditable.add(false);
      } else {
        isEditable.add(true);
      }
      articleNumberControllers.add(TextEditingController(text: product.articleNumber));
      articleNameControllers.add(TextEditingController(text: product.name));
      if (event.listOfReceiptProducts == null) {
        taxRulesList.add(state.taxRulesListFromSettings.where((e) => e.taxName == product.tax.taxName).first);
      } else {
        taxRulesList.add(state.taxRulesListFromSettings.where((e) => e.isDefault).first);
      }
      quantityControllers.add(TextEditingController(text: product.quantity.toString()));
      unitPriceNetControllers.add(TextEditingController(text: product.unitPriceNet.toMyCurrencyStringToShow()));
      posDiscountPercentControllers.add(TextEditingController(text: product.discountPercent.toString()));
      unitPriceGrossControllers.add(TextEditingController(text: product.unitPriceGross.toMyCurrencyStringToShow()));
    }
    emit(state.copyWith(
      isEditable: isEditable,
      articleNumberControllers: articleNumberControllers,
      articleNameControllers: articleNameControllers,
      quantityControllers: quantityControllers,
      unitPriceNetControllers: unitPriceNetControllers,
      posDiscountPercentControllers: posDiscountPercentControllers,
      unitPriceGrossControllers: unitPriceGrossControllers,
      listOfReceiptProducts: event.listOfReceiptProducts ?? state.listOfReceiptProducts,
    ));

    add(OnReceiptDetailTotalControllerChangedEvent());
  }

//? #########################################################################

  void _onSetArticleNumberController(SetArticleNumberControllerEvent event, Emitter<ReceiptDetailProductsState> emit) {
    List<TextEditingController> listOfArticleNumberControllers = List.from(state.articleNumberControllers);
    List<ReceiptProduct> listOfReceiptProducts = List.from(state.listOfReceiptProducts);
    listOfReceiptProducts[event.index] = listOfReceiptProducts[event.index].copyWith(articleNumber: listOfArticleNumberControllers[event.index].text);

    emit(state.copyWith(listOfReceiptProducts: listOfReceiptProducts));
  }

//? #########################################################################

  void _onSetArticleNameController(SetArticleNameControllerEvent event, Emitter<ReceiptDetailProductsState> emit) {
    List<TextEditingController> listOfArticleNameControllers = List.from(state.articleNameControllers);
    List<ReceiptProduct> listOfReceiptProducts = List.from(state.listOfReceiptProducts);
    listOfReceiptProducts[event.index] = listOfReceiptProducts[event.index].copyWith(name: listOfArticleNameControllers[event.index].text);

    emit(state.copyWith(listOfReceiptProducts: listOfReceiptProducts));
  }

//? #########################################################################

  void _onSetQuantityController(SetQuantityControllerEvent event, Emitter<ReceiptDetailProductsState> emit) {
    List<TextEditingController> listOfQuantityControllers = List.from(state.quantityControllers);
    List<ReceiptProduct> listOfReceiptProducts = List.from(state.listOfReceiptProducts);
    listOfReceiptProducts[event.index] = listOfReceiptProducts[event.index].copyWith(
      quantity: int.parse(listOfQuantityControllers[event.index].text),
      profit: (listOfReceiptProducts[event.index].unitPriceNet - listOfReceiptProducts[event.index].wholesalePrice) *
          int.parse(listOfQuantityControllers[event.index].text),
    );
    emit(state.copyWith(listOfReceiptProducts: listOfReceiptProducts));

    add(OnReceiptDetailTotalControllerChangedEvent());
  }

//? #########################################################################

  void _onSetUnitPriceNetController(SetUnitPriceNetControllerEvent event, Emitter<ReceiptDetailProductsState> emit) {
    List<TextEditingController> listOfUnitPriceNetControllers = List.from(state.unitPriceNetControllers);
    List<TextEditingController> listOfUnitPriceGrossControllers = List.from(state.unitPriceGrossControllers);
    List<ReceiptProduct> listOfReceiptProducts = List.from(state.listOfReceiptProducts);
    final unitPriceNet = listOfUnitPriceNetControllers[event.index].text.toMyDouble();
    final unitPriceGross = (unitPriceNet * taxToCalc(listOfReceiptProducts[event.index].tax.taxRate)).toMyRoundedDouble();
    final profitUnit = unitPriceNet - listOfReceiptProducts[event.index].wholesalePrice - listOfReceiptProducts[event.index].discountNetUnit;
    final profit = profitUnit * listOfReceiptProducts[event.index].quantity;
    listOfReceiptProducts[event.index] = listOfReceiptProducts[event.index].copyWith(
      unitPriceNet: unitPriceNet,
      unitPriceGross: unitPriceGross,
      profitUnit: profitUnit,
      profit: profit,
    );
    listOfUnitPriceGrossControllers[event.index] = TextEditingController(text: unitPriceGross.toMyCurrencyStringToShow());
    emit(state.copyWith(
      listOfReceiptProducts: listOfReceiptProducts,
      unitPriceGrossControllers: listOfUnitPriceGrossControllers,
    ));

    add(OnReceiptDetailTotalControllerChangedEvent());
  }

//? #########################################################################

  void _onSetPosDiscountPercentController(SetPosDiscountPercentControllerEvent event, Emitter<ReceiptDetailProductsState> emit) {
    List<TextEditingController> listOfPosDiscountPercentControllers = List.from(state.posDiscountPercentControllers);
    List<ReceiptProduct> listOfReceiptProducts = List.from(state.listOfReceiptProducts);
    listOfReceiptProducts[event.index] = listOfReceiptProducts[event.index].copyWith(
      discountPercent: listOfPosDiscountPercentControllers[event.index].text.toMyDouble(),
    );
    emit(state.copyWith(listOfReceiptProducts: listOfReceiptProducts));

    add(OnReceiptDetailTotalControllerChangedEvent());
  }

//? #########################################################################

  void _onSetUnitPriceGrossController(SetUnitPriceGrossControllerEvent event, Emitter<ReceiptDetailProductsState> emit) {
    List<TextEditingController> listOfUnitPriceGrossControllers = List.from(state.unitPriceGrossControllers);
    List<TextEditingController> listOfUnitPriceNetControllers = List.from(state.unitPriceNetControllers);
    List<ReceiptProduct> listOfReceiptProducts = List.from(state.listOfReceiptProducts);
    final unitPriceNet = (listOfUnitPriceGrossControllers[event.index].text.toMyDouble() / taxToCalc(listOfReceiptProducts[event.index].tax.taxRate))
        .toMyRoundedDouble();
    final unitPriceGross = listOfUnitPriceGrossControllers[event.index].text.toMyDouble();
    final profitUnit = unitPriceNet - listOfReceiptProducts[event.index].wholesalePrice - listOfReceiptProducts[event.index].discountNetUnit;
    final profit = profitUnit * listOfReceiptProducts[event.index].quantity;
    listOfReceiptProducts[event.index] = listOfReceiptProducts[event.index].copyWith(
      unitPriceNet: unitPriceNet,
      unitPriceGross: unitPriceGross,
      profitUnit: profitUnit,
      profit: profit,
    );
    listOfUnitPriceNetControllers[event.index] = TextEditingController(text: unitPriceNet.toMyCurrencyStringToShow());
    emit(state.copyWith(
      listOfReceiptProducts: listOfReceiptProducts,
      unitPriceNetControllers: listOfUnitPriceNetControllers,
    ));

    add(OnReceiptDetailTotalControllerChangedEvent());
  }

//? #########################################################################
}
