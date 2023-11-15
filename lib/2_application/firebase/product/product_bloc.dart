import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:cezeri_commerce/3_domain/repositories/prestashop/product/product_edit_repository.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cezeri_commerce/core/presta_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities_presta/product_presta.dart';
import '../../../3_domain/repositories/firebase/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  final ProductEditRepository productEditRepository;

  ProductBloc({required this.productRepository, required this.productEditRepository}) : super(ProductState.initial()) {
//? #########################################################################

    on<SetProductStateToInitialEvent>((event, emit) {
      emit(ProductState.initial());
    });

//? #########################################################################

    on<GetAllProductsEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductsOnObserve: true));

      final failureOrSuccess = await productRepository.getListOfProducts();
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (listOfProduct) {
          emit(state.copyWith(listOfAllProducts: listOfProduct, selectedProducts: [], firebaseFailure: null, isAnyFailure: false));
          add(OnSearchFieldSubmittedEvent());
        },
      );

      add(OnSearchFieldSubmittedEvent());

      emit(state.copyWith(
        isLoadingProductsOnObserve: false,
        fosProductsOnObserveOption: optionOf(failureOrSuccess),
      ));
    });

//? #########################################################################

    on<GetProductEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductOnObserve: true));

      final failureOrSuccess = await productRepository.getProduct(event.id);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (product) {
          emit(state.copyWith(product: product, firebaseFailure: null, isAnyFailure: false));
          add(SetProductControllerEvent(product: product));
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
        supplierController: TextEditingController(text: event.product.supplier),
        supplierArticleNumberController: TextEditingController(text: event.product.supplierArticleNumber),
        manufacturerController: TextEditingController(text: event.product.manufacturer),
        netPriceController: TextEditingController(text: event.product.netPrice.toMyCurrencyStringToShow()),
        grossPriceController: TextEditingController(text: event.product.grossPrice.toMyCurrencyStringToShow()),
        recommendedRetailPriceController: TextEditingController(text: event.product.recommendedRetailPrice.toMyCurrencyStringToShow()),
        unityController: TextEditingController(text: event.product.unity),
        unitPriceController: TextEditingController(text: event.product.unitPrice.toMyCurrencyStringToShow()),
        weightController: TextEditingController(text: event.product.weight.toMyCurrencyStringToShow()),
        widthController: TextEditingController(text: event.product.width.toMyCurrencyStringToShow()),
        heightController: TextEditingController(text: event.product.height.toMyCurrencyStringToShow()),
        depthController: TextEditingController(text: event.product.depth.toMyCurrencyStringToShow()),
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

    on<UpdateProductEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductOnUpdate: true));

      final updatedProduct = state.product!.copyWith(
        articleNumber: state.articleNumberController.text,
        ean: state.eanController.text,
        name: state.nameController.text,
        wholesalePrice: state.wholesalePriceController.text.toMyDouble(),
        supplier: state.supplierController.text,
        supplierArticleNumber: state.supplierArticleNumberController.text,
        manufacturer: state.manufacturerController.text,
        netPrice: state.netPriceController.text.toMyDouble(),
        grossPrice: state.grossPriceController.text.toMyDouble(),
        recommendedRetailPrice: state.recommendedRetailPriceController.text.toMyDouble(),
        unity: state.unityController.text,
        unitPrice: state.unitPriceController.text.toMyDouble(),
        weight: state.weightController.text.toMyDouble(),
        width: state.widthController.text.toMyDouble(),
        height: state.heightController.text.toMyDouble(),
        depth: state.depthController.text.toMyDouble(),
      );

      bool isUpdateInFirestoreSucceeded = false;
      final failureOrSuccess = await productRepository.updateProduct(updatedProduct);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (unit) {
          emit(state.copyWith(firebaseFailure: null, isAnyFailure: false));
          isUpdateInFirestoreSucceeded = true;
        },
      );

      if (isUpdateInFirestoreSucceeded) add(OnEditProductInPresta(product: updatedProduct));

      emit(state.copyWith(
        isLoadingProductOnUpdate: false,
        fosProductOnUpdateOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosProductOnUpdateOption: none()));
    });

//? #########################################################################

    on<UpdateQuantityOfProductEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductOnUpdate: true));

      final failureOrSuccess = await productRepository.updateQuantityOfProductAbsolut(event.product, event.newQuantity);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (product) {
          List<Product> updatedProducts = state.listOfAllProducts!;
          final index = updatedProducts.indexWhere((element) => element.id == product.id);
          updatedProducts[index] = product;

          emit(state.copyWith(listOfAllProducts: updatedProducts, firebaseFailure: null, isAnyFailure: false));

          add(OnEditQuantityInMarketplacesEvent(product: event.product, newQuantity: event.newQuantity));
        },
      );

      emit(state.copyWith(
        isLoadingProductOnUpdate: false,
        fosProductOnUpdateQuantityOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosProductOnUpdateOption: none()));
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

    on<SetSearchFieldTextEvent>((event, emit) async {
      emit(state.copyWith(productSearchText: event.searchText));

      add(OnSearchFieldSubmittedEvent());
    });

    on<OnSearchFieldSubmittedEvent>((event, emit) async {
      final listOfProducts = switch (state.productSearchText) {
        '' => state.listOfAllProducts,
        (_) => state.listOfAllProducts!
            .where((element) =>
                element.name.toLowerCase().contains(state.productSearchText.toLowerCase()) ||
                element.ean.toLowerCase().contains(state.productSearchText.toLowerCase()) ||
                element.supplier.toLowerCase().contains(state.productSearchText.toLowerCase()) ||
                element.articleNumber.toLowerCase().contains(state.productSearchText.toLowerCase()))
            .toList()
      };
      if (listOfProducts != null && listOfProducts.isNotEmpty) listOfProducts.sort((a, b) => a.name.compareTo(b.name));
      emit(state.copyWith(listOfFilteredProducts: listOfProducts));
    });

//? #########################################################################

    on<OnProductSelectedEvent>((event, emit) async {
      List<Product> products = List.from(state.selectedProducts);
      if (products.any((element) => element.id == event.product.id)) {
        print(products.any((element) => element.id == event.product.id));
        products.removeWhere((element) => element.id == event.product.id);
      } else {
        products.add(event.product);
      }
      emit(state.copyWith(selectedProducts: products));
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
      final failureOrSuccess = await productEditRepository.setProdcutPrestaQuantity(event.product, event.newQuantity);
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
      final failureOrSuccess = await productEditRepository.editProdcutPresta(event.product);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith()), // TODO: handle Presta Failure
        (unit) => emit(state.copyWith(firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        fosProductOnEditQuantityPrestaOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosProductOnEditQuantityPrestaOption: none()));
    });
  }
}
