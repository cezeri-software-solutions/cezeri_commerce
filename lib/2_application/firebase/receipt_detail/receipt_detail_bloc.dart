import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:cezeri_helpers/cezeri_helpers.dart';
import 'package:flutter/material.dart';

import '../../../1_presentation/core/functions/mixed_functions.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/entities/receipt/receipt_product.dart';
import '../../../3_domain/entities/settings/tax.dart';

part 'receipt_detail_event.dart';
part 'receipt_detail_state.dart';

class ReceiptDetailBloc extends Bloc<ReceiptDetailEvent, ReceiptDetailState> {
  ReceiptDetailBloc() : super(ReceiptDetailState.initial()) {
//? #########################################################################

    on<SetReceiptReceiptDetailEvent>((event, emit) {
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
    });

//? #########################################################################

    on<SetListOfReceiptProductssReceiptDetailEvent>((event, emit) {
      emit(state.copyWith(listOfReceiptProducts: event.listOfReceiptProducts));
    });

//? #########################################################################

    on<AddProductToReceiptProductsEvent>((event, emit) {
      state.barcodeScannerController.clear();
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
        tax ??= Tax(
            taxId: '', taxName: 'Vorsteuer ${state.receipt.tax}%', taxRate: state.receipt.tax.taxRate, country: Country.empty(), isDefault: false);
        ReceiptProduct newReceiptProduct = event.receiptProduct.copyWith(
          tax: tax,
          unitPriceGross: event.receiptProduct.unitPriceNet * taxToCalc(tax.taxRate),
        );
        listOfReceiptProducts.add(newReceiptProduct);

        add(SetAllControllersEvent(listOfReceiptProducts: listOfReceiptProducts));
      }
    });

//? #########################################################################

    on<RemoveProductFromReceiptProductsEvent>((event, emit) {
      List<ReceiptProduct> listOfReceiptProducts = List.from(state.listOfReceiptProducts);
      listOfReceiptProducts.removeAt(event.index);

      emit(state.copyWith(listOfReceiptProducts: listOfReceiptProducts));

      add(SetAllControllersEvent());
    });

//? #########################################################################

    on<SetIsInScanModeEvent>((event, emit) {
      emit(state.copyWith(isInScanMode: event.isInScanMode));
    });

//? #########################################################################

    on<SetTotalDiscountPercentControllerEvent>((event, emit) {
      emit(state.copyWith(receipt: state.receipt.copyWith(discountPercent: event.value)));
      add(OnReceiptDetailTotalControllerChangedEvent());
    });

//? #########################################################################

    on<SetTotalDiscountAmountGrossControllerEvent>((event, emit) {
      emit(state.copyWith(receipt: state.receipt.copyWith(discountGross: event.value)));
      add(OnReceiptDetailTotalControllerChangedEvent());
    });

//? #########################################################################

    on<SetShippingAmountGrossControllerEvent>((event, emit) {
      emit(state.copyWith(receipt: state.receipt.copyWith(totalShippingGross: event.value)));
      add(OnReceiptDetailTotalControllerChangedEvent());
    });

//? #########################################################################

    on<SetAdditionalAmountGrossControllerEvent>((event, emit) {
      emit(state.copyWith(receipt: state.receipt.copyWith(additionalAmountGross: event.value)));
      add(OnReceiptDetailTotalControllerChangedEvent());
    });

//? #########################################################################

    on<OnReceiptDetailTotalControllerChangedEvent>((event, emit) {
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
          discountGross:
              ((discountPercentAmountGrossUnit + state.listOfReceiptProducts[i].discountGrossUnit) * state.listOfReceiptProducts[i].quantity)
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
                (state.discountPercentageAmountGross - (state.discountPercentageAmountGross / taxToCalc(state.receipt.tax.taxRate)))
                    .toMyRoundedDouble(),
            discountNet: (state.receipt.discountGross / taxToCalc(state.receipt.tax.taxRate)).toMyRoundedDouble(),
            discountTax: (state.receipt.discountGross - (state.receipt.discountGross / taxToCalc(state.receipt.tax.taxRate))).toMyRoundedDouble(),
            totalShippingNet: (state.receipt.totalShippingGross / taxToCalc(state.receipt.tax.taxRate)).toMyRoundedDouble(),
            totalShippingTax:
                (state.receipt.totalShippingGross - (state.receipt.totalShippingGross / taxToCalc(state.receipt.tax.taxRate))).toMyRoundedDouble(),
            additionalAmountNet: (state.receipt.additionalAmountGross / taxToCalc(state.receipt.tax.taxRate)).toMyRoundedDouble(),
            additionalAmountTax: (state.receipt.additionalAmountGross - (state.receipt.additionalAmountGross / taxToCalc(state.receipt.tax.taxRate)))
                .toMyRoundedDouble(),
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
          )));
    });

//? #########################################################################

    on<SetControllerOnTapOutsideReceiptDetailEvent>((event, emit) {
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
    });

//? #########################################################################
//? #########################################################################
//? ############################ Controllers ################################
//? #########################################################################
//? #########################################################################

    on<SetAllControllersEvent>((event, emit) {
      List<bool> isEditable = [];
      List<TextEditingController> articleNumberControllers = [];
      List<TextEditingController> articleNameControllers = [];
      List<Tax> taxRulesList = [];
      List<TextEditingController> quantityControllers = [];
      List<TextEditingController> unitPriceNetControllers = [];
      List<TextEditingController> posDiscountPercentControllers = [];
      List<TextEditingController> unitPriceGrossControllers = [];

      for (final product in event.listOfReceiptProducts == null ? state.listOfReceiptProducts : event.listOfReceiptProducts!) {
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
    });

//? #########################################################################

    on<SetArticleNumberControllerEvent>((event, emit) {
      List<TextEditingController> listOfArticleNumberControllers = List.from(state.articleNumberControllers);
      List<ReceiptProduct> listOfReceiptProducts = List.from(state.listOfReceiptProducts);
      listOfReceiptProducts[event.index] =
          listOfReceiptProducts[event.index].copyWith(articleNumber: listOfArticleNumberControllers[event.index].text);

      emit(state.copyWith(listOfReceiptProducts: listOfReceiptProducts));
    });

//? #########################################################################

    on<SetArticleNameControllerEvent>((event, emit) {
      List<TextEditingController> listOfArticleNameControllers = List.from(state.articleNameControllers);
      List<ReceiptProduct> listOfReceiptProducts = List.from(state.listOfReceiptProducts);
      listOfReceiptProducts[event.index] = listOfReceiptProducts[event.index].copyWith(name: listOfArticleNameControllers[event.index].text);

      emit(state.copyWith(listOfReceiptProducts: listOfReceiptProducts));
    });

//? #########################################################################

    on<SetQuantityControllerEvent>((event, emit) {
      List<TextEditingController> listOfQuantityControllers = List.from(state.quantityControllers);
      List<ReceiptProduct> listOfReceiptProducts = List.from(state.listOfReceiptProducts);
      listOfReceiptProducts[event.index] = listOfReceiptProducts[event.index].copyWith(
        quantity: int.parse(listOfQuantityControllers[event.index].text),
        profit: (listOfReceiptProducts[event.index].unitPriceNet - listOfReceiptProducts[event.index].wholesalePrice) *
            int.parse(listOfQuantityControllers[event.index].text),
      );
      emit(state.copyWith(listOfReceiptProducts: listOfReceiptProducts));

      add(OnReceiptDetailTotalControllerChangedEvent());
    });

//? #########################################################################

    on<SetUnitPriceNetControllerEvent>((event, emit) {
      List<TextEditingController> listOfUnitPriceNetControllers = List.from(state.unitPriceNetControllers);
      List<TextEditingController> listOfUnitPriceGrossControllers = List.from(state.unitPriceGrossControllers);
      List<ReceiptProduct> listOfReceiptProducts = List.from(state.listOfReceiptProducts);
      final unitPriceNet = listOfUnitPriceNetControllers[event.index].text.toMyDouble();
      final unitPriceGross = (unitPriceNet * taxToCalc(listOfReceiptProducts[event.index].tax.taxRate)).toMyRoundedDouble();
      final profitUnit = unitPriceNet - listOfReceiptProducts[event.index].wholesalePrice;
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
    });

//? #########################################################################

    on<SetPosDiscountPercentControllerEvent>((event, emit) {
      List<TextEditingController> listOfPosDiscountPercentControllers = List.from(state.posDiscountPercentControllers);
      List<ReceiptProduct> listOfReceiptProducts = List.from(state.listOfReceiptProducts);
      listOfReceiptProducts[event.index] = listOfReceiptProducts[event.index].copyWith(
        discountPercent: listOfPosDiscountPercentControllers[event.index].text.toMyDouble(),
      );
      emit(state.copyWith(listOfReceiptProducts: listOfReceiptProducts));

      add(OnReceiptDetailTotalControllerChangedEvent());
    });

//? #########################################################################

    on<SetUnitPriceGrossControllerEvent>((event, emit) {
      List<TextEditingController> listOfUnitPriceGrossControllers = List.from(state.unitPriceGrossControllers);
      List<TextEditingController> listOfUnitPriceNetControllers = List.from(state.unitPriceNetControllers);
      List<ReceiptProduct> listOfReceiptProducts = List.from(state.listOfReceiptProducts);
      final unitPriceNet =
          (listOfUnitPriceGrossControllers[event.index].text.toMyDouble() / taxToCalc(listOfReceiptProducts[event.index].tax.taxRate))
              .toMyRoundedDouble();
      final unitPriceGross = listOfUnitPriceGrossControllers[event.index].text.toMyDouble();
      final profitUnit = unitPriceNet - listOfReceiptProducts[event.index].wholesalePrice;
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
    });

//? #########################################################################
  }
}
