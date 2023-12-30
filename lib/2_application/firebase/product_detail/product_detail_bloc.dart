import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/string_to_int.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:logger/logger.dart';

import '../../../1_presentation/core/functions/mixed_functions.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/product/product_image.dart';
import '../../../3_domain/entities/product/product_marketplace.dart';
import '../../../3_domain/entities/reorder/supplier.dart';
import '../../../3_domain/entities/settings/main_settings.dart';
import '../../../3_domain/entities/statistic/stat_product.dart';
import '../../../3_domain/repositories/firebase/main_settings_respository.dart';
import '../../../3_domain/repositories/firebase/product_repository.dart';
import '../../../3_domain/repositories/firebase/stat_product_repository.dart';
import '../../../3_domain/repositories/firebase/supplier_repository.dart';
import '../../../3_domain/repositories/marketplace/marketplace_edit_repository.dart';
import '../../../core/firebase_failures.dart';
import '../../../core/presta_failure.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

final logger = Logger();

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductRepository productRepository;
  final MarketplaceEditRepository marketplaceEditRepository;
  final MainSettingsRepository mainSettingsRepository;
  final SupplierRepository supplierRepository;
  final StatProductRepository statProductRepository;

  ProductDetailBloc({
    required this.productRepository,
    required this.marketplaceEditRepository,
    required this.mainSettingsRepository,
    required this.supplierRepository,
    required this.statProductRepository,
  }) : super(ProductDetailState.initial()) {
//? ###########################################################################################################################

    on<SetProductDetailStatesToInitialEvent>((event, emit) {
      emit(ProductDetailState.initial());
    });

//? ###########################################################################################################################

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

//? ###########################################################################################################################

    on<SetProductEvent>((event, emit) async {
      emit(state.copyWith(product: event.product));
      if (event.loadStatProduct) add(OnProductGetStatProductsEvent());
    });

//? ###########################################################################################################################

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

//? ###########################################################################################################################

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

//? ###########################################################################################################################

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

//? ###########################################################################################################################

    on<OnProductShowDescriptionChangedEvent>((event, emit) {
      emit(state.copyWith(showHtmlTexts: !state.showHtmlTexts));
    });

//? ###########################################################################################################################

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
    });

//? ###########################################################################################################################

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

    on<UpdateProductEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductOnUpdate: true));

      bool isUpdateInFirestoreSucceeded = false;
      final failureOrSuccess = await productRepository.updateProduct(state.product!);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (unit) {
          emit(state.copyWith(firebaseFailure: null, isAnyFailure: false));
          isUpdateInFirestoreSucceeded = true;
        },
      );

      if (isUpdateInFirestoreSucceeded) {
        add(OnEditProductInPresta(product: state.product!));
      } else {
        emit(state.copyWith(
          isLoadingProductOnUpdate: false,
          fosProductOnUpdateOption: optionOf(failureOrSuccess),
        ));
        emit(state.copyWith(fosProductOnUpdateOption: none()));
      }
    });

//? ###########################################################################################################################

    on<OnProductIsActiveChangedEvent>((event, emit) {
      emit(state.copyWith(product: state.product!.copyWith(isActive: !state.product!.isActive)));
    });

//? ###########################################################################################################################

    on<RemoveSelectedProductImages>((event, emit) async {
      emit(state.copyWith(isLoadingProductOnUpdateImages: true));

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
        },
      );

      emit(state.copyWith(
        isLoadingProductOnUpdateImages: false,
        fosProductOnUpdateImagesOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosProductOnUpdateImagesOption: none()));
    });

//? ###########################################################################################################################

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

//? ###########################################################################################################################

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

//? ###########################################################################################################################

    on<OnProductSetSupplierEvent>((event, emit) async {
      emit(state.copyWith(product: state.product!.copyWith(supplier: event.supplierName)));
    });

//? ###########################################################################################################################

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

//? ###########################################################################################################################

    on<OnAllProdcutImagesSelectedEvent>((event, emit) async {
      List<ProductImage> selectedProductImages = switch (event.value) {
        true => List.from(state.listOfProductImages),
        false => [],
      };

      emit(state.copyWith(selectedProductImages: selectedProductImages, isSelectedAllImages: event.value));
    });

//? ###########################################################################################################################

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

//? ###########################################################################################################################

    on<OnUpdateProductMarketplaceEvent>((event, emit) {
      List<ProductMarketplace> updatedList = List.from(state.product!.productMarketplaces);
      final index = updatedList.indexWhere((e) => e.idMarketplace == event.productMarketplace.idMarketplace);

      if (index != -1) {
        updatedList[index] = event.productMarketplace;
        emit(state.copyWith(product: state.product!.copyWith(productMarketplaces: updatedList)));
      }
    });

//? ###########################################################################################################################

    on<OnProductGetStatProductsEvent>((event, emit) async {
      emit(state.copyWith(isLoadingStatProductsOnObserve: true));

      final fosSettings = await statProductRepository.getStatProductsOfProductLast13(state.product!.id);
      fosSettings.fold(
        (failure) => emit(state.copyWith(firebaseFailureChart: failure)),
        (statProducts) =>
            emit(state.copyWith(listOfStatProducts: statProducts.isEmpty ? [StatProduct.empty()] : statProducts, firebaseFailureChart: null)),
      );

      emit(state.copyWith(isLoadingStatProductsOnObserve: false));
    });

//? ###########################################################################################################################

    on<OnProductChangeChartModeEvent>((event, emit) async {
      emit(state.copyWith(isShowingSalesVolumeOnChart: !state.isShowingSalesVolumeOnChart));
    });

//? ###########################################################################################################################

    on<OnEditProductInPresta>((event, emit) async {
      bool isSuccessfull = true;
      final failureOrSuccess = await marketplaceEditRepository.editProdcutPresta(event.product, null);
      failureOrSuccess.fold(
        (failure) => isSuccessfull = false, // TODO: handle Presta Failure
        (unit) => isSuccessfull = true,
      );

      if (isSuccessfull && state.isProductImagesEdited) {
        add(UploadProductImageToPrestaEvent());
      } else {
        emit(state.copyWith(
          isLoadingProductOnUpdate: false,
          fosProductOnUpdateOption: optionOf(right(unit)),
          fosProductOnUpdateInMarketplaceOption: optionOf(failureOrSuccess),
        ));
        emit(state.copyWith(fosProductOnUpdateOption: none(), fosProductOnUpdateInMarketplaceOption: none()));
      }
    });

//? ###########################################################################################################################

    on<UploadProductImageToPrestaEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductOnUploadImages: true));

      final failureOrSuccess = await marketplaceEditRepository.uploadProductImages(state.product!, state.listOfProductImages);
      failureOrSuccess.fold(
        (failure) => null, // TODO: handle Presta Failure
        (unit) => null,
      );

      emit(state.copyWith(
        isLoadingProductOnUpdate: false,
        fosProductOnUpdateOption: optionOf(right(unit)),
        isLoadingProductOnUploadImages: false,
        fosProductOnUploadImagesInMarketplaceOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(
        fosProductOnUpdateOption: none(),
        fosProductOnUploadImagesInMarketplaceOption: none(),
      ));
    });

//? ###########################################################################################################################
//? ###########################################################################################################################
//? ###########################################################################################################################
//? ###########################################################################################################################
  }
}
