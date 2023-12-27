import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/string_to_int.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:cezeri_commerce/1_presentation/core/functions/mixed_functions.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cezeri_commerce/core/presta_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:logger/logger.dart';

import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/product/product_image.dart';
import '../../../3_domain/entities/reorder/supplier.dart';
import '../../../3_domain/entities/settings/main_settings.dart';
import '../../../3_domain/entities/statistic/stat_product.dart';
import '../../../3_domain/entities_presta/product_presta.dart';
import '../../../3_domain/repositories/firebase/main_settings_respository.dart';
import '../../../3_domain/repositories/firebase/product_repository.dart';
import '../../../3_domain/repositories/firebase/stat_product_repository.dart';
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
  final StatProductRepository statProductRepository;

  ProductBloc({
    required this.productRepository,
    required this.productEditRepository,
    required this.mainSettingsRepository,
    required this.supplierRepository,
    required this.statProductRepository,
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

      final failureOrSuccess = await productRepository.getListOfProducts();
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
      emit(state.copyWith(isLoadingProductOnObserve: true));

      if (state.mainSettings == null) {
        final fosSettings = await mainSettingsRepository.getSettings();
        fosSettings.fold(
          (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
          (settings) => emit(state.copyWith(mainSettings: settings, firebaseFailure: null, isAnyFailure: false)),
        );
      }

      final failureOrSuccess = await productRepository.getProduct(event.id);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (product) {
          emit(state.copyWith(product: product, firebaseFailure: null, isAnyFailure: false));
          add(SetProductControllerEvent(product: product));
          add(OnProductGetStatProductsEvent());
        },
      );

      emit(state.copyWith(
        isLoadingProductOnObserve: false,
        fosProductOnObserveOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosProductOnObserveOption: none()));
    });

    on<SetProductControllerEvent>((event, emit) async {
      emit(state.copyWith(
        articleNumberController: TextEditingController(text: event.product.articleNumber),
        eanController: TextEditingController(text: event.product.ean),
        nameController: TextEditingController(text: event.product.name),
        wholesalePriceController: TextEditingController(text: event.product.wholesalePrice.toMyCurrencyStringToShow()),
        supplierArticleNumberController: TextEditingController(text: event.product.supplierArticleNumber),
        manufacturerController: TextEditingController(text: event.product.manufacturer),
        minimumStockController: TextEditingController(text: event.product.minimumStock.toString()),
        minimumReorderQuantityController: TextEditingController(text: event.product.minimumReorderQuantity.toString()),
        packagingUnitOnReorderController: TextEditingController(text: event.product.packagingUnitOnReorder.toString()),
        netPriceController: TextEditingController(text: event.product.netPrice.toMyCurrencyStringToShow()),
        grossPriceController: TextEditingController(text: event.product.grossPrice.toMyCurrencyStringToShow()),
        recommendedRetailPriceController: TextEditingController(text: event.product.recommendedRetailPrice.toMyCurrencyStringToShow()),
        unityController: TextEditingController(text: event.product.unity),
        unitPriceController: TextEditingController(text: event.product.unitPrice.toMyCurrencyStringToShow()),
        weightController: TextEditingController(text: event.product.weight.toMyCurrencyStringToShow()),
        widthController: TextEditingController(text: event.product.width.toMyCurrencyStringToShow()),
        heightController: TextEditingController(text: event.product.height.toMyCurrencyStringToShow()),
        depthController: TextEditingController(text: event.product.depth.toMyCurrencyStringToShow()),
        listOfProductImages: List.from(event.product.listOfProductImages),
        selectedProductImages: [],
        isSelectedAllImages: false,
      ));
    });

//? #########################################################################

    on<GetProductByEanEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductOnObserve: true));

      final failureOrSuccess = await productRepository.getProductByEan(event.ean);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (product) => emit(state.copyWith(product: product, firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingProductOnObserve: false,
        fosProductOnObserveOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosProductOnObserveOption: none()));
    });

//? #########################################################################

    on<CreateProductEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductOnCreate: true));

      final failureOrSuccess = await productRepository.createProduct(event.product, event.productPresta);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (unit) => emit(state.copyWith(firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingProductOnCreate: false,
        fosProductOnCreateOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosProductOnCreateOption: none()));
    });

//? #########################################################################

    on<OnProductControllerChangedEvent>((event, emit) {
      emit(state.copyWith(
        product: state.product!.copyWith(
          articleNumber: state.articleNumberController.text,
          ean: state.eanController.text,
          name: state.nameController.text,
          wholesalePrice: state.wholesalePriceController.text.toMyDouble(),
          supplierArticleNumber: state.supplierArticleNumberController.text,
          manufacturer: state.manufacturerController.text,
          minimumStock: state.minimumStockController.text.toMyInt(),
          minimumReorderQuantity: state.minimumReorderQuantityController.text.toMyInt(),
          packagingUnitOnReorder: state.packagingUnitOnReorderController.text.toMyInt(),
          netPrice: state.netPriceController.text.toMyDouble(),
          grossPrice: state.grossPriceController.text.toMyDouble(),
          recommendedRetailPrice: state.recommendedRetailPriceController.text.toMyDouble(),
          unity: state.unityController.text,
          unitPrice: state.unitPriceController.text.toMyDouble(),
          weight: state.weightController.text.toMyDouble(),
          width: state.widthController.text.toMyDouble(),
          height: state.heightController.text.toMyDouble(),
          depth: state.depthController.text.toMyDouble(),
        ),
      ));
    });

//? #########################################################################

    on<OnProductSalesPriceControllerChangedEvent>((event, emit) {
      final taxRate = state.mainSettings!.taxes.firstWhere((e) => e.isDefault).taxRate;
      final netPrice = event.isNet ? state.netPriceController.text.toMyDouble() : state.grossPriceController.text.toMyDouble() / taxToCalc(taxRate);
      final grossPrice = event.isNet ? state.netPriceController.text.toMyDouble() * taxToCalc(taxRate) : state.grossPriceController.text.toMyDouble();

      emit(state.copyWith(
        product: state.product!.copyWith(
          netPrice: netPrice,
          grossPrice: grossPrice,
        ),
      ));

      if (event.isNet) {
        emit(state.copyWith(grossPriceController: TextEditingController(text: grossPrice.toMyCurrencyStringToShow())));
      } else {
        emit(state.copyWith(netPriceController: TextEditingController(text: netPrice.toMyCurrencyStringToShow())));
      }
    });

//? #########################################################################

    on<OnPoductHtmlTabValueChangedEvent>((event, emit) {
      emit(state.copyWith(htmlTabValue: event.value));
    });

//? #########################################################################

    on<OnProductShowDescriptionChangedEvent>((event, emit) {
      emit(state.copyWith(showHtmlTexts: !state.showHtmlTexts));
    });

//? #########################################################################

    on<OnProductDescriptionChangedEvent>((event, emit) {
      bool isChanged = true;
      if (state.isDescriptionSetFirstTime) isChanged = false;
      if (event.content != null && state.product != null && event.content == state.product!.description) isChanged = false;
      emit(state.copyWith(isDescriptionChanged: isChanged, isDescriptionSetFirstTime: false));
    });

//? #########################################################################

    on<OnSaveProductDescriptionEvent>((event, emit) async {
      final newDescription = await state.descriptionController.getText();
      final newDescriptionShort = await state.descriptionShortController.getText();
      emit(state.copyWith(
          isDescriptionChanged: false,
          product: state.product!.copyWith(
            description: newDescription,
            descriptionShort: newDescriptionShort,
          ),
          showHtmlTexts: false));
    } );

//? #########################################################################

    on<UpdateProductEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductOnUpdate: true));

      bool isUpdateInFirestoreSucceeded = false;
      final failureOrSuccess = await productRepository.updateProduct(state.product!);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (unit) {
          final indexAll = state.listOfAllProducts!.indexWhere((e) => e.id == state.product!.id);
          List<Product> updatedListOfAll = List.from(state.listOfAllProducts!);
          if (indexAll != -1) updatedListOfAll[indexAll] = state.product!;
          final indexSelected = state.selectedProducts.indexWhere((e) => e.id == state.product!.id);
          List<Product> updatedSelected = List.from(state.selectedProducts);
          if (indexSelected != -1) updatedSelected[indexSelected] = state.product!;
          emit(state.copyWith(listOfAllProducts: updatedListOfAll, selectedProducts: updatedSelected, firebaseFailure: null, isAnyFailure: false));
          isUpdateInFirestoreSucceeded = true;
        },
      );

      if (isUpdateInFirestoreSucceeded) add(OnEditProductInPresta(product: state.product!));
      add(OnSearchFieldSubmittedEvent());

      emit(state.copyWith(
        isLoadingProductOnUpdate: false,
        fosProductOnUpdateOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosProductOnUpdateOption: none()));
    });

//? #########################################################################

    on<UpdateQuantityOfProductEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductOnUpdate: true));

      final failureOrSuccess = switch (event.updateOnlyAvailableQuantity) {
        false => await productRepository.updateAllQuantityOfProductAbsolut(event.product, event.newQuantity),
        true => await productRepository.updateAvailableQuantityOfProductAbsolut(event.product, event.newQuantity)
      };
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (product) {
          List<Product> updatedProducts = List.from(state.listOfAllProducts!);
          final index = updatedProducts.indexWhere((element) => element.id == product.id);
          updatedProducts[index] = product;

          emit(state.copyWith(listOfAllProducts: updatedProducts, firebaseFailure: null, isAnyFailure: false));
          add(OnSearchFieldSubmittedEvent());
          add(OnEditQuantityInMarketplacesEvent(product: event.product, newQuantity: event.newQuantity));
        },
      );

      emit(state.copyWith(
        isLoadingProductOnUpdate: false,
        fosProductOnUpdateQuantityOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosProductOnUpdateQuantityOption: none()));
    });

// * #################################################################################################################################
// * StatProducts Chart

//? #########################################################################

    on<OnProductGetStatProductsEvent>((event, emit) async {
      emit(state.copyWith(isLoadingStatProductsOnObserve: true));

      final fosSettings = await statProductRepository.getStatProductsOfProductLast13(state.product!.id);
      fosSettings.fold(
        (failure) => emit(state.copyWith(firebaseFailureChart: failure)),
        (statProducts) => emit(state.copyWith(listOfStatProducts: statProducts, firebaseFailureChart: null)),
      );

      final failureOrSuccess = await productRepository.getListOfProducts();
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (listOfProduct) {
          emit(state.copyWith(listOfAllProducts: listOfProduct, selectedProducts: [], firebaseFailure: null, isAnyFailure: false));
          add(OnSearchFieldSubmittedEvent());
        },
      );

      emit(state.copyWith(isLoadingStatProductsOnObserve: false));
    });

//? #########################################################################

    on<OnProductChangeChartModeEvent>((event, emit) async {
      emit(state.copyWith(isShowingSalesVolumeOnChart: !state.isShowingSalesVolumeOnChart));
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

    on<OnPickNewProductPictureEvent>((event, emit) async {
      List<File> imageFiles = [];
      try {
        final FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
        if (result == null) return;
        logger.i('Neues Artikelbild erfolgreich gepickt');
        for (final image in result.files) {
          imageFiles.add(File(image.path!));
        }
      } on PlatformException {
        logger.e('Fehler beim auswählen des Produktbildes');
      }

      if (imageFiles.isEmpty) return;
      emit(state.copyWith(isLoadingProductOnUpdateImages: true));

      bool isUpdateInFirestoreSucceeded = false;
      final failureOrSuccess = await productRepository.updateProductAddImages(state.product!, imageFiles);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (updatedProduct) {
          emit(state.copyWith(
            listOfProductImages: updatedProduct.listOfProductImages,
            product: updatedProduct,
            isProductImagesEdited: true,
            firebaseFailure: null,
            isAnyFailure: false,
          ));
          isUpdateInFirestoreSucceeded = true;
        },
      );

      // if (isUpdateInFirestoreSucceeded) add(OnEditProductInPresta(product: state.product!));

      emit(state.copyWith(
        isLoadingProductOnUpdateImages: false,
        fosProductOnUpdateImagesOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosProductOnUpdateImagesOption: none()));
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

    on<OnProductSetSupplierEvent>((event, emit) async {
      emit(state.copyWith(product: state.product!.copyWith(supplier: event.supplierName)));
    });

//? #########################################################################

    on<SetProductsWidthSearchEvent>((event, emit) async {
      emit(state.copyWith(isWidthSearchActive: event.value));
      add(OnSearchFieldSubmittedEvent());
    });

//? #########################################################################

    on<OnProductImageSelectedEvent>((event, emit) async {
      List<ProductImage> selectedProductImages = List.from(state.selectedProductImages);
      if (selectedProductImages.any((e) => e.fileUrl == event.image.fileUrl)) {
        selectedProductImages.removeWhere((e) => e.fileUrl == event.image.fileUrl);
      } else {
        selectedProductImages.add(event.image);
      }

      final isSelectedAllImages = selectedProductImages.length == state.selectedProductImages.length;

      emit(state.copyWith(selectedProductImages: selectedProductImages, isSelectedAllImages: isSelectedAllImages));
    });

//? #########################################################################

    on<OnAllProdcutImagesSelectedEvent>((event, emit) async {
      List<ProductImage> selectedProductImages = switch (event.value) {
        true => List.from(state.listOfProductImages),
        false => [],
      };

      emit(state.copyWith(selectedProductImages: selectedProductImages, isSelectedAllImages: event.value));
    });

//? #########################################################################

    on<RemoveSelectedProductImages>((event, emit) async {
      emit(state.copyWith(isLoadingProductOnUpdateImages: true));

      bool isUpdateInFirestoreSucceeded = false;
      final failureOrSuccess = await productRepository.updateProductRemoveImages(state.product!, state.selectedProductImages);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (updatedProduct) {
          emit(state.copyWith(
            listOfProductImages: updatedProduct.listOfProductImages,
            product: updatedProduct,
            isProductImagesEdited: true,
            firebaseFailure: null,
            isAnyFailure: false,
          ));
          isUpdateInFirestoreSucceeded = true;
        },
      );

      // if (isUpdateInFirestoreSucceeded) add(OnEditProductInPresta(product: state.product!));

      emit(state.copyWith(
        isLoadingProductOnUpdateImages: false,
        fosProductOnUpdateImagesOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosProductOnUpdateImagesOption: none()));
    });

    // emit(state.copyWith(selectedProductImages: selectedProductImages, isSelectedAllImages: event.value));

//? #########################################################################

    on<OnReorderProductImagesEvent>((event, emit) async {
      List<ProductImage> listOfProductImages = List.from(state.listOfProductImages);

      int newIndex = event.newIndex;
      int oldIndex = event.oldIndex;
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = listOfProductImages.removeAt(oldIndex);
      listOfProductImages.insert(newIndex, item);

      for (int i = 0; i < listOfProductImages.length; i++) {
        listOfProductImages[i] = listOfProductImages[i].copyWith(sortId: i + 1, isDefault: i == 0 ? true : false);
      }

      emit(state.copyWith(
        listOfProductImages: listOfProductImages,
        isProductImagesEdited: true,
        product: state.product!.copyWith(listOfProductImages: listOfProductImages),
      ));
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
      emit(state.copyWith(fosProductOnUpdateOption: none()));
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

      if (state.isProductImagesEdited) add(UploadProductImageToPrestaEvent());
    });

    on<UploadProductImageToPrestaEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductOnUploadImages: true));

      final failureOrSuccess = await productEditRepository.uploadProductImages(state.product!, state.listOfProductImages);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith()), // TODO: handle Presta Failure
        (unit) => emit(state.copyWith(firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingProductOnUploadImages: false,
        fosProductOnUploadImagesOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosProductOnUploadImagesOption: none()));
    });
  }
}
