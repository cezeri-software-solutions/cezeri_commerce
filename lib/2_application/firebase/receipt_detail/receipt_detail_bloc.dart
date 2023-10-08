import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/string_to_double.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
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
        discountPercentage: event.receipt.discountPercent,
        discountAmountGross: event.receipt.discountGross,
        shippingAmountGross: event.receipt.totalShippingGross,
        additionalAmountGross: 0,
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
      List<ReceiptProduct> listOfReceiptProducts = List.from(state.listOfReceiptProducts);
      ReceiptProduct newReceiptProduct = event.receiptProduct.copyWith(tax: listOfReceiptProducts.last.tax);
      listOfReceiptProducts.add(newReceiptProduct);

      add(SetAllControllersEvent(listOfReceiptProducts: listOfReceiptProducts));
    });

//? #########################################################################

    on<RemoveProductFromReceiptProductsEvent>((event, emit) {
      List<ReceiptProduct> listOfReceiptProducts = List.from(state.listOfReceiptProducts);
      listOfReceiptProducts.removeAt(event.index);

      emit(state.copyWith(listOfReceiptProducts: listOfReceiptProducts));

      add(SetAllControllersEvent());
    });

//? #########################################################################
//? #########################################################################
//? ############################ Controllers ################################

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
        unitPriceNetControllers.add(TextEditingController(text: product.unitPriceNet.toMyCurrency()));
        posDiscountPercentControllers.add(TextEditingController(text: product.discountPercent.toString()));
        unitPriceGrossControllers.add(TextEditingController(text: product.unitPriceGross.toMyCurrency()));
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
          unitPriceNet: listOfUnitPriceNetControllers[event.index].text.toDouble(),
          unitPriceGross: listOfUnitPriceNetControllers[event.index].text.toDouble() * taxToCalc(listOfReceiptProducts[event.index].tax.taxRate));
      listOfUnitPriceGrossControllers[event.index] = TextEditingController(
          text: (listOfUnitPriceNetControllers[event.index].text.toDouble() * taxToCalc(listOfReceiptProducts[event.index].tax.taxRate))
              .toMyCurrency());
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
        discountPercent: listOfPosDiscountPercentControllers[event.index].text.toDouble(),
      );
      emit(state.copyWith(
        posDiscountPercent: listOfPosDiscountPercentControllers[event.index].text.toDouble(),
        listOfReceiptProducts: listOfReceiptProducts,
      ));
    });

//? #########################################################################

    on<SetUnitPriceGrossControllerEvent>((event, emit) {
      List<TextEditingController> listOfUnitPriceGrossControllers = List.from(state.unitPriceGrossControllers);
      List<TextEditingController> listOfUnitPriceNetControllers = List.from(state.unitPriceNetControllers);
      List<ReceiptProduct> listOfReceiptProducts = List.from(state.listOfReceiptProducts);
      listOfReceiptProducts[event.index] = listOfReceiptProducts[event.index].copyWith(
          unitPriceGross: listOfUnitPriceGrossControllers[event.index].text.toDouble(),
          unitPriceNet: listOfUnitPriceGrossControllers[event.index].text.toDouble() / taxToCalc(listOfReceiptProducts[event.index].tax.taxRate));
      listOfUnitPriceNetControllers[event.index] = TextEditingController(
          text: (listOfUnitPriceGrossControllers[event.index].text.toDouble() / taxToCalc(listOfReceiptProducts[event.index].tax.taxRate))
              .toMyCurrency());
      emit(state.copyWith(
        listOfReceiptProducts: listOfReceiptProducts,
        unitPriceNetControllers: listOfUnitPriceNetControllers,
      ));
    });

//? #########################################################################
  }
}
