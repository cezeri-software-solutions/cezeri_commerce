import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/3_domain/entities/reorder/reorder_supplier.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '/1_presentation/core/core.dart';
import '/1_presentation/reorder/reorder_detail/reorder_detail_screen.dart';
import '/3_domain/entities/marketplace/abstract_marketplace.dart';
import '/3_domain/entities/product/product.dart';
import '/3_domain/entities/reorder/reorder.dart';
import '/3_domain/entities/reorder/reorder_product.dart';
import '/3_domain/entities/reorder/supplier.dart';
import '/3_domain/entities/settings/main_settings.dart';
import '/3_domain/entities/settings/tax.dart';
import '../../../3_domain/entities/statistic/product_sales_data.dart';
import '../../../3_domain/repositories/database/main_settings_respository.dart';
import '../../../3_domain/repositories/database/marketplace_repository.dart';
import '../../../3_domain/repositories/database/product_repository.dart';
import '../../../3_domain/repositories/database/reorder_repository.dart';
import '../../../3_domain/repositories/database/stat_product_repository.dart';
import '../../../3_domain/repositories/database/supplier_repository.dart';
import '../../../failures/abstract_failure.dart';

part 'reorder_detail_event.dart';
part 'reorder_detail_state.dart';

class ReorderDetailBloc extends Bloc<ReorderDetailEvent, ReorderDetailState> {
  final ReorderRepository reorderRepository;
  final ProductRepository productRepository;
  final MainSettingsRepository mainSettingsRepository;
  final MarketplaceRepository marketplaceRepository;
  final StatProductRepository statProductRepository;
  final SupplierRepository supplierRepository;

  ReorderDetailBloc({
    required this.reorderRepository,
    required this.productRepository,
    required this.mainSettingsRepository,
    required this.marketplaceRepository,
    required this.statProductRepository,
    required this.supplierRepository,
  }) : super(ReorderDetailState.initial()) {
//? #########################################################################

    on<SetReorderDetailStateToInitialEvent>((event, emit) {
      emit(ReorderDetailState.initial());
    });

//? #########################################################################

    on<ReorderDetailCreateReorderEvent>((event, emit) async {
      emit(state.copyWith(isLoadingOnCreateReorder: true));

      final failureOrSuccess = await reorderRepository.createReorder(state.reorder!);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (reorder) => emit(state.copyWith(reorder: reorder, firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingOnCreateReorder: false,
        fosReorderDetailOnCreateOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosReorderDetailOnCreateOption: none()));
    });

//? #########################################################################

    on<ReorderDetailUpdateReorderEvent>((event, emit) async {
      emit(state.copyWith(isLoadingOnUpdateReorder: true));

      final failureOrSuccess = await reorderRepository.updateReorder(state.reorder!);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (reorder) => emit(state.copyWith(reorder: reorder, firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingOnUpdateReorder: false,
        fosReorderDetailOnOUpdateOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosReorderDetailOnOUpdateOption: none()));
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

      Supplier? supplierToSet;
      final fosSupplier = switch (event.reorderCreateOrEdit) {
        ReorderCreateOrEdit.create => await supplierRepository.getSupplier(event.supplier!.id),
        ReorderCreateOrEdit.edit => await supplierRepository.getSupplier(reorderToSet!.reorderSupplier.id),
      };
      fosSupplier.fold(
        (failure) {
          emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true));
          return;
        },
        (loadedSupplier) => supplierToSet = loadedSupplier,
      );

      emit(state.copyWith(
        isLoadingReorderDetailOnObserve: false,
        reorder: reorderToSet!,
        supplier: supplierToSet!,
        firebaseFailure: null,
        isAnyFailure: false,
      ));
      add(SetReorderDetailControllersEvent());
      add(ReorderDetailSetAllProductControllersEvent());
    });

//? #########################################################################

    on<OnReorderDetailGetProductsEvent>((event, emit) async {
      emit(state.copyWith(isLoadingOnObserveReorderDetailProducts: true));

      final failureOrSuccess = state.getAllProducts
          ? await productRepository.getListOfProducts(false)
          : await productRepository.getListOfProductsBySupplierName(onlyActive: true, supplier: state.supplier!);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (listOfLoadedProducts) {
          emit(state.copyWith(listOfProducts: listOfLoadedProducts, firebaseFailure: null, isAnyFailure: false));
          add(OnReorderDetailSetFilteredProductsEvent());
        },
      );

      if (state.statProductDateRange != null &&
          (state.reloadProducts || state.listOfProductSalesData == null || state.listOfProductSalesDataInklOpen == null)) {
        final productIds = state.listOfProducts!.map((e) => e.id).toList();
        final fosSalesData = await statProductRepository.getProductSalesDataBetweenDates(
          state.statProductDateRange!,
          state.getAllProducts ? [] : productIds,
        );

        if (fosSalesData.isRight()) {
          final fosSalesDataInklOpen = await statProductRepository.getProductSalesDataOfOpenAppBetweenDates(
            state.statProductDateRange!,
            state.getAllProducts ? [] : productIds,
          );

          final loadedListOfSalesData = fosSalesData.getRight();

          if (fosSalesDataInklOpen.isRight()) {
            final productSalesDataInklOpen = loadedListOfSalesData.map((e) {
              final openData = fosSalesDataInklOpen.getRight();
              final data = openData.where((element) => element.productId == e.productId).firstOrNull;
              if (data == null) return e;
              final sumData = e.copyWith(totalQuantity: e.totalQuantity + data.totalQuantity, totalRevenue: e.totalRevenue + data.totalRevenue);
              return sumData;
            }).toList();

            emit(state.copyWith(
              reloadProducts: false,
              listOfProductSalesData: loadedListOfSalesData,
              listOfProductSalesDataInklOpen: productSalesDataInklOpen,
            ));
          } else {
            emit(state.copyWith(
              reloadProducts: false,
              listOfProductSalesData: loadedListOfSalesData,
              listOfProductSalesDataInklOpen: loadedListOfSalesData,
            ));
          }
        }
      }

      emit(state.copyWith(
        isLoadingOnObserveReorderDetailProducts: false,
        fosReorderDetailOnObserveProductsOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosReorderDetailOnObserveProductsOption: none()));
    });

//? #########################################################################

    on<OnReorderDetailClosedManuallyChangeEvent>((event, emit) async {
      final newReorderStatus = event.value
          ? ReorderStatus.completed
          : state.reorder!.listOfReorderProducts.every((e) => e.bookedQuantity == 0)
              ? ReorderStatus.open
              : state.reorder!.listOfReorderProducts.every((e) => e.bookedQuantity == e.quantity)
                  ? ReorderStatus.completed
                  : ReorderStatus.partiallyCompleted;

      emit(state.copyWith(reorder: state.reorder!.copyWith(closedManually: event.value, reorderStatus: newReorderStatus)));
    });

//? #########################################################################

    on<OnReorderDetailGetPdfDataEvent>((event, emit) async {
      emit(state.copyWith(isLoadingPdfData: true));

      final failureOrSuccess = await marketplaceRepository.getListOfMarketplaces();
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (marketplaces) => emit(state.copyWith(listOfMarketplaces: marketplaces, firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingPdfData: false,
        fosReorderDetailOnPdfDataOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosReorderDetailOnPdfDataOption: none()));
    });

//? #########################################################################

    on<OnReorderDetailSetStatProductFromDateEvent>((event, emit) async {
      emit(state.copyWith(
        statProductDateRange: DateTimeRange(
          start: event.dateRange.start,
          end: DateTime(event.dateRange.end.year, event.dateRange.end.month, event.dateRange.end.day + 1),
        ),
        reloadProducts: true,
      ));
    });

//? #########################################################################

    on<OnReorderDetailSetLoadAllProductsEvent>((event, emit) async {
      emit(state.copyWith(getAllProducts: !state.getAllProducts, reloadProducts: true));
    });

//? #########################################################################

    on<SetReorderDetailControllersEvent>((event, emit) {
      emit(state.copyWith(
        discountPercentController: TextEditingController(text: state.reorder!.discountPercent.toMyCurrencyString()),
        discountAmountGrossController: TextEditingController(text: state.reorder!.discountAmountGross.toMyCurrencyString()),
        additionalAmountGrossController: TextEditingController(text: state.reorder!.additionalAmountGross.toMyCurrencyString()),
        shippingPriceGrossController: TextEditingController(text: state.reorder!.shippingPriceGross.toMyCurrencyString()),
        reorderNumberInternalController: TextEditingController(text: state.reorder!.reorderNumberInternal),
      ));
    });

//? #########################################################################

    on<OnReorderDetailControllerChangedEvent>((event, emit) {
      emit(state.copyWith(
        reorder: state.reorder!.copyWith(
          discountPercent: state.discountPercentController.text.toMyDouble(),
          discountAmountNet: state.discountAmountGrossController.text.toMyDouble() / taxToCalc(state.reorder!.tax.taxRate),
          additionalAmountNet: state.additionalAmountGrossController.text.toMyDouble() / taxToCalc(state.reorder!.tax.taxRate),
          shippingPriceNet: state.shippingPriceGrossController.text.toMyDouble() / taxToCalc(state.reorder!.tax.taxRate),
          reorderNumberInternal: state.reorderNumberInternalController.text,
        ),
      ));
    });

//? #########################################################################

    on<OnReorderDetailControllerClearedEvent>((event, emit) {
      emit(state.copyWith(productSearchController: TextEditingController()));
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
      emit(state.copyWith(productSearchController: TextEditingController()));
      add(OnReorderDetailSetFilteredProductsEvent());
    });

//? #########################################################################

    on<OnReorderDeatilAddProductEvent>((event, emit) async {
      if (event.quantity == 0) return;
      List<ReorderProduct> newListOfReorderProducts = List.from(state.reorder!.listOfReorderProducts);

      //* Falls es kein Artikel aus der Datenbank ist
      // if (event.product.id.isEmpty) {
      //   newListOfReorderProducts.add(ReorderProduct.fromProduct(event.product, newListOfReorderProducts.length + 1, state.reorder!.tax));
      //   emit(state.copyWith(reorder: state.reorder!.copyWith(listOfReorderProducts: newListOfReorderProducts)));
      //   add(ReorderDetailSetAllProductControllersEvent());
      //   return;
      // }

      int? index;
      for (int i = 0; i < state.reorder!.listOfReorderProducts.length; i++) {
        if (event.product.id == state.reorder!.listOfReorderProducts[i].productId &&
            event.product.articleNumber == state.reorder!.listOfReorderProducts[i].articleNumber) {
          index = i;
          break;
        }
      }

      if (index != null && event.product.id.isNotEmpty) {
        newListOfReorderProducts[index] =
            newListOfReorderProducts[index].copyWith(quantity: newListOfReorderProducts[index].quantity + event.quantity);
        List<TextEditingController> newListOfQuantityControllers = List.from(state.quantityControllers);
        newListOfQuantityControllers[index] =
            TextEditingController(text: (newListOfQuantityControllers[index].text.toMyInt() + event.quantity).toString());
        emit(state.copyWith(
          reorder: state.reorder!.copyWith(listOfReorderProducts: newListOfReorderProducts),
          quantityControllers: newListOfQuantityControllers,
        ));
      } else {
        newListOfReorderProducts.add(ReorderProduct.fromProduct(event.product, newListOfReorderProducts.length, state.reorder!.tax));
        newListOfReorderProducts.last = newListOfReorderProducts.last.copyWith(quantity: event.quantity);
        emit(state.copyWith(reorder: state.reorder!.copyWith(listOfReorderProducts: newListOfReorderProducts)));
        add(ReorderDetailSetAllProductControllersEvent());
      }
    });

//? #########################################################################

    on<OnReorderDeatilRemoveProductEvent>((event, emit) async {
      List<ReorderProduct> newListOfReorderProducts = List.from(state.reorder!.listOfReorderProducts);
      newListOfReorderProducts.removeAt(event.index);

      emit(state.copyWith(reorder: state.reorder!.copyWith(listOfReorderProducts: newListOfReorderProducts)));
      add(ReorderDetailSetAllProductControllersEvent());
    });

//? #########################################################################

    on<ReorderDetailSetAllProductControllersEvent>((event, emit) {
      List<bool> isEditable = [];
      List<TextEditingController> articleNumberControllers = [];
      List<TextEditingController> articleNameControllers = [];
      List<Tax> taxRulesList = [];
      List<TextEditingController> quantityControllers = [];
      List<TextEditingController> wholesalePriceNetControllers = [];

      for (final product in state.reorder!.listOfReorderProducts) {
        if (product.isFromDatabase) {
          isEditable.add(false);
        } else {
          isEditable.add(true);
        }
        articleNumberControllers.add(TextEditingController(text: product.articleNumber));
        articleNameControllers.add(TextEditingController(text: product.name));
        taxRulesList.add(product.tax);
        quantityControllers.add(TextEditingController(text: product.quantity.toString()));
        wholesalePriceNetControllers.add(TextEditingController(text: product.wholesalePriceNet.toMyCurrencyStringToShow()));
      }
      emit(state.copyWith(
        isEditable: isEditable,
        articleNumberControllers: articleNumberControllers,
        articleNameControllers: articleNameControllers,
        quantityControllers: quantityControllers,
        wholesalePriceNetControllers: wholesalePriceNetControllers,
      ));
    });

//? #########################################################################

    on<OnReorderDetailPosControllerChangedEvent>((event, emit) {
      List<ReorderProduct> newListOfReorderProducts = List.from(state.reorder!.listOfReorderProducts);

      for (int i = 0; i < state.reorder!.listOfReorderProducts.length; i++) {
        newListOfReorderProducts[i] = newListOfReorderProducts[i].copyWith(
          articleNumber: state.articleNumberControllers[i].text,
          name: state.articleNameControllers[i].text,
          quantity: state.quantityControllers[i].text.toMyInt(),
          wholesalePriceNet: state.wholesalePriceNetControllers[i].text.toMyDouble(),
        );
      }

      emit(state.copyWith(reorder: state.reorder!.copyWith(listOfReorderProducts: newListOfReorderProducts)));
    });

//? #########################################################################
//? #########################################################################
//? #########################################################################
//? #########################################################################
  }
}
