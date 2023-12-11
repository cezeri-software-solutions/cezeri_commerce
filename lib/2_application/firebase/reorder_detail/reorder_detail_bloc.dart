import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:cezeri_commerce/3_domain/entities/reorder/reorder_supplier.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../1_presentation/reorder/reorder_detail/reorder_detail_screen.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/reorder/reorder.dart';
import '../../../3_domain/entities/reorder/supplier.dart';
import '../../../3_domain/entities/settings/main_settings.dart';
import '../../../3_domain/entities/settings/tax.dart';
import '../../../3_domain/repositories/firebase/main_settings_respository.dart';
import '../../../3_domain/repositories/firebase/product_repository.dart';
import '../../../3_domain/repositories/firebase/reorder_repository.dart';
import '../../../core/firebase_failures.dart';

part 'reorder_detail_event.dart';
part 'reorder_detail_state.dart';

class ReorderDetailBloc extends Bloc<ReorderDetailEvent, ReorderDetailState> {
  final ReorderRepository reorderRepository;
  final ProductRepository productRepository;
  final MainSettingsRepository mainSettingsRepository;

  ReorderDetailBloc({
    required this.reorderRepository,
    required this.productRepository,
    required this.mainSettingsRepository,
  }) : super(ReorderDetailState.initial()) {
//? #########################################################################

    on<SetReorderDetailStateToInitialEvent>((event, emit) {
      emit(ReorderDetailState.initial());
    });

//? #########################################################################

    on<SetReorderDetailEvent>((event, emit) async {
      emit(state.copyWith(isLoadingReorderDetailOnObserve: true));

      Reorder? reorderToSet;
      switch (event.reorderCreateOrEdit) {
        case ReorderCreateOrEdit.create:
          {
            MainSettings? settings;
            final failureOrSuccessSettings = await mainSettingsRepository.getSettings();
            failureOrSuccessSettings.fold(
              (failure) {
                emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true));
                return;
              },
              (mainSettings) => settings = mainSettings,
            );

            reorderToSet = Reorder.empty().copyWith(
              reorderNumber: settings!.nextReorderNumber,
              reorderSupplier: ReorderSupplier(
                id: event.supplier!.id,
                supplierNumber: event.supplier!.supplierNumber,
                company: event.supplier!.company,
                name: event.supplier!.name,
              ),
              tax: event.supplier!.tax,
            );
          }
        case ReorderCreateOrEdit.edit:
          {
            final failureOrSuccessSettings = await reorderRepository.getReorder(event.reorderId!);
            failureOrSuccessSettings.fold(
              (failure) {
                emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true));
                return;
              },
              (loadedReorder) => reorderToSet = loadedReorder,
            );
          }
      }

      emit(state.copyWith(isLoadingReorderDetailOnObserve: false, reorder: reorderToSet!, firebaseFailure: null, isAnyFailure: false));
      add(SetReorderDetailControllersEvent());
    });

//? #########################################################################

    on<OnReorderDetailGetProductsEvent>((event, emit) async {
      emit(state.copyWith(isLoadingOnObserveReorderDetailProducts: true));

      final failureOrSuccess = await productRepository.getListOfProducts();
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (listOfLoadedProducts) {
          emit(state.copyWith(listOfProducts: listOfLoadedProducts, firebaseFailure: null, isAnyFailure: false));
          add(OnReorderDetailSetFilteredProductsEvent());
        },
      );

      emit(state.copyWith(
        isLoadingOnObserveReorderDetailProducts: false,
        fosReorderDetailOnObserveProductsOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosReorderDetailOnObserveProductsOption: none()));
    });

//? #########################################################################

    on<SetReorderDetailControllersEvent>((event, emit) {
      emit(state.copyWith(
        discountPercentController: TextEditingController(text: state.reorder!.discountPercent.toMyCurrencyString()),
        discountAmountGrossController: TextEditingController(text: state.reorder!.discountAmountGross.toMyCurrencyString()),
        additionalAmountGrossController: TextEditingController(text: state.reorder!.additionalAmountGross.toMyCurrencyString()),
        shippingPriceGrossController: TextEditingController(text: state.reorder!.shippingPriceGross.toMyCurrencyString()),
      ));
    });

//? #########################################################################

    on<OnReorderDetailControllerChangedEvent>((event, emit) {
      emit(state.copyWith(
        reorder: state.reorder!.copyWith(
          discountPercent: state.discountPercentController.text.toMyDouble(),
          discountAmountGross: state.discountAmountGrossController.text.toMyDouble(),
          additionalAmountGross: state.additionalAmountGrossController.text.toMyDouble(),
          shippingPriceGross: state.shippingPriceGrossController.text.toMyDouble(),
        ),
      ));
    });

//? #########################################################################

    on<OnReorderDetailSetFilteredProductsEvent>((event, emit) async {
      final listOfProducts = switch (state.productSearchController.text) {
        '' => state.listOfProducts,
        (_) => state.listOfProducts!
            .where((e) =>
                e.name.toLowerCase().contains(state.productSearchController.text.toLowerCase()) ||
                e.articleNumber.toLowerCase().contains(state.productSearchController.text.toLowerCase()) ||
                e.ean.contains(state.productSearchController.text))
            .toList()
      };
      if (listOfProducts!.isNotEmpty) listOfProducts.sort((a, b) => a.name.compareTo(b.name));
      emit(state.copyWith(listOfFilteredProducts: listOfProducts));
    });

//? #########################################################################

    on<OnReorderDetailProductSearchTextClearedEvent>((event, emit) async {
      add(OnReorderDetailSetFilteredProductsEvent());
    });

//? #########################################################################

    on<OnReorderDeatilAddProductEvent>((event, emit) async {
      int? index;
      for (int i = 0; i < state.reorder!.listOfReorderProducts.length; i++) {
        if (event.product.id == state.reorder!.listOfReorderProducts[i].productId &&
            event.product.articleNumber == state.reorder!.listOfReorderProducts[i].articleNumber) {
          index = i;
          break;
        }
      }

      if(index != null) {

      }
    });

//? #########################################################################

    on<ReorderDetailSetAllProductControllersEvent>((event, emit) {
      List<bool> isEditable = [];
      List<TextEditingController> articleNumberControllers = [];
      List<TextEditingController> articleNameControllers = [];
      List<Tax> taxRulesList = [];
      List<TextEditingController> quantityControllers = [];
      List<TextEditingController> unitPriceNetControllers = [];
      List<TextEditingController> posDiscountPercentControllers = [];
      List<TextEditingController> unitPriceGrossControllers = [];

      // for (final product in event.listOfReceiptProducts == null ? state.listOfReceiptProducts : event.listOfReceiptProducts!) {
      //   if (product.isFromDatabase) {
      //     isEditable.add(false);
      //   } else {
      //     isEditable.add(true);
      //   }
      //   articleNumberControllers.add(TextEditingController(text: product.articleNumber));
      //   articleNameControllers.add(TextEditingController(text: product.name));
      //   if (event.listOfReceiptProducts == null) {
      //     taxRulesList.add(state.taxRulesListFromSettings.where((e) => e.taxName == product.tax.taxName).first);
      //   } else {
      //     taxRulesList.add(state.taxRulesListFromSettings.where((e) => e.isDefault).first);
      //   }
      //   quantityControllers.add(TextEditingController(text: product.quantity.toString()));
      //   unitPriceNetControllers.add(TextEditingController(text: product.unitPriceNet.toMyCurrencyStringToShow()));
      //   posDiscountPercentControllers.add(TextEditingController(text: product.discountPercent.toString()));
      //   unitPriceGrossControllers.add(TextEditingController(text: product.unitPriceGross.toMyCurrencyStringToShow()));
      // }
      // emit(state.copyWith(
      //   isEditable: isEditable,
      //   articleNumberControllers: articleNumberControllers,
      //   articleNameControllers: articleNameControllers,
      //   quantityControllers: quantityControllers,
      //   unitPriceNetControllers: unitPriceNetControllers,
      //   posDiscountPercentControllers: posDiscountPercentControllers,
      //   unitPriceGrossControllers: unitPriceGrossControllers,
      //   listOfReceiptProducts: event.listOfReceiptProducts ?? state.listOfReceiptProducts,
      // ));

      // add(OnReceiptDetailTotalControllerChangedEvent());
    });

//? #########################################################################
//? #########################################################################
//? #########################################################################
//? #########################################################################
  }
}
