import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cezeri_commerce/core/presta_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/reorder/supplier.dart';
import '../../../3_domain/entities/settings/main_settings.dart';
import '../../../3_domain/repositories/firebase/main_settings_respository.dart';
import '../../../3_domain/repositories/firebase/product_repository.dart';
import '../../../3_domain/repositories/firebase/supplier_repository.dart';
import '../../../3_domain/repositories/marketplace/marketplace_edit_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

final logger = Logger();

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  final MarketplaceEditRepository productEditRepository;
  final MainSettingsRepository mainSettingsRepository;
  final SupplierRepository supplierRepository;

  ProductBloc({
    required this.productRepository,
    required this.productEditRepository,
    required this.mainSettingsRepository,
    required this.supplierRepository,
  }) : super(ProductState.initial()) {
//? #########################################################################

    on<SetProductStateToInitialEvent>((event, emit) {
      emit(ProductState.initial());
    });

//? #########################################################################

    on<GetAllProductsEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductsOnObserve: true));

      final fosSettings = await mainSettingsRepository.getSettings();
      fosSettings.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (settings) => emit(state.copyWith(mainSettings: settings, firebaseFailure: null, isAnyFailure: false)),
      );

      final failureOrSuccess = await productRepository.getListOfProducts(false);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (listOfProduct) {
          emit(state.copyWith(listOfAllProducts: listOfProduct, selectedProducts: [], firebaseFailure: null, isAnyFailure: false));
          add(OnSearchFieldSubmittedEvent());
        },
      );

      emit(state.copyWith(
        isLoadingProductsOnObserve: false,
        fosProductsOnObserveOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosProductsOnObserveOption: none()));
    });

//? #########################################################################

    on<GetProductEvent>((event, emit) async {
      final failureOrSuccess = await productRepository.getProduct(event.id);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (product) {
          final indexAll = state.listOfAllProducts!.indexWhere((e) => e.id == product.id);
          List<Product> updatedListOfAll = List.from(state.listOfAllProducts!);
          if (indexAll != -1) updatedListOfAll[indexAll] = product;
          final indexSelected = state.selectedProducts.indexWhere((e) => e.id == product.id);
          List<Product> updatedSelected = List.from(state.selectedProducts);
          if (indexSelected != -1) updatedSelected[indexSelected] = product;
          emit(state.copyWith(listOfAllProducts: updatedListOfAll, selectedProducts: updatedSelected, firebaseFailure: null, isAnyFailure: false));
        },
      );
    });

//? #########################################################################

    on<UpdateQuantityOfProductEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductOnUpdateQuantity: true));

      final failureOrSuccess = switch (event.updateOnlyAvailableQuantity) {
        false => await productRepository.updateAllQuantityOfProductAbsolut(event.product, event.newQuantity),
        true => await productRepository.updateAvailableQuantityOfProductAbsolut(event.product, event.newQuantity)
      };
      bool isSuccess = true;
      failureOrSuccess.fold(
        (failure) {
          isSuccess = false;
          emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true));
        },
        (product) {
          List<Product> updatedProducts = List.from(state.listOfAllProducts!);
          final index = updatedProducts.indexWhere((element) => element.id == product.id);
          updatedProducts[index] = product;

          emit(state.copyWith(listOfAllProducts: updatedProducts, firebaseFailure: null, isAnyFailure: false));
          add(OnSearchFieldSubmittedEvent());
        },
      );

      if (isSuccess) {
        final fosPresta = await productEditRepository.setProdcutPrestaQuantity(event.product, event.newQuantity, null);
        failureOrSuccess.fold(
          (failure) => emit(state.copyWith()), // TODO: handle Presta Failure
          (unit) => emit(state.copyWith(firebaseFailure: null, isAnyFailure: false)),
        );

        emit(state.copyWith(
          isLoadingProductOnUpdateQuantity: false,
          fosProductOnUpdateQuantityOption: optionOf(failureOrSuccess),
          fosProductOnEditQuantityPrestaOption: optionOf(fosPresta),
        ));
        emit(state.copyWith(fosProductOnEditQuantityPrestaOption: none()));
        emit(state.copyWith(fosProductOnUpdateQuantityOption: none()));
        return;
      }

      emit(state.copyWith(
        isLoadingProductOnUpdateQuantity: false,
        fosProductOnUpdateQuantityOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosProductOnUpdateQuantityOption: none()));
    });

// * #################################################################################################################################
// * Massenbearbeitung

//? #########################################################################

    on<ProductsMassEditingPurchaceUpdatedEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductOnMassEditing: true, listOfNotUpdatedProductsOnMassEditing: []));

      bool isFosFirestoreSuccess = true;
      bool isFosMarketplaceSuccess = true;
      List<Product> listOfNotUpdatedProductsOnMassEditing = [];

      for (final product in state.selectedProducts) {
        final updatedProduct = product.copyWith(
          wholesalePrice: event.isWholesalePriceSelected ? event.wholesalePrice : product.wholesalePrice,
          manufacturer: event.isManufacturerSelected ? event.manufacturer : product.manufacturer,
          supplier: event.isSupplierSelected ? event.supplier.company : product.supplier,
          supplierNumber: event.isSupplierSelected ? event.supplier.id : product.supplierNumber,
          minimumReorderQuantity: event.isMinimumReorderQuantitySelected ? event.minimumReorderQuantity : product.minimumReorderQuantity,
          packagingUnitOnReorder: event.isPackagingUnitOnReorderSelected ? event.packagingUnitOnReorder : product.packagingUnitOnReorder,
          minimumStock: event.isMinimumStockSelected ? event.minimumStock : product.minimumStock,
        );
        //* Update in Firestore & States of Bloc
        final failureOrSuccess = await productRepository.updateProduct(updatedProduct);
        failureOrSuccess.fold(
          (failure) {
            emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true));
            listOfNotUpdatedProductsOnMassEditing.add(updatedProduct);
            isFosFirestoreSuccess = false;
          },
          (unit) {
            final indexAll = state.listOfAllProducts!.indexWhere((e) => e.id == updatedProduct.id);
            List<Product> updatedListOfAll = List.from(state.listOfAllProducts!);
            if (indexAll != -1) updatedListOfAll[indexAll] = updatedProduct;
            final indexSelected = state.selectedProducts.indexWhere((e) => e.id == updatedProduct.id);
            List<Product> updatedSelected = List.from(state.selectedProducts);
            if (indexSelected != -1) updatedSelected[indexSelected] = updatedProduct;
            emit(state.copyWith(listOfAllProducts: updatedListOfAll, selectedProducts: updatedSelected, firebaseFailure: null, isAnyFailure: false));
          },
        );

        //* Update in Marktplätzen
        final fosMarketplace = await productEditRepository.editProdcutPresta(updatedProduct, event.selectedMarketplaces);
        failureOrSuccess.fold(
          (failure) => isFosMarketplaceSuccess = false, // TODO: handle Presta Failure
          (unit) => emit(state.copyWith(firebaseFailure: null, isAnyFailure: false)),
        );

        emit(state.copyWith(fosProductOnEditQuantityPrestaOption: optionOf(fosMarketplace)));
      }

      if (isFosFirestoreSuccess) add(OnSearchFieldSubmittedEvent());

      emit(state.copyWith(
          isLoadingProductOnMassEditing: false,
          listOfNotUpdatedProductsOnMassEditing: listOfNotUpdatedProductsOnMassEditing,
          fosMassEditProductsOption: isFosFirestoreSuccess ? some(right(unit)) : some(left(GeneralFailure())),
          fosProductOnEditQuantityPrestaOption: isFosMarketplaceSuccess ? some(right(unit)) : some(left(PrestaGeneralFailure()))));
      emit(state.copyWith(
        fosMassEditProductsOption: none(),
        fosProductOnEditQuantityPrestaOption: none(),
      ));
    });

//? #########################################################################

    on<ProductsMassEditingWeightAndDimensionsUpdatedEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductOnMassEditing: true, listOfNotUpdatedProductsOnMassEditing: []));

      bool isFosFirestoreSuccess = true;
      bool isFosMarketplaceSuccess = true;
      List<Product> listOfNotUpdatedProductsOnMassEditing = [];

      for (final product in state.selectedProducts) {
        final updatedProduct = product.copyWith(
          weight: event.isWeightSelected ? event.weight : product.weight,
          height: event.isHeightSelected ? event.height : product.height,
          depth: event.isDepthSelected ? event.depth : product.depth,
          width: event.isWidthSelected ? event.width : product.width,
        );
        //* Update in Firestore & States of Bloc
        final failureOrSuccess = await productRepository.updateProduct(updatedProduct);
        failureOrSuccess.fold(
          (failure) {
            emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true));
            listOfNotUpdatedProductsOnMassEditing.add(updatedProduct);
            isFosFirestoreSuccess = false;
          },
          (unit) {
            final indexAll = state.listOfAllProducts!.indexWhere((e) => e.id == updatedProduct.id);
            List<Product> updatedListOfAll = List.from(state.listOfAllProducts!);
            if (indexAll != -1) updatedListOfAll[indexAll] = updatedProduct;
            final indexSelected = state.selectedProducts.indexWhere((e) => e.id == updatedProduct.id);
            List<Product> updatedSelected = List.from(state.selectedProducts);
            if (indexSelected != -1) updatedSelected[indexSelected] = updatedProduct;
            emit(state.copyWith(listOfAllProducts: updatedListOfAll, selectedProducts: updatedSelected, firebaseFailure: null, isAnyFailure: false));
          },
        );

        //* Update in Marktplätzen
        final fosMarketplace = await productEditRepository.editProdcutPresta(updatedProduct, event.selectedMarketplaces);
        failureOrSuccess.fold(
          (failure) => isFosMarketplaceSuccess = false, // TODO: handle Presta Failure
          (unit) => emit(state.copyWith(firebaseFailure: null, isAnyFailure: false)),
        );

        emit(state.copyWith(fosProductOnEditQuantityPrestaOption: optionOf(fosMarketplace)));
      }

      if (isFosFirestoreSuccess) add(OnSearchFieldSubmittedEvent());

      emit(state.copyWith(
          isLoadingProductOnMassEditing: false,
          listOfNotUpdatedProductsOnMassEditing: listOfNotUpdatedProductsOnMassEditing,
          fosMassEditProductsOption: isFosFirestoreSuccess ? some(right(unit)) : some(left(GeneralFailure())),
          fosProductOnEditQuantityPrestaOption: isFosMarketplaceSuccess ? some(right(unit)) : some(left(PrestaGeneralFailure()))));
      emit(state.copyWith(
        fosMassEditProductsOption: none(),
        fosProductOnEditQuantityPrestaOption: none(),
      ));
    });

//? #########################################################################

    on<DeleteSelectedProductsEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductOnDelete: true));

      final failureOrSuccess = await productRepository.deleteListOfProducts(event.selectedProducts);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (unit) {
          List<Product> products = List.from(state.listOfFilteredProducts!);
          for (final product in event.selectedProducts) {
            products.removeWhere((element) => element.id == product.id);
          }
          emit(state.copyWith(listOfFilteredProducts: products, selectedProducts: [], firebaseFailure: null, isAnyFailure: false));
        },
      );

      emit(state.copyWith(
        isLoadingProductOnDelete: false,
        fosProductOnDeleteOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosProductOnDeleteOption: none()));
    });

//? #########################################################################

    on<OnProductSearchControllerClearedEvent>((event, emit) async {
      emit(state.copyWith(productSearchController: TextEditingController()));

      add(OnSearchFieldSubmittedEvent());
    });

    on<OnSearchFieldSubmittedEvent>((event, emit) async {
      final widthSearchText = state.productSearchController.text.toLowerCase().split(' ');

      List<Product>? listOfProducts = switch (state.productSearchController.text) {
        '' => state.listOfAllProducts,
        (_) => switch (state.isWidthSearchActive) {
            true => state.listOfAllProducts!
                .where((e) => widthSearchText.every((entry) =>
                    e.name.toLowerCase().contains(entry) ||
                    e.ean.toLowerCase().contains(entry) ||
                    e.supplier.toLowerCase().contains(entry) ||
                    e.articleNumber.toLowerCase().contains(entry)))
                .toList(),
            _ => state.listOfAllProducts!
                .where((element) =>
                    element.name.toLowerCase().contains(state.productSearchController.text.toLowerCase()) ||
                    element.ean.toLowerCase().contains(state.productSearchController.text.toLowerCase()) ||
                    element.supplier.toLowerCase().contains(state.productSearchController.text.toLowerCase()) ||
                    element.articleNumber.toLowerCase().contains(state.productSearchController.text.toLowerCase()))
                .toList()
          },
      };

      if (listOfProducts != null && listOfProducts.isNotEmpty) listOfProducts.sort((a, b) => a.name.compareTo(b.name));
      // if (listOfProducts != null && listOfProducts.length > 20) listOfProducts = listOfProducts.sublist(0, 20);

      emit(state.copyWith(listOfFilteredProducts: listOfProducts));
    });

//? #########################################################################

    on<OnProductIsSelectedAllChangedEvent>((event, emit) async {
      List<Product> products = [];
      bool isSelectedAll = false;
      if (event.isSelected) {
        isSelectedAll = true;
        products = List.from(state.listOfFilteredProducts!);
      }
      emit(state.copyWith(isSelectedAllProducts: isSelectedAll, selectedProducts: products));
    });

//? #########################################################################

    on<OnProductSelectedEvent>((event, emit) async {
      List<Product> products = List.from(state.selectedProducts);
      if (products.any((e) => e.id == event.product.id)) {
        products.removeWhere((e) => e.id == event.product.id);
      } else {
        products.add(event.product);
      }
      emit(state.copyWith(
          isSelectedAllProducts: state.isSelectedAllProducts && products.length < state.selectedProducts.length ? false : state.isSelectedAllProducts,
          selectedProducts: products));
    });

//? #########################################################################

    on<OnProductGetSuppliersEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductSuppliersOnObseve: true));

      final failureOrSuccess = await supplierRepository.getListOfSuppliers();
      failureOrSuccess.fold(
        (failure) => null,
        (listOfSuppliers) => emit(state.copyWith(listOfSuppliers: listOfSuppliers, firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingProductSuppliersOnObseve: false,
        fosProductSuppliersOnObserveOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosProductSuppliersOnObserveOption: none()));
    });

//? #########################################################################

    on<SetProductsWidthSearchEvent>((event, emit) async {
      emit(state.copyWith(isWidthSearchActive: event.value));
      add(OnSearchFieldSubmittedEvent());
    });

//? #########################################################################

    on<SetProductIsLoadingPdfEvent>((event, emit) async {
      emit(state.copyWith(isLoadingPdf: event.value));
    });

//? #########################################################################

    on<MassEditActivateProductMarketplaceEvent>((event, emit) async {
      emit(state.copyWith(isLoadingOnMassEditActivateProductMarketplace: true));

      final failureOrSuccess = await productRepository.activateMarketplaceInSelectedProducts(state.selectedProducts, event.marketplace);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (unit) => emit(state.copyWith(firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingOnMassEditActivateProductMarketplace: false,
        fosMassEditActivateProductMarketplaceOption: optionOf(failureOrSuccess),
      ));
      // emit(state.copyWith(fosProductOnUpdateOption: none()));
    });

//? #########################################################################
// *#################################################################
// * Prestashop events
//? #########################################################################

    on<OnEditQuantityInMarketplacesEvent>((event, emit) async {
      // TODO: add isLoading
      final failureOrSuccess = await productEditRepository.setProdcutPrestaQuantity(event.product, event.newQuantity, null);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith()), // TODO: handle Presta Failure
        (unit) => emit(state.copyWith(firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        fosProductOnEditQuantityPrestaOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosProductOnEditQuantityPrestaOption: none()));
    });

    on<OnEditProductInPresta>((event, emit) async {
      // TODO: add isLoading
      final failureOrSuccess = await productEditRepository.editProdcutPresta(event.product, null);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith()), // TODO: handle Presta Failure
        (unit) => emit(state.copyWith(firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(fosProductOnEditQuantityPrestaOption: optionOf(failureOrSuccess)));
      emit(state.copyWith(fosProductOnEditQuantityPrestaOption: none()));
    });
  }
}
