import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '/1_presentation/core/core.dart';
import '/3_domain/entities/marketplace/abstract_marketplace.dart';
import '/3_domain/entities/product/product.dart';
import '/3_domain/entities/product/product_id_with_quantity.dart';
import '/3_domain/entities/product/product_image.dart';
import '/3_domain/entities/product/product_marketplace.dart';
import '/3_domain/entities/product/product_presta.dart';
import '/3_domain/entities/settings/main_settings.dart';
import '/3_domain/entities/statistic/product_sales_data.dart';
import '/3_domain/entities/statistic/stat_product.dart';
import '/3_domain/repositories/marketplace/marketplace_edit_repository.dart';
import '/3_domain/repositories/marketplace/marketplace_import_repository.dart';
import '/4_infrastructur/repositories/prestashop_api/models/product_raw_presta.dart';
import '/failures/abstract_failure.dart';
import '/failures/firebase_failures.dart';
import '/failures/presta_failure.dart';
import '../../../3_domain/entities/my_file.dart';
import '../../../3_domain/entities/product/specific_price.dart';
import '../../../3_domain/repositories/database/main_settings_respository.dart';
import '../../../3_domain/repositories/database/marketplace_repository.dart';
import '../../../3_domain/repositories/database/product_repository.dart';
import '../../../3_domain/repositories/database/stat_product_repository.dart';
import '../../../3_domain/repositories/database/supplier_repository.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductRepository productRepository;
  final MarketplaceEditRepository marketplaceEditRepository;
  final MainSettingsRepository mainSettingsRepository;
  final SupplierRepository supplierRepository;
  final MarketplaceRepository marketplaceRepository;
  final StatProductRepository statProductRepository;
  final MarketplaceImportRepository marketplaceImportRepository;

  ProductDetailBloc({
    required this.productRepository,
    required this.marketplaceEditRepository,
    required this.mainSettingsRepository,
    required this.supplierRepository,
    required this.marketplaceRepository,
    required this.statProductRepository,
    required this.marketplaceImportRepository,
  }) : super(ProductDetailState.initial()) {
    on<SetProductDetailStatesToInitialEvent>(_onSetProductDetailStatesToInitial);
    on<GetProductEvent>(_onGetProduct);
    on<GetListOfProductsEvent>(_onGetListOfProducts);
    on<SetListOfProductsEvent>(_onSetListOfProducts);
    on<GetProductAfterExportNewProductToMarketplaceEvent>(_onGetProductAfterExportNewProductToMarketplace);
    on<SetProductEvent>(_onSetProduct);
    on<SetProductControllerEvent>(_onSetProductController);
    on<OnProductControllerChangedEvent>(_onProductControllerChanged);
    on<OnProductSalesPriceControllerChangedEvent>(_onProductSalesPriceControllerChanged);
    on<OnProductIsOutletChangedEvent>(_onProductIsOutletChanged);
    on<OnProductShowDescriptionChangedEvent>(_onProductShowDescriptionChanged);
    on<OnProductDescriptionChangedEvent>(_onProductDescriptionChanged);
    on<OnSaveProductDescriptionEvent>(_onSaveProductDescription);
    on<OnAddEditProductSpecificPriceEvent>(_onAddEditProductSpecificPrice);
    on<OnDeleteProductSpecificPriceEvent>(_onDeleteProductSpecificPrice);
    on<GetProductByEanEvent>(_onGetProductByEan);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<OnProductIsActiveChangedEvent>(_onProductIsActiveChanged);
    on<RemoveSelectedProductImages>(_onRemoveSelectedProductImages);
    on<OnPickNewProductPictureEvent>(_onPickNewProductPicture);
    on<OnProductSetSupplierEvent>(_onProductSetSupplier);
    on<OnProductGetMarketplacesEvent>(_onProductGetMarketplaces);
    on<OnCreateProductInMarketplaceEvent>(_onCreateProductInMarketplace);
    on<OnProductImageSelectedEvent>(_onProductImageSelected);
    on<OnAllProdcutImagesSelectedEvent>(_onAllProdcutImagesSelected);
    on<OnReorderProductImagesEvent>(_onReorderProductImages);
    on<OnUpdateProductMarketplaceEvent>(_onUpdateProductMarketplace);
    on<DeleteMarketplaceFromProductEvent>(_onDeleteMarketplaceFromProduct);
    on<OnProductSetIsSetArticleEvent>(_onProductSetIsSetArticle);
    on<OnAddProductToSetArticleEvent>(_onAddProductToSetArticle);
    on<OnSetArticleQuantityChangedEvent>(_onSetArticleQuantityChanged);
    on<OnSetProductSalesNetPriceGeneratedEvent>(_onSetProductSalesNetPriceGenerated);
    on<OnSetProductWholesalePriceGeneratedEvent>(_onSetProductWholesalePriceGenerated);
    on<OnPartOfSetProductControllerChangedEvent>(_onPartOfSetProductControllerChanged);
    on<OnPartOfSetProductControllerClearedEvent>(_onPartOfSetProductControllerCleared);
    on<OnProductGetProductsSalesDataEvent>(_onProductGetProductsSalesData);
    on<OnProductChangeChartModeEvent>(_onProductChangeChartMode);
    on<OnEditProductInPresta>(_onEditProductInPresta);
    on<UploadProductImageToPrestaEvent>(_onUploadProductImageToPresta);
  }
//? ###########################################################################################################################

  void _onSetProductDetailStatesToInitial(SetProductDetailStatesToInitialEvent event, Emitter<ProductDetailState> emit) async {
    emit(ProductDetailState.initial());
  }

//? ###########################################################################################################################

  Future<void> _onGetProduct(GetProductEvent event, Emitter<ProductDetailState> emit) async {
    emit(state.copyWith(isLoadingProductOnObserve: true));

    if (state.mainSettings == null) {
      final fosSettings = await mainSettingsRepository.getSettings();
      fosSettings.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (settings) => emit(state.copyWith(mainSettings: settings, firebaseFailure: null, isAnyFailure: false)),
      );
    }

    //* Artikel Laden
    final fosProduct = await productRepository.getProduct(event.id);
    if (fosProduct.isLeft()) emit(state.copyWith(firebaseFailure: fosProduct.getLeft(), isAnyFailure: true));
    final loadedProduct = fosProduct.getRight();

    //* Wenn Set-Artikel, die Einzelartikel davon laden
    List<Product>? listOfSetPartProducts;
    if (loadedProduct.isSetArticle && loadedProduct.listOfProductIdWithQuantity.isNotEmpty) {
      final productIds = loadedProduct.listOfProductIdWithQuantity.map((e) => e.productId).toList();
      final fosSetParts = await productRepository.getListOfProductsByIds(productIds);
      if (fosSetParts.isLeft()) emit(state.copyWith(firebaseFailure: fosSetParts.getLeft()));
      listOfSetPartProducts = fosSetParts.getRight();
    }

    add(SetProductControllerEvent(product: loadedProduct));
    add(OnProductGetProductsSalesDataEvent());

    emit(state.copyWith(
      product: loadedProduct,
      originalProduct: loadedProduct.copyWith(),
      listOfSetPartProducts: listOfSetPartProducts,
      firebaseFailure: null,
      isAnyFailure: false,
      isLoadingProductOnObserve: false,
      fosProductOnObserveOption: optionOf(fosProduct),
    ));
    emit(state.copyWith(fosProductOnObserveOption: none()));
  }

//? ###########################################################################################################################

  Future<void> _onGetListOfProducts(GetListOfProductsEvent event, Emitter<ProductDetailState> emit) async {
    emit(state.copyWith(isLoadingProductsOnObserve: true));

    if (state.mainSettings == null) {
      final fosSettings = await mainSettingsRepository.getSettings();
      fosSettings.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (settings) => emit(state.copyWith(mainSettings: settings, firebaseFailure: null, isAnyFailure: false)),
      );
    }

    final failureOrSuccess = await productRepository.getListOfProducts(true);
    failureOrSuccess.fold(
      (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
      (loadedProducts) {
        emit(state.copyWith(
          listOfAllProducts: loadedProducts,
          listOfFilteredProducts: loadedProducts,
          pageIndexNotifierSetArticles: ValueNotifier(1),
          firebaseFailure: null,
          isAnyFailure: false,
        ));
      },
    );

    emit(state.copyWith(
      isLoadingProductsOnObserve: false,
      fosProductsOnObserveOption: optionOf(failureOrSuccess),
    ));
    emit(state.copyWith(fosProductsOnObserveOption: none()));
  }

//? ###########################################################################################################################

  void _onSetListOfProducts(SetListOfProductsEvent event, Emitter<ProductDetailState> emit) async {
    emit(state.copyWith(listOfAllProducts: event.listOfProducts, listOfFilteredProducts: event.listOfProducts));
  }

//? ###########################################################################################################################

  Future<void> _onGetProductAfterExportNewProductToMarketplace(
      GetProductAfterExportNewProductToMarketplaceEvent event, Emitter<ProductDetailState> emit) async {
    add(SetProductDetailStatesToInitialEvent());

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
        add(OnProductGetProductsSalesDataEvent());
        add(OnEditProductInPresta(product: product, updateImages: true));
      },
    );

    emit(state.copyWith(
      isLoadingProductOnObserve: false,
      fosProductOnObserveOption: optionOf(failureOrSuccess),
    ));
    emit(state.copyWith(fosProductOnObserveOption: none()));
  }

//? ###########################################################################################################################

  void _onSetProduct(SetProductEvent event, Emitter<ProductDetailState> emit) {
    emit(state.copyWith(product: event.product));
    if (event.loadStatProduct) add(OnProductGetProductsSalesDataEvent());
  }

//? ###########################################################################################################################

  void _onSetProductController(SetProductControllerEvent event, Emitter<ProductDetailState> emit) {
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
  }

//? ###########################################################################################################################

  void _onProductControllerChanged(OnProductControllerChangedEvent event, Emitter<ProductDetailState> emit) {
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
  }

//? ###########################################################################################################################

  void _onProductSalesPriceControllerChanged(OnProductSalesPriceControllerChangedEvent event, Emitter<ProductDetailState> emit) {
    final taxRate = state.mainSettings!.taxes.firstWhere((e) => e.isDefault).taxRate;
    final netPrice = event.isNet ? state.netPriceController.text.toMyDouble() : state.grossPriceController.text.toMyDouble() / taxToCalc(taxRate);
    final grossPrice = event.isNet ? state.netPriceController.text.toMyDouble() * taxToCalc(taxRate) : state.grossPriceController.text.toMyDouble();

    emit(state.copyWith(product: state.product!.copyWith(netPrice: netPrice, grossPrice: grossPrice)));

    if (event.isNet) {
      emit(state.copyWith(grossPriceController: TextEditingController(text: grossPrice.toMyCurrencyStringToShow())));
    } else {
      emit(state.copyWith(netPriceController: TextEditingController(text: netPrice.toMyCurrencyStringToShow())));
    }
  }

//? ###########################################################################################################################

  void _onProductIsOutletChanged(OnProductIsOutletChangedEvent event, Emitter<ProductDetailState> emit) {
    emit(state.copyWith(product: state.product!.copyWith(isOutlet: event.value)));
  }

//? ###########################################################################################################################

  void _onProductShowDescriptionChanged(OnProductShowDescriptionChangedEvent event, Emitter<ProductDetailState> emit) {
    emit(state.copyWith(showHtmlTexts: !state.showHtmlTexts));
  }

//? ###########################################################################################################################

  void _onProductDescriptionChanged(OnProductDescriptionChangedEvent event, Emitter<ProductDetailState> emit) {
    bool isChanged = true;
    if (state.isDescriptionSetFirstTime) isChanged = false;
    if (event.content != null && state.product != null && event.content == state.product!.description) isChanged = false;
    emit(state.copyWith(isDescriptionChanged: isChanged, isDescriptionSetFirstTime: false));
  }

//? #########################################################################

  Future<void> _onSaveProductDescription(OnSaveProductDescriptionEvent event, Emitter<ProductDetailState> emit) async {
    emit(state.copyWith(
        isDescriptionChanged: false,
        product: state.product!.copyWith(
          description: event.description,
          descriptionShort: event.descriptionShort,
        ),
        showHtmlTexts: false));
  }

//? #########################################################################

  Future<void> _onAddEditProductSpecificPrice(OnAddEditProductSpecificPriceEvent event, Emitter<ProductDetailState> emit) async {
    if (state.originalProduct!.specificPrice != null) {
      print('--- BEFORE ---');
      for (final mm in state.originalProduct!.specificPrice!.listOfSpecificPriceMarketplaces) {
        print('originalMp: ${mm.marketplaceId} - ${mm.specificPriceId}');
      }
    }
    emit(state.copyWith(isSpecificPriceChanged: true, product: state.product!.copyWith(specificPrice: event.specificPrice)));
    if (state.originalProduct!.specificPrice != null) {
      print('--- AFTER ---');
      for (final mm in state.originalProduct!.specificPrice!.listOfSpecificPriceMarketplaces) {
        print('originalMp: ${mm.marketplaceId} - ${mm.specificPriceId}');
      }
    }
  }

//? #########################################################################

  Future<void> _onDeleteProductSpecificPrice(OnDeleteProductSpecificPriceEvent event, Emitter<ProductDetailState> emit) async {
    emit(state.copyWith(isSpecificPriceChanged: true, product: state.product!.copyWith(specificPrice: null, resetSpecificPrice: true)));
  }

//? ###########################################################################################################################

  Future<void> _onGetProductByEan(GetProductByEanEvent event, Emitter<ProductDetailState> emit) async {
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
  }

//? #########################################################################

  Future<void> _onUpdateProduct(UpdateProductEvent event, Emitter<ProductDetailState> emit) async {
    if (state.product == null) return;
    emit(state.copyWith(isLoadingProductOnUpdate: true));

    List<AbstractFailure> listOfAbstractFailures = [];

    final originalProduct = state.originalProduct!;

    final fos = await productRepository.updateProductAndSets(state.product!);
    if (fos.isLeft()) {
      emit(state.copyWith(
        isLoadingProductOnUpdate: false,
        fosProductOnUpdateOption: optionOf(fos),
        fosProductAbstractFailuresOption: optionOf(Left(listOfAbstractFailures)),
      ));
      emit(state.copyWith(fosProductOnUpdateOption: none(), fosProductAbstractFailuresOption: none()));
      return;
    }

    final updatedProduct = fos.getRight();

    final fosUpdateProductInMarketplace = await marketplaceEditRepository.editProdcutInMarketplace(updatedProduct, null);
    if (fosUpdateProductInMarketplace.isLeft()) listOfAbstractFailures.addAll(fosUpdateProductInMarketplace.getLeft());

    if (state.isProductImagesEdited) {
      print('---------------- PRODUCT IMAGE EDITED --------------------');
      final fosUpdateProductImagesInMarketplace = await marketplaceEditRepository.uploadProductImagesToMarketplace(
        state.product!,
        state.listOfProductImages,
      );
      if (fosUpdateProductImagesInMarketplace.isLeft()) listOfAbstractFailures.addAll(fosUpdateProductImagesInMarketplace.getLeft());
    }

    //* Wenn ein Artikelrabatt hinzugefügt wurde, oder ein bestehender bearbeitet wurde.
    //* Nur für Prestashop shops, in Shopify wird der Streichelpreis direkt beim Bearbeiten des Artikels gesetzt.
    if (state.isSpecificPriceChanged) {
      final fosUpdateProductSpecificPriceInMarketplace = await marketplaceEditRepository.updateSpecificPriceInPrestaMarketplaces(
        originalProduct,
        updatedProduct,
      );
      if (fosUpdateProductSpecificPriceInMarketplace.isLeft()) listOfAbstractFailures.addAll(fosUpdateProductSpecificPriceInMarketplace.getLeft());
    }

    emit(state.copyWith(
      isLoadingProductOnUpdate: false,
      fosProductOnUpdateOption: optionOf(fos),
      fosProductAbstractFailuresOption: optionOf(Left(listOfAbstractFailures)),
    ));
    emit(state.copyWith(fosProductOnUpdateOption: none(), fosProductAbstractFailuresOption: none()));

    add(GetProductEvent(id: state.product!.id));
  }

//? ###########################################################################################################################

  Future<void> _onProductIsActiveChanged(OnProductIsActiveChangedEvent event, Emitter<ProductDetailState> emit) async {
    emit(state.copyWith(product: state.product!.copyWith(isActive: !state.product!.isActive)));
  }

//? ###########################################################################################################################

  Future<void> _onRemoveSelectedProductImages(RemoveSelectedProductImages event, Emitter<ProductDetailState> emit) async {
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
  }

//? ###########################################################################################################################

  Future<void> _onPickNewProductPicture(OnPickNewProductPictureEvent event, Emitter<ProductDetailState> emit) async {
    emit(state.copyWith(isLoadingProductOnUpdateImages: true));

    final failureOrSuccess = await productRepository.updateProductAddImages(state.product!, event.myFiles);

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
  }

//? ###########################################################################################################################

  void _onProductSetSupplier(OnProductSetSupplierEvent event, Emitter<ProductDetailState> emit) {
    emit(state.copyWith(product: state.product!.copyWith(supplier: event.supplierName)));
  }

//? ###########################################################################################################################

  Future<void> _onProductGetMarketplaces(OnProductGetMarketplacesEvent event, Emitter<ProductDetailState> emit) async {
    emit(state.copyWith(isLoadingProductMarketplacesOnObseve: true));

    final failureOrSuccess = await marketplaceRepository.getListOfMarketplaces();
    failureOrSuccess.fold(
      (failure) => null,
      (listOfMarketplaces) {
        final notSynchronizedList = listOfMarketplaces.where((e) => !state.product!.productMarketplaces.any((f) => f.idMarketplace == e.id)).toList();
        emit(state.copyWith(listOfNotSynchronizedMarketplaces: notSynchronizedList, firebaseFailure: null, isAnyFailure: false));
      },
    );

    emit(state.copyWith(
      isLoadingProductMarketplacesOnObseve: false,
      fosProductMarketplacesOnObserveOption: optionOf(failureOrSuccess),
    ));
    emit(state.copyWith(fosProductMarketplacesOnObserveOption: none()));
  }

//? ###########################################################################################################################

  Future<void> _onCreateProductInMarketplace(OnCreateProductInMarketplaceEvent event, Emitter<ProductDetailState> emit) async {
    emit(state.copyWith(isLoadingProductOnCreateInMarketplaces: true));

    Product? anotherProductWithSameProductMarketplaceAndSameManufacturer;

    final fosAnotherProduct = await productRepository.getProductWithSameProductMarketplaceAndSameManufacturer(
      state.product!,
      event.productMarketplace,
    );
    fosAnotherProduct.fold(
      (failure) {
        switch (failure) {
          case EmptyFailure():
            {
              event.context.router.maybePop();
              showMyDialogAlert(
                context: event.context,
                title: 'Achtung',
                content:
                    'Der erste Artikel eines neuen Herstellers muss im Marktplatz angelegt werden und nach Cezeri Commerce importiert werden.\nAlle weiteren Artikel können dann über Cezeri Commerce zum Marktplatz exportiert werden.',
              );
              return;
            }
          default:
            {
              event.context.router.maybePop();
              showMyDialogAlert(
                context: event.context,
                title: 'Achtung',
                content: 'Ein Problem ist aufgetreten. Bitte versuche es später erneut, oder kontaktiere den Support.',
              );
              return;
            }
        }
      },
      (loadedProduct) => anotherProductWithSameProductMarketplaceAndSameManufacturer = loadedProduct,
    );

    if (anotherProductWithSameProductMarketplaceAndSameManufacturer == null) {
      event.context.router.maybePop();
      if (event.context.mounted) {
        showMyDialogAlert(
          context: event.context,
          title: 'Achtung',
          content: 'Ein Problem ist aufgetreten. Bitte versuche es später erneut, oder kontaktiere den Support.',
        );
      }
      return;
    }

    final productMarketplaceOfAnotherProduct = anotherProductWithSameProductMarketplaceAndSameManufacturer!.productMarketplaces
        .where((e) => e.idMarketplace == event.productMarketplace.idMarketplace)
        .firstOrNull;
    if (productMarketplaceOfAnotherProduct == null) {
      event.context.router.maybePop();
      if (!event.context.mounted) return;
      showMyDialogAlert(
        context: event.context,
        title: 'Achtung',
        content: 'Ein Problem ist aufgetreten. Bitte versuche es später erneut, oder kontaktiere den Support.',
      );
      return;
    }

    // logger.i(anotherProductWithSameProductMarketplaceAndSameManufacturer);
    // return;

    ProductRawPresta? productPresta;
    final failureOrSuccess = await marketplaceEditRepository.createProdcutInMarketplace(
      state.product!,
      event.productMarketplace,
      productMarketplaceOfAnotherProduct,
    );
    failureOrSuccess.fold(
      (failure) => null,
      (createdAndLoadedProductPresta) => productPresta = createdAndLoadedProductPresta,
    );

    if (productPresta == null) {
      emit(state.copyWith(
        isLoadingProductOnCreateInMarketplaces: false,
        fosProductOnCreateInMarketplaceOption: optionOf(left(PrestaGeneralFailure())),
      ));
      emit(state.copyWith(fosProductOnCreateInMarketplaceOption: none()));
      return;
    }

    bool isSuccess = true;

    final fosOnUpload = await marketplaceImportRepository.uploadLoadedMarketplaceProductToFirestore(
        productPresta! as ProductPresta, event.productMarketplace.idMarketplace); //TODO: Shopify
    fosOnUpload.fold(
      (failure) => isSuccess = false,
      (product) => null,
    );

    // add(OnEditProductInPresta(product: state.product!));
    // if (!state.isProductImagesEdited) add(UploadProductImageToPrestaEvent());

    emit(state.copyWith(
      isLoadingProductOnCreateInMarketplaces: false,
      fosProductOnCreateInMarketplaceOption: isSuccess ? optionOf(right(productPresta!)) : optionOf(left(PrestaGeneralFailure())),
    ));
    emit(state.copyWith(fosProductOnCreateInMarketplaceOption: none()));
  }

//? ###########################################################################################################################

  void _onProductImageSelected(OnProductImageSelectedEvent event, Emitter<ProductDetailState> emit) {
    List<ProductImage> selectedProductImages = List.from(state.selectedProductImages);
    if (selectedProductImages.any((e) => e.fileUrl == event.image.fileUrl)) {
      selectedProductImages.removeWhere((e) => e.fileUrl == event.image.fileUrl);
    } else {
      selectedProductImages.add(event.image);
    }

    final isSelectedAllImages = selectedProductImages.length == state.selectedProductImages.length;

    emit(state.copyWith(selectedProductImages: selectedProductImages, isSelectedAllImages: isSelectedAllImages));
  }

//? ###########################################################################################################################

  void _onAllProdcutImagesSelected(OnAllProdcutImagesSelectedEvent event, Emitter<ProductDetailState> emit) {
    List<ProductImage> selectedProductImages = switch (event.value) {
      true => List.from(state.listOfProductImages),
      false => [],
    };

    emit(state.copyWith(selectedProductImages: selectedProductImages, isSelectedAllImages: event.value));
  }

//? ###########################################################################################################################

  void _onReorderProductImages(OnReorderProductImagesEvent event, Emitter<ProductDetailState> emit) {
    List<ProductImage> listOfProductImages = List.from(state.listOfProductImages);

    int newIndex = event.newIndex;
    int oldIndex = event.oldIndex;

    if (newIndex > oldIndex) newIndex -= 1;

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
  }

//? ###########################################################################################################################

  void _onUpdateProductMarketplace(OnUpdateProductMarketplaceEvent event, Emitter<ProductDetailState> emit) {
    List<ProductMarketplace> updatedList = List.from(state.product!.productMarketplaces);
    final index = updatedList.indexWhere((e) => e.idMarketplace == event.productMarketplace.idMarketplace);

    if (index != -1) {
      updatedList[index] = event.productMarketplace;
      emit(state.copyWith(product: state.product!.copyWith(productMarketplaces: updatedList)));
    }
  }

//? ###########################################################################################################################

  void _onDeleteMarketplaceFromProduct(DeleteMarketplaceFromProductEvent event, Emitter<ProductDetailState> emit) {
    List<ProductMarketplace> updatedList = List.from(state.product!.productMarketplaces);
    final index = updatedList.indexWhere((e) => e.idMarketplace == event.marketplaceId);

    if (index != -1) {
      updatedList.removeAt(index);
      emit(state.copyWith(product: state.product!.copyWith(productMarketplaces: updatedList)));
    }
  }

//? ###########################################################################################################################

  void _onProductSetIsSetArticle(OnProductSetIsSetArticleEvent event, Emitter<ProductDetailState> emit) {
    emit(state.copyWith(product: state.product!.copyWith(isSetArticle: !state.product!.isSetArticle)));
  }

//? ###########################################################################################################################

  void _onAddProductToSetArticle(OnAddProductToSetArticleEvent event, Emitter<ProductDetailState> emit) {
    List<ProductIdWithQuantity> productIdsWithQuantity = List.from(state.product!.listOfProductIdWithQuantity);
    if (!productIdsWithQuantity.any((e) => e.productId == event.product.id)) {
      productIdsWithQuantity.add(ProductIdWithQuantity(productId: event.product.id, quantity: 1));
    }
    emit(state.copyWith(product: state.product!.copyWith(listOfProductIdWithQuantity: productIdsWithQuantity)));
  }

//? ###########################################################################################################################

  void _onSetArticleQuantityChanged(OnSetArticleQuantityChangedEvent event, Emitter<ProductDetailState> emit) {
    List<ProductIdWithQuantity> productIdsWithQuantity = List.from(state.product!.listOfProductIdWithQuantity);
    final index = productIdsWithQuantity.indexWhere((e) => e.productId == event.productId);
    if (productIdsWithQuantity[index].quantity == 1 && !event.isIncrease) {
      productIdsWithQuantity.removeAt(index);
    } else {
      final newQuantity = event.isIncrease ? productIdsWithQuantity[index].quantity + 1 : productIdsWithQuantity[index].quantity - 1;
      productIdsWithQuantity[index] = productIdsWithQuantity[index].copyWith(quantity: newQuantity);
    }
    emit(state.copyWith(product: state.product!.copyWith(listOfProductIdWithQuantity: productIdsWithQuantity)));
  }

//? ###########################################################################################################################

  void _onSetProductSalesNetPriceGenerated(OnSetProductSalesNetPriceGeneratedEvent event, Emitter<ProductDetailState> emit) {
    final taxRate = state.mainSettings!.taxes.firstWhere((e) => e.isDefault).taxRate;
    final listOfPartProductNetPrices = state.listOfAllProducts!
        .where((product) => state.product!.listOfProductIdWithQuantity.any((partProduct) => partProduct.productId == product.id))
        .map((e) => e.netPrice * state.product!.listOfProductIdWithQuantity.firstWhere((partProduct) => partProduct.productId == e.id).quantity)
        .toList();
    final sumOfPartProductNetPrices = listOfPartProductNetPrices.fold(0.0, (sum, item) => sum + item);
    final netPrice = sumOfPartProductNetPrices.toMyRoundedDouble();
    final grossPrice = (netPrice * taxToCalc(taxRate)).toMyRoundedDouble();

    emit(state.copyWith(
      product: state.product!.copyWith(
        netPrice: netPrice,
        grossPrice: grossPrice,
      ),
    ));

    emit(state.copyWith(
      netPriceController: TextEditingController(text: netPrice.toMyCurrencyStringToShow()),
      grossPriceController: TextEditingController(text: grossPrice.toMyCurrencyStringToShow()),
    ));
  }

//? ###########################################################################################################################

  void _onSetProductWholesalePriceGenerated(OnSetProductWholesalePriceGeneratedEvent event, Emitter<ProductDetailState> emit) {
    final listOfPartProductWholesalePrices = state.listOfAllProducts!
        .where((product) => state.product!.listOfProductIdWithQuantity.any((partProduct) => partProduct.productId == product.id))
        .map((e) => e.wholesalePrice * state.product!.listOfProductIdWithQuantity.firstWhere((partProduct) => partProduct.productId == e.id).quantity)
        .toList();
    final sumOfPartProductWholesalePrices = listOfPartProductWholesalePrices.fold(0.0, (sum, item) => sum + item);
    final wholesalePrice = sumOfPartProductWholesalePrices.toMyRoundedDouble();

    emit(state.copyWith(
        product: state.product!.copyWith(wholesalePrice: wholesalePrice),
        wholesalePriceController: TextEditingController(text: wholesalePrice.toMyCurrencyStringToShow())));
  }

//? ###########################################################################################################################

  void _onPartOfSetProductControllerChanged(OnPartOfSetProductControllerChangedEvent event, Emitter<ProductDetailState> emit) {
    final widthSearchText = state.partOfSetProductSearchController.text.toLowerCase().split(' ');

    List<Product>? listOfProducts = switch (state.partOfSetProductSearchController.text) {
      '' => state.listOfAllProducts,
      (_) => state.listOfAllProducts!
          .where((e) => widthSearchText.every((entry) =>
              e.name.toLowerCase().contains(entry) ||
              e.ean.toLowerCase().contains(entry) ||
              e.supplier.toLowerCase().contains(entry) ||
              e.articleNumber.toLowerCase().contains(entry)))
          .toList(),
    };

    if (listOfProducts != null && listOfProducts.isNotEmpty) listOfProducts.sort((a, b) => a.name.compareTo(b.name));

    emit(state.copyWith(listOfFilteredProducts: listOfProducts));
  }

//? ###########################################################################################################################

  void _onPartOfSetProductControllerCleared(OnPartOfSetProductControllerClearedEvent event, Emitter<ProductDetailState> emit) {
    emit(state.copyWith(listOfFilteredProducts: state.listOfAllProducts, partOfSetProductSearchController: SearchController()));
  }

//? ###########################################################################################################################

  Future<void> _onProductGetProductsSalesData(OnProductGetProductsSalesDataEvent event, Emitter<ProductDetailState> emit) async {
    emit(state.copyWith(isLoadingStatProductsOnObserve: true));

    final fos = await statProductRepository.getProductsSalesDataOfLast13Months(state.product!.id);
    fos.fold(
      (failure) => emit(state.copyWith(firebaseFailureChart: failure)),
      (statProducts) =>
          emit(state.copyWith(listOfProductSalesData: statProducts.isEmpty ? [ProductSalesData.empty()] : statProducts, firebaseFailureChart: null)),
    );

    emit(state.copyWith(isLoadingStatProductsOnObserve: false));
  }

//? ###########################################################################################################################

  void _onProductChangeChartMode(OnProductChangeChartModeEvent event, Emitter<ProductDetailState> emit) {
    emit(state.copyWith(isShowingSalesVolumeOnChart: !state.isShowingSalesVolumeOnChart));
  }

//? ###########################################################################################################################

  Future<void> _onEditProductInPresta(OnEditProductInPresta event, Emitter<ProductDetailState> emit) async {
    bool isSuccessfull = true;
    final failureOrSuccess = await marketplaceEditRepository.editProdcutInMarketplace(event.product, null);
    failureOrSuccess.fold(
      (failure) => isSuccessfull = false, // TODO: handle Presta Failure
      (unit) => isSuccessfull = true,
    );

    if (isSuccessfull && event.updateImages) {
      add(UploadProductImageToPrestaEvent());
    } else {
      emit(state.copyWith(
        isLoadingProductOnUpdate: false,
        fosProductOnUpdateOption: optionOf(right(state.product!)),
        fosProductOnUpdateInMarketplaceOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosProductOnUpdateOption: none(), fosProductOnUpdateInMarketplaceOption: none()));
    }
  }

//? ###########################################################################################################################

  Future<void> _onUploadProductImageToPresta(UploadProductImageToPrestaEvent event, Emitter<ProductDetailState> emit) async {
    emit(state.copyWith(isLoadingProductOnUploadImages: true));

    final failureOrSuccess = await marketplaceEditRepository.uploadProductImagesToMarketplace(state.product!, state.listOfProductImages);
    failureOrSuccess.fold(
      (failure) => null, // TODO: handle Presta Failure
      (unit) => null,
    );

    emit(state.copyWith(
      isLoadingProductOnUpdate: false,
      fosProductOnUpdateOption: optionOf(right(state.product!)),
      isLoadingProductOnUploadImages: false,
      fosProductOnUploadImagesInMarketplaceOption: optionOf(failureOrSuccess),
    ));
    emit(state.copyWith(
      fosProductOnUpdateOption: none(),
      fosProductOnUploadImagesInMarketplaceOption: none(),
    ));
  }

//? ###########################################################################################################################
//? ###########################################################################################################################
//? ###########################################################################################################################
//? ###########################################################################################################################
  @override
  Future<void> close() {
    state.articleNumberController.dispose();
    state.eanController.dispose();
    state.nameController.dispose();
    state.wholesalePriceController.dispose();
    state.supplierArticleNumberController.dispose();
    state.manufacturerController.dispose();
    state.minimumStockController.dispose();
    state.minimumReorderQuantityController.dispose();
    state.packagingUnitOnReorderController.dispose();
    state.netPriceController.dispose();
    state.grossPriceController.dispose();
    state.recommendedRetailPriceController.dispose();
    state.unityController.dispose();
    state.unitPriceController.dispose();
    state.weightController.dispose();
    state.widthController.dispose();
    state.heightController.dispose();
    state.depthController.dispose();
    return super.close();
  }
}
