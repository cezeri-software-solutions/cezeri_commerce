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
        Tax? tax = state.taxRulesListFromSettings.where((e) => e.taxRate == state.receipt.tax).firstOrNull;
        tax ??= Tax(taxId: '', taxName: 'Vorsteuer ${state.receipt.tax}%', taxRate: state.receipt.tax, country: Country.empty(), isDefault: false);
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
      emit(state.copyWith(
          receipt: state.receipt.copyWith(
        discountPercentAmountGross: state.discountPercentageAmountGross,
        discountPercentAmountNet: state.discountPercentageAmountGross / taxToCalc(state.receipt.tax),
        discountPercentAmountTax: state.discountPercentageAmountGross - (state.discountPercentageAmountGross / taxToCalc(state.receipt.tax)),
        discountNet: state.receipt.discountGross / taxToCalc(state.receipt.tax),
        discountTax: state.receipt.discountGross - (state.receipt.discountGross / taxToCalc(state.receipt.tax)),
        totalShippingNet: state.receipt.totalShippingGross / taxToCalc(state.receipt.tax),
        totalShippingTax: state.receipt.totalShippingGross - (state.receipt.totalShippingGross / taxToCalc(state.receipt.tax)),
        additionalAmountNet: state.receipt.additionalAmountGross / taxToCalc(state.receipt.tax),
        additionalAmountTax: state.receipt.additionalAmountGross - (state.receipt.additionalAmountGross / taxToCalc(state.receipt.tax)),
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
        if (product.isFromMarketplace) {
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
        taxRulesList: taxRulesList,
        quantityControllers: quantityControllers,
        unitPriceNetControllers: unitPriceNetControllers,
        posDiscountPercentControllers: posDiscountPercentControllers,
        unitPriceGrossControllers: unitPriceGrossControllers,
        listOfReceiptProducts: event.listOfReceiptProducts ?? state.listOfReceiptProducts,
      ));
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
      listOfReceiptProducts[event.index] =
          listOfReceiptProducts[event.index].copyWith(quantity: int.parse(listOfQuantityControllers[event.index].text));
      emit(state.copyWith(listOfReceiptProducts: listOfReceiptProducts));
    });

//? #########################################################################

    on<SetUnitPriceNetControllerEvent>((event, emit) {
      List<TextEditingController> listOfUnitPriceNetControllers = List.from(state.unitPriceNetControllers);
      List<TextEditingController> listOfUnitPriceGrossControllers = List.from(state.unitPriceGrossControllers);
      List<ReceiptProduct> listOfReceiptProducts = List.from(state.listOfReceiptProducts);
      listOfReceiptProducts[event.index] = listOfReceiptProducts[event.index].copyWith(
          unitPriceNet: listOfUnitPriceNetControllers[event.index].text.toMyDouble(),
          unitPriceGross: listOfUnitPriceNetControllers[event.index].text.toMyDouble() * taxToCalc(listOfReceiptProducts[event.index].tax.taxRate));
      listOfUnitPriceGrossControllers[event.index] = TextEditingController(
          text: (listOfUnitPriceNetControllers[event.index].text.toMyDouble() * taxToCalc(listOfReceiptProducts[event.index].tax.taxRate))
              .toMyCurrencyStringToShow());
      emit(state.copyWith(
        listOfReceiptProducts: listOfReceiptProducts,
        unitPriceGrossControllers: listOfUnitPriceGrossControllers,
      ));
    });

//? #########################################################################

    on<SetPosDiscountPercentControllerEvent>((event, emit) {
      List<TextEditingController> listOfPosDiscountPercentControllers = List.from(state.posDiscountPercentControllers);
      List<ReceiptProduct> listOfReceiptProducts = List.from(state.listOfReceiptProducts);
      listOfReceiptProducts[event.index] = listOfReceiptProducts[event.index].copyWith(
        discountPercent: listOfPosDiscountPercentControllers[event.index].text.toMyDouble(),
      );
      emit(state.copyWith(
        posDiscountPercent: listOfPosDiscountPercentControllers[event.index].text.toMyDouble(),
        listOfReceiptProducts: listOfReceiptProducts,
      ));
    });

//? #########################################################################

    on<SetUnitPriceGrossControllerEvent>((event, emit) {
      List<TextEditingController> listOfUnitPriceGrossControllers = List.from(state.unitPriceGrossControllers);
      List<TextEditingController> listOfUnitPriceNetControllers = List.from(state.unitPriceNetControllers);
      List<ReceiptProduct> listOfReceiptProducts = List.from(state.listOfReceiptProducts);
      listOfReceiptProducts[event.index] = listOfReceiptProducts[event.index].copyWith(
          unitPriceGross: listOfUnitPriceGrossControllers[event.index].text.toMyDouble(),
          unitPriceNet: listOfUnitPriceGrossControllers[event.index].text.toMyDouble() / taxToCalc(listOfReceiptProducts[event.index].tax.taxRate));
      listOfUnitPriceNetControllers[event.index] = TextEditingController(
          text: (listOfUnitPriceGrossControllers[event.index].text.toMyDouble() / taxToCalc(listOfReceiptProducts[event.index].tax.taxRate))
              .toMyCurrencyStringToShow());
      emit(state.copyWith(
        listOfReceiptProducts: listOfReceiptProducts,
        unitPriceNetControllers: listOfUnitPriceNetControllers,
      ));
    });

//? #########################################################################
  }
}
