import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/failures/firebase_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../1_presentation/core/functions/set_product_functions.dart';
import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/reorder/supplier.dart';
import '../../../3_domain/entities/settings/main_settings.dart';
import '../../../3_domain/repositories/firebase/main_settings_respository.dart';
import '../../../3_domain/repositories/firebase/product_repository.dart';
import '../../../3_domain/repositories/firebase/supplier_repository.dart';
import '../../../3_domain/repositories/marketplace/marketplace_edit_repository.dart';
import '../../../failures/abstract_failure.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  final MarketplaceEditRepository marketplaceEditRepository;
  final MainSettingsRepository mainSettingsRepository;
  final SupplierRepository supplierRepository;

  ProductBloc({
    required this.productRepository,
    required this.marketplaceEditRepository,
    required this.mainSettingsRepository,
    required this.supplierRepository,
  }) : super(ProductState.initial()) {
    on<SetProductStateToInitialEvent>(_onSetProductStateToInitial);
    on<GetAllProductsEvent>(_onGetAllProducts);
    on<GetProductsPerPageEvent>(_onGetProductsPerPage);
    on<GetFilteredProductsBySearchTextEvent>(_onGetFilteredProductsBySearchText);
    on<GetProductEvent>(_onGetProduct);
    on<DeleteSelectedProductsEvent>(_onDeleteSelectedProducts);
    on<OnProductSearchControllerClearedEvent>(_onOnProductSearchControllerCleared);
    on<OnSearchFieldSubmittedEvent>(_onOnSearchFieldSubmitted);
    on<OnSearchFieldClearedEvent>(_onOnSearchFieldCleared);
    on<OnProductIsSelectedAllChangedEvent>(_onOnProductIsSelectedAllChanged);
    on<OnProductSelectedEvent>(_onOnProductSelected);
    on<OnProductGetSuppliersEvent>(_onOnProductGetSuppliers);
    on<SetProductIsLoadingPdfEvent>(_onSetProductIsLoadingPdf);
    on<UpdateQuantityOfProductEvent>(_onUpdateQuantityOfProduct);
    on<ItemsPerPageChangedEvent>(_onItemsPerPageChanged);
    on<MassEditActivateProductMarketplaceEvent>(_onMassEditActivateProductMarketplace);
    on<ProductsMassEditingPurchaceUpdatedEvent>(_onProductsMassEditingPurchaceUpdated);
    on<ProductsMassEditingWeightAndDimensionsUpdatedEvent>(_onProductsMassEditingWeightAndDimensionsUpdated);
    // on<OnEditQuantityInMarketplacesEvent>(_onOnEditQuantityInMarketplaces);
    on<OnEditProductInPresta>(_onOnEditProductInPresta);
  }

  void _onSetProductStateToInitial(SetProductStateToInitialEvent event, Emitter<ProductState> emit) async {
    emit(ProductState.initial());
  }

  Future<void> _onGetAllProducts(GetAllProductsEvent event, Emitter<ProductState> emit) async {
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
  }

  Future<void> _onGetProductsPerPage(GetProductsPerPageEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(isLoadingProductsOnObserve: true));

    if (event.isFirstLoad) {
      final fosSettings = await mainSettingsRepository.getSettings();
      fosSettings.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (settings) => emit(state.copyWith(mainSettings: settings, firebaseFailure: null, isAnyFailure: false)),
      );
    }

    if (event.calcCount) {
      final fosCount = await productRepository.getNumerOfAllProducts(onlyActive: false);
      fosCount.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (countNumber) => emit(state.copyWith(totalQuantity: countNumber, firebaseFailure: null, isAnyFailure: false)),
      );
    }

    final failureOrSuccess = await productRepository.getListOfProductsPerPage(
      currentPage: event.currentPage,
      itemsPerPage: state.perPageQuantity,
      onlyActive: false,
    );
    failureOrSuccess.fold(
      (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
      (listOfProduct) {
        emit(state.copyWith(
          listOfAllProducts: listOfProduct,
          listOfFilteredProducts: listOfProduct,
          selectedProducts: [],
          currentPage: event.currentPage,
          firebaseFailure: null,
          isAnyFailure: false,
        ));
        add(OnSearchFieldSubmittedEvent());
      },
    );

    emit(state.copyWith(
      isLoadingProductsOnObserve: false,
      fosProductsOnObserveOption: optionOf(failureOrSuccess),
    ));
    emit(state.copyWith(fosProductsOnObserveOption: none()));
  }

  Future<void> _onGetFilteredProductsBySearchText(GetFilteredProductsBySearchTextEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(isLoadingProductsOnObserve: true));

    final fosCount = await productRepository.getNumberOfFilteredProductsBySearchText(searchText: state.productSearchController.text);
    fosCount.fold(
      (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
      (countNumber) => emit(state.copyWith(totalQuantity: countNumber, firebaseFailure: null, isAnyFailure: false)),
    );

    final fosProducts = await productRepository.getListOfFilteredProductsBySearchText(
      searchText: state.productSearchController.text,
      currentPage: event.currentPage,
      itemsPerPage: state.perPageQuantity,
    );

    fosProducts.fold(
      (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
      (listOfProduct) {
        emit(state.copyWith(
          listOfAllProducts: listOfProduct,
          listOfFilteredProducts: listOfProduct,
          selectedProducts: [],
          currentPage: event.currentPage,
          firebaseFailure: null,
          isAnyFailure: false,
        ));
        add(OnSearchFieldSubmittedEvent());
      },
    );

    emit(state.copyWith(
      isLoadingProductsOnObserve: false,
      fosProductsOnObserveOption: optionOf(fosProducts),
    ));
    emit(state.copyWith(fosProductsOnObserveOption: none()));
  }

  Future<void> _onGetProduct(GetProductEvent event, Emitter<ProductState> emit) async {
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
        add(OnSearchFieldSubmittedEvent());
      },
    );
  }

  Future<void> _onDeleteSelectedProducts(DeleteSelectedProductsEvent event, Emitter<ProductState> emit) async {
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
  }

  void _onOnProductSearchControllerCleared(OnProductSearchControllerClearedEvent event, Emitter<ProductState> emit) {
    emit(state.copyWith(productSearchController: SearchController()));

    add(OnSearchFieldSubmittedEvent());
  }

  void _onOnSearchFieldSubmitted(OnSearchFieldSubmittedEvent event, Emitter<ProductState> emit) {
    // final widthSearchText = state.productSearchController.text.toLowerCase().split(' ');

    // List<Product>? listOfProducts = switch (state.productSearchController.text) {
    //   '' => state.listOfAllProducts,
    //   (_) => switch (state.isWidthSearchActive) {
    //       true => state.listOfAllProducts!
    //           .where((e) => widthSearchText.every((entry) =>
    //               e.name.toLowerCase().contains(entry) ||
    //               e.ean.toLowerCase().contains(entry) ||
    //               e.supplier.toLowerCase().contains(entry) ||
    //               e.articleNumber.toLowerCase().contains(entry)))
    //           .toList(),
    //       _ => state.listOfAllProducts!
    //           .where((element) =>
    //               element.name.toLowerCase().contains(state.productSearchController.text.toLowerCase()) ||
    //               element.ean.toLowerCase().contains(state.productSearchController.text.toLowerCase()) ||
    //               element.supplier.toLowerCase().contains(state.productSearchController.text.toLowerCase()) ||
    //               element.articleNumber.toLowerCase().contains(state.productSearchController.text.toLowerCase()))
    //           .toList()
    //     },
    // };

    // if (listOfProducts != null && listOfProducts.isNotEmpty) listOfProducts.sort((a, b) => a.name.compareTo(b.name));

    // emit(state.copyWith(listOfFilteredProducts: listOfProducts));
  }

  void _onOnSearchFieldCleared(OnSearchFieldClearedEvent event, Emitter<ProductState> emit) {
    emit(state.copyWith(productSearchController: SearchController()));
    add(GetProductsPerPageEvent(isFirstLoad: false, calcCount: true, currentPage: 1));
  }

  void _onOnProductIsSelectedAllChanged(OnProductIsSelectedAllChangedEvent event, Emitter<ProductState> emit) {
    List<Product> products = [];
    bool isSelectedAll = false;
    if (event.isSelected) {
      isSelectedAll = true;
      products = List.from(state.listOfFilteredProducts!);
    }
    emit(state.copyWith(isSelectedAllProducts: isSelectedAll, selectedProducts: products));
  }

  void _onOnProductSelected(OnProductSelectedEvent event, Emitter<ProductState> emit) {
    List<Product> products = List.from(state.selectedProducts);
    if (products.any((e) => e.id == event.product.id)) {
      products.removeWhere((e) => e.id == event.product.id);
    } else {
      products.add(event.product);
    }
    emit(state.copyWith(
      isSelectedAllProducts: state.isSelectedAllProducts && products.length < state.selectedProducts.length ? false : state.isSelectedAllProducts,
      selectedProducts: products,
    ));
  }

  Future<void> _onOnProductGetSuppliers(OnProductGetSuppliersEvent event, Emitter<ProductState> emit) async {
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
  }

  void _onSetProductIsLoadingPdf(SetProductIsLoadingPdfEvent event, Emitter<ProductState> emit) {
    emit(state.copyWith(isLoadingPdf: event.value));
  }

  Future<void> _onUpdateQuantityOfProduct(UpdateQuantityOfProductEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(isLoadingProductOnUpdateQuantity: true));
    //* Damit die Artikel in der Artikelübersicht direkt aktualisiert werden
    List<Product> updatedProducts = List.from(state.listOfAllProducts ?? []);
    List<AbstractFailure> listOfAbstractFailures = [];
    //* Wenn der Artikel Bestandteil von Set-Artikeln ist, werden die aktualisierten Set-Artikel in dieser Liste gespeichert.
    //* Diese werden anschließend zum aktualisieren der Bestände in den Marktplätzen genutzt
    List<Product> listOfToUpdateProductsInMarketplaces = [];

    //* Lade Original-Artikel aus Firestore
    final fosOriginalProduct = await productRepository.getProduct(event.product.id);
    final originalProduct = fosOriginalProduct.fold(
      (failure) {
        //!KO
        emit(state.copyWith(
          isLoadingProductOnUpdateQuantity: false,
          fosProductOnUpdateQuantityOption: optionOf(fosOriginalProduct),
        ));
        emit(state.copyWith(fosProductOnUpdateQuantityOption: none(), fosProductAbstractFailuresOption: none()));
        return null;
      },
      (product) => product,
    );
    if (originalProduct == null) return;

    //* Aktualisiere den Bestand des originalen Artikels absolut und lade es zu Firestore hoch
    final updatedOriginalProduct = _updateOriginalProductStock(originalProduct, event.newQuantity, event.updateOnlyAvailableQuantity);
    final fosUpdatedProduct = await productRepository.updateProduct(updatedOriginalProduct);
    fosUpdatedProduct.fold(
      (failure) {
        //!KO
        emit(state.copyWith(
          isLoadingProductOnUpdateQuantity: false,
          fosProductOnUpdateQuantityOption: optionOf(fosUpdatedProduct),
        ));
        emit(state.copyWith(fosProductOnUpdateQuantityOption: none(), fosProductAbstractFailuresOption: none()));
        return;
      },
      (product) {
        listOfToUpdateProductsInMarketplaces.add(product);
        final index = updatedProducts.indexWhere((element) => element.id == product.id);
        if (index != -1) updatedProducts[index] = product;
      },
    );

    //* Wenn der Artikel ein Bestandteil von Set-Artikeln ist, müssen auch diese aktualisiert werden
    if (event.product.listOfIsPartOfSetIds.isNotEmpty) {
      await _updateSetProducts(event.product.listOfIsPartOfSetIds, listOfAbstractFailures, listOfToUpdateProductsInMarketplaces, updatedProducts);
    }

    //* Alle Artikel deren Bestand in Firestore aktualisiert wurde auch in den Marktplätzen aktualisieren
    for (final updatedProduct in listOfToUpdateProductsInMarketplaces) {
      final fosMarketplaceUpdate = await marketplaceEditRepository.setQuantityMPInAllProductMarketplaces(
        updatedProduct,
        updatedProduct.availableStock,
        null,
      );
      fosMarketplaceUpdate.fold(
        (failures) => listOfAbstractFailures.addAll(failures),
        (unit) => null,
      );
    }

    emit(state.copyWith(
      isLoadingProductOnUpdateQuantity: false,
      listOfAllProducts: updatedProducts,
      fosProductOnUpdateQuantityOption: optionOf(Right(updatedOriginalProduct)),
      fosProductAbstractFailuresOption: optionOf(Left(listOfAbstractFailures)),
    ));
    emit(state.copyWith(fosProductOnUpdateQuantityOption: none(), fosProductAbstractFailuresOption: none()));

    add(OnSearchFieldSubmittedEvent());
  }

  void _onItemsPerPageChanged(ItemsPerPageChangedEvent event, Emitter<ProductState> emit) {
    emit(state.copyWith(perPageQuantity: event.value));
    if (state.productSearchController.text.isEmpty) {
      add(GetProductsPerPageEvent(isFirstLoad: false, calcCount: false, currentPage: 1));
    } else {
      add(GetFilteredProductsBySearchTextEvent(currentPage: 1));
    }
  }

  Future<void> _onMassEditActivateProductMarketplace(MassEditActivateProductMarketplaceEvent event, Emitter<ProductState> emit) async {
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
  }

  Future<void> _onProductsMassEditingPurchaceUpdated(ProductsMassEditingPurchaceUpdatedEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(isLoadingProductOnMassEditing: true, listOfNotUpdatedProductsOnMassEditing: []));

    bool isFosFirestoreSuccess = true;
    final List<AbstractFailure> marketplaceFailures = [];
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
      final failureOrSuccess = await productRepository.updateProductAndSets(updatedProduct);
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
      final fosMarketplace = await marketplaceEditRepository.editProdcutInMarketplace(
          updatedProduct, event.selectedMarketplaces as List<MarketplacePresta>); //TODO: Shopify
      failureOrSuccess.fold(
        (failure) => marketplaceFailures.add(failure),
        (unit) => emit(state.copyWith(firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(fosProductOnEditQuantityPrestaOption: optionOf(fosMarketplace)));
    }

    if (isFosFirestoreSuccess) add(OnSearchFieldSubmittedEvent());

    emit(state.copyWith(
        isLoadingProductOnMassEditing: false,
        listOfNotUpdatedProductsOnMassEditing: listOfNotUpdatedProductsOnMassEditing,
        fosMassEditProductsOption: isFosFirestoreSuccess ? some(right(unit)) : some(left(GeneralFailure())),
        fosProductOnEditQuantityPrestaOption: marketplaceFailures.isEmpty ? some(right(unit)) : some(left(marketplaceFailures))));
    emit(state.copyWith(
      fosMassEditProductsOption: none(),
      fosProductOnEditQuantityPrestaOption: none(),
    ));
  }

  Future<void> _onProductsMassEditingWeightAndDimensionsUpdated(
      ProductsMassEditingWeightAndDimensionsUpdatedEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(isLoadingProductOnMassEditing: true, listOfNotUpdatedProductsOnMassEditing: []));

    bool isFosFirestoreSuccess = true;
    final List<AbstractFailure> marketplaceFailures = [];
    List<Product> listOfNotUpdatedProductsOnMassEditing = [];

    for (final product in state.selectedProducts) {
      final updatedProduct = product.copyWith(
        weight: event.isWeightSelected ? event.weight : product.weight,
        height: event.isHeightSelected ? event.height : product.height,
        depth: event.isDepthSelected ? event.depth : product.depth,
        width: event.isWidthSelected ? event.width : product.width,
      );
      //* Update in Firestore & States of Bloc
      final failureOrSuccess = await productRepository.updateProductAndSets(updatedProduct);
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
      final fosMarketplace = await marketplaceEditRepository.editProdcutInMarketplace(
          updatedProduct, event.selectedMarketplaces as List<MarketplacePresta>); //TODO: Shopify
      fosMarketplace.fold(
        (failure) => marketplaceFailures.addAll(failure),
        (unit) => emit(state.copyWith(firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(fosProductOnEditQuantityPrestaOption: optionOf(fosMarketplace)));
    }

    if (isFosFirestoreSuccess) add(OnSearchFieldSubmittedEvent());

    emit(state.copyWith(
        isLoadingProductOnMassEditing: false,
        listOfNotUpdatedProductsOnMassEditing: listOfNotUpdatedProductsOnMassEditing,
        fosMassEditProductsOption: isFosFirestoreSuccess ? some(right(unit)) : some(left(GeneralFailure())),
        fosProductOnEditQuantityPrestaOption: marketplaceFailures.isEmpty ? some(right(unit)) : some(left(marketplaceFailures))));
    emit(state.copyWith(
      fosMassEditProductsOption: none(),
      fosProductOnEditQuantityPrestaOption: none(),
    ));
  }

  // Future<void> _onOnEditQuantityInMarketplaces(OnEditQuantityInMarketplacesEvent event, Emitter<ProductState> emit) async {
  //   // TODO: add isLoading
  //   final failureOrSuccess = await marketplaceEditRepository.setQuantityMPInAllProductMarketplaces(event.product, event.newQuantity, null);
  //   failureOrSuccess.fold(
  //     (failure) => emit(state.copyWith()),
  //     (unit) => emit(state.copyWith(firebaseFailure: null, isAnyFailure: false)),
  //   );

  //   emit(state.copyWith(
  //     fosProductOnEditQuantityPrestaOption: optionOf(failureOrSuccess),
  //   ));
  //   emit(state.copyWith(fosProductOnEditQuantityPrestaOption: none()));
  // }

  Future<void> _onOnEditProductInPresta(OnEditProductInPresta event, Emitter<ProductState> emit) async {
    // TODO: add isLoading
    final failureOrSuccess = await marketplaceEditRepository.editProdcutInMarketplace(event.product, null);
    failureOrSuccess.fold(
      (failure) => emit(state.copyWith()), // TODO: handle Presta Failure
      (unit) => emit(state.copyWith(firebaseFailure: null, isAnyFailure: false)),
    );

    emit(state.copyWith(fosProductOnEditQuantityPrestaOption: optionOf(failureOrSuccess)));
    emit(state.copyWith(fosProductOnEditQuantityPrestaOption: none()));
  }

  //? ##############################################################################################################################################
  //? ##############################################################################################################################################
  //? ########### HILFSFUNKTIONEN ##################################################################################################################
  //? ##############################################################################################################################################
  //? ##############################################################################################################################################

  Product _updateOriginalProductStock(Product originalProduct, int newQuantity, bool updateOnlyAvailableQuantity) {
    return originalProduct.copyWith(
      availableStock: newQuantity,
      warehouseStock: updateOnlyAvailableQuantity
          ? originalProduct.warehouseStock
          : originalProduct.warehouseStock - (originalProduct.availableStock - newQuantity),
      isUnderMinimumStock: newQuantity <= originalProduct.minimumStock ? true : false,
    );
  }

  Future<void> _updateSetProducts(
    List<String> listOfIsPartOfSetIds,
    List<AbstractFailure> listOfAbstractFailures,
    List<Product> listOfToUpdateProductsInMarketplaces,
    List<Product> updatedProducts,
  ) async {
    //* Lade alle Set-Artikel und speichere diese in eine Liste
    final List<Product> listOfSetProducts = [];
    for (final id in listOfIsPartOfSetIds) {
      final fosGetSetProduct = await productRepository.getProduct(id);
      fosGetSetProduct.fold(
        (failure) => listOfAbstractFailures.add(failure),
        (setProduct) => listOfSetProducts.add(setProduct),
      );
    }

    //* Aktualisiere den Bestand jedes Set-Artikels
    for (final setProduct in listOfSetProducts) {
      //* Lade alle Einzelartikel von jedem Set-Artikel
      final List<Product> listOfSetPartProducts = [];
      bool shouldContinue = true; // Flagge, um die Fortsetzung der inneren Iteration zu steuern

      for (final partProduct in setProduct.listOfProductIdWithQuantity) {
        if (!shouldContinue) break; // Überprüfe die Flagge bevor du mit der nächsten Iteration fortfährst

        final fosSetPartProduct = await productRepository.getProduct(partProduct.productId);
        fosSetPartProduct.fold(
          (failure) {
            final generalFailure = GeneralFailure(
              customMessage: 'Laden der Einzelartikel des Set-Artikels: "${setProduct.name}" ist ein Fehler aufgetreten.',
            );
            listOfAbstractFailures.add(generalFailure);
            shouldContinue = false;
          },
          (product) => listOfSetPartProducts.add(product),
        );
      }

      if (!shouldContinue) continue; // Wenn die Flagge gesetzt ist, überspringe den Rest der äußeren Schleife

      final difference = setProduct.warehouseStock - setProduct.availableStock;
      final availableQuantitySetArticle = calcSetArticleAvailableQuantity(setProduct, listOfSetPartProducts);
      final updatedSetProduct = setProduct.copyWith(
        availableStock: availableQuantitySetArticle,
        warehouseStock: availableQuantitySetArticle + difference,
      );
      final fosUpdateSetProduct = await productRepository.updateProduct(updatedSetProduct);
      fosUpdateSetProduct.fold(
        (failure) {
          final generalFailure = GeneralFailure(
            customMessage: 'Beim Aktualisieren des Bestandes vom Set-Artikel "${setProduct.name}" ist ein Fehler aufgetreten.',
          );
          listOfAbstractFailures.add(generalFailure);
        },
        (product) {
          listOfToUpdateProductsInMarketplaces.add(product);
          final index = updatedProducts.indexWhere((element) => element.id == product.id);
          if (index != -1) updatedProducts[index] = product;
        },
      );
    }
  }
}
