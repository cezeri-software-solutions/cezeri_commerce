import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/failures/firebase_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '/1_presentation/core/core.dart';
import '/3_domain/entities/marketplace/abstract_marketplace.dart';
import '/3_domain/entities/marketplace/marketplace_presta.dart';
import '/3_domain/entities/marketplace/marketplace_shopify.dart';
import '/3_domain/entities/product/product.dart';
import '/3_domain/entities/product/product_marketplace.dart';
import '/3_domain/entities/reorder/supplier.dart';
import '/3_domain/entities/settings/main_settings.dart';
import '/3_domain/repositories/marketplace/marketplace_edit_repository.dart';
import '/4_infrastructur/repositories/shopify_api/shopify.dart';
import '/failures/abstract_failure.dart';
import '../../../3_domain/entities/product/product_presta.dart';
import '../../../3_domain/repositories/database/main_settings_respository.dart';
import '../../../3_domain/repositories/database/product_repository.dart';
import '../../../3_domain/repositories/database/supplier_repository.dart';
import '../../../4_infrastructur/repositories/database/functions/product_repository_helper.dart';
import '../../../4_infrastructur/repositories/prestashop_api/models/models.dart';
import '../../../4_infrastructur/repositories/prestashop_api/prestashop_repository_patch.dart';

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
    on<ProductsMassEditingAddOrRemoveCategoriesShopifyEvent>(_onProductsMassEditingAddCategoriesShopify);
    on<ProductsMassEditingAddOrRemoveCategoriesPrestaEvent>(_onProductsMassEditingAddOrRemoveCategoriesPresta);
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
        emit(state.copyWith(
          listOfAllProducts: updatedListOfAll,
          listOfFilteredProducts: updatedListOfAll,
          selectedProducts: updatedSelected,
          firebaseFailure: null,
          isAnyFailure: false,
        ));
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
    List<AbstractFailure> listOfAbstractFailures = [];
    //* Wenn der Artikel Bestandteil von Set-Artikeln ist, werden die aktualisierten Set-Artikel in dieser Liste gespeichert.
    //* Diese werden anschließend zum aktualisieren der Bestände in den Marktplätzen genutzt
    final fosUpdateProductStock = await updateProductQuantityInDbAndMps(
      productId: event.product.id,
      incQuantity: event.incQuantity,
      updateOnlyAvailableQuantity: event.updateOnlyAvailableQuantity,
    );
    if (fosUpdateProductStock.isLeft()) {
      //!KO
      emit(state.copyWith(
        isLoadingProductOnUpdateQuantity: false,
        fosProductOnUpdateQuantityOption: optionOf(fosUpdateProductStock),
      ));
      emit(state.copyWith(fosProductOnUpdateQuantityOption: none(), fosProductAbstractFailuresOption: none()));
      return;
    }
    final listOfToUpdateProductsInMarketplaces = fosUpdateProductStock.getRight();

    emit(state.copyWith(
      isLoadingProductOnUpdateQuantity: false,
      fosProductOnUpdateQuantityOption: optionOf(Right(listOfToUpdateProductsInMarketplaces)),
      fosProductAbstractFailuresOption: optionOf(Left(listOfAbstractFailures)),
    ));
    emit(state.copyWith(fosProductOnUpdateQuantityOption: none(), fosProductAbstractFailuresOption: none()));
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
      final fosMarketplace = await marketplaceEditRepository.editProdcutInMarketplace(updatedProduct, event.selectedMarketplaces);
      fosMarketplace.fold(
        (failure) => marketplaceFailures.addAll(failure),
        (unit) => emit(state.copyWith(firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(fosProductOnEditQuantityPrestaOption: optionOf(fosMarketplace)));
    }

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

  Future<void> _onProductsMassEditingAddCategoriesShopify(
      ProductsMassEditingAddOrRemoveCategoriesShopifyEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(isLoadingProductOnMassEditing: true, listOfNotUpdatedProductsOnMassEditing: []));

    final List<AbstractFailure> marketplaceFailures = [];
    List<Product> listOfNotUpdatedProductsOnMassEditing = [];

    for (final product in state.selectedProducts) {
      final productMarketplace = product.productMarketplaces.where((e) => e.idMarketplace == event.marketplace.id).firstOrNull;
      if (productMarketplace == null) {
        listOfNotUpdatedProductsOnMassEditing.add(product);
        continue;
      }
      final productShopify = productMarketplace.marketplaceProduct as ProductShopify;

      List<ProductMarketplace> listOfProductMarketplaces = List.from(product.productMarketplaces);
      final index = listOfProductMarketplaces.indexWhere((e) => e.idMarketplace == event.marketplace.id);
      if (index == -1) continue;

      final updatedCustomCollections = switch (event.isAddCategories) {
        true => (listOfProductMarketplaces[index].marketplaceProduct as ProductShopify).customCollections..addAll(event.selectedCustomCollections),
        false => (listOfProductMarketplaces[index].marketplaceProduct as ProductShopify).customCollections
          ..removeWhere((e) => event.selectedCustomCollections.any((selected) => selected.id == e.id)),
      };

      listOfProductMarketplaces[index] = listOfProductMarketplaces[index].copyWith(
          marketplaceProduct:
              (listOfProductMarketplaces[index].marketplaceProduct as ProductShopify).copyWith(customCollections: updatedCustomCollections));

      final updatedProduct = product.copyWith(productMarketplaces: listOfProductMarketplaces);
      final databaseResponse = await productRepository.updateProduct(updatedProduct);
      if (databaseResponse.isLeft()) {
        listOfNotUpdatedProductsOnMassEditing.add(product);
        continue;
      }

      //* Update in Marktplätzen
      final marketplaceResponse = switch (event.isAddCategories) {
        true => await ShopifyRepositoryPost(event.marketplace).addCollectionsToProduct(productShopify, event.selectedCustomCollections),
        false => await ShopifyRepositoryDelete(event.marketplace).removeCollectionsFromProduct(productShopify, event.selectedCustomCollections),
      };
      marketplaceResponse.fold(
        (failure) => marketplaceFailures.addAll(failure),
        (unit) => emit(state.copyWith(firebaseFailure: null, isAnyFailure: false)),
      );
    }

    emit(state.copyWith(
      isLoadingProductOnMassEditing: false,
      listOfNotUpdatedProductsOnMassEditing: listOfNotUpdatedProductsOnMassEditing,
      fosMassEditProductsOption: marketplaceFailures.isEmpty ? some(right(unit)) : some(left(GeneralFailure())),
    ));
    emit(state.copyWith(fosMassEditProductsOption: none()));
  }

  Future<void> _onProductsMassEditingAddOrRemoveCategoriesPresta(
      ProductsMassEditingAddOrRemoveCategoriesPrestaEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(isLoadingProductOnMassEditing: true, listOfNotUpdatedProductsOnMassEditing: []));

    final List<AbstractFailure> marketplaceFailures = [];
    List<Product> listOfNotUpdatedProductsOnMassEditing = [];

    for (final product in state.selectedProducts) {
      final productMarketplace = product.productMarketplaces.where((e) => e.idMarketplace == event.marketplace.id).firstOrNull;
      if (productMarketplace == null) {
        listOfNotUpdatedProductsOnMassEditing.add(product);
        continue;
      }

      List<ProductMarketplace> listOfProductMarketplaces = List.from(product.productMarketplaces);
      final index = listOfProductMarketplaces.indexWhere((e) => e.idMarketplace == event.marketplace.id);
      if (index == -1) continue;

      final updatedAssociationsCategories = switch (event.isAddCategories) {
        true => (listOfProductMarketplaces[index].marketplaceProduct as ProductPresta).associations!.associationsCategories!
          ..addAll(event.selectedCategoriesPresta.map((e) => AssociationsCategory(id: e.id.toString())).toList()),
        false => (listOfProductMarketplaces[index].marketplaceProduct as ProductPresta).associations!.associationsCategories!
          ..removeWhere((e) => event.selectedCategoriesPresta.any((selected) => selected.id.toString() == e.id)),
      };

      final productPresta = (listOfProductMarketplaces[index].marketplaceProduct as ProductPresta);
      listOfProductMarketplaces[index] = listOfProductMarketplaces[index].copyWith(
        marketplaceProduct: productPresta.copyWith(
          associations: productPresta.associations!.copyWith(associationsCategories: updatedAssociationsCategories),
        ),
      );

      final updatedProduct = product.copyWith(productMarketplaces: listOfProductMarketplaces);
      final databaseResponse = await productRepository.updateProduct(updatedProduct);
      if (databaseResponse.isLeft()) {
        listOfNotUpdatedProductsOnMassEditing.add(product);
        continue;
      }

      //* Update in Marktplätzen
      final marketplaceResponse = await PrestashopRepositoryPatch(event.marketplace).updateCategoriesInMarketplace(
        productId: productPresta.id,
        product: updatedProduct,
        productPresta: updatedProduct.productMarketplaces[index].marketplaceProduct as ProductPresta,
      );
      marketplaceResponse.fold(
        (failure) => marketplaceFailures.addAll([failure]),
        (unit) => emit(state.copyWith(firebaseFailure: null, isAnyFailure: false)),
      );
    }

    emit(state.copyWith(
      isLoadingProductOnMassEditing: false,
      listOfNotUpdatedProductsOnMassEditing: listOfNotUpdatedProductsOnMassEditing,
      fosMassEditProductsOption: marketplaceFailures.isEmpty ? some(right(unit)) : some(left(GeneralFailure())),
    ));
    emit(state.copyWith(fosMassEditProductsOption: none()));
  }

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
}
