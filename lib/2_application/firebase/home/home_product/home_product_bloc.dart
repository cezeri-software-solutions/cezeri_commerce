import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/3_domain/enums/enums.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../3_domain/entities/product/home_product.dart';
import '../../../../3_domain/entities/product/product.dart';
import '../../../../3_domain/entities/reorder/reorder.dart';
import '../../../../3_domain/repositories/firebase/product_repository.dart';
import '../../../../3_domain/repositories/firebase/reorder_repository.dart';
import '../../../../core/firebase_failures.dart';

part 'home_product_event.dart';
part 'home_product_state.dart';

class HomeProductBloc extends Bloc<HomeProductEvent, HomeProductState> {
  final ProductRepository productRepository;
  final ReorderRepository reorderRepository;

  HomeProductBloc({required this.productRepository, required this.reorderRepository}) : super(HomeProductState.initial()) {
//? #########################################################################

    on<SetHomeProductStateToInitailEvent>((event, emit) {
      emit(HomeProductState.initial());
    });

//? #########################################################################

    on<GetHomeProductSoldOutProductsEvent>((event, emit) async {
      emit(state.copyWith(isLoadingHomeProductsOnObserve: true));

      final failureOrSuccess = await productRepository.getListOfSoldOutProducts();
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (listOfProducts) {
          emit(state.copyWith(listOfProductsSoldOut: listOfProducts, firebaseFailure: null, isAnyFailure: false));
          add(GenerateProductHomeProductsEvent());
          if (state.listOfReorders == null) add(GetHomeReordersEvent());
        },
      );

      emit(state.copyWith(
        isLoadingHomeProductsOnObserve: false,
        fosHomeProductsOnObserveOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosHomeProductsOnObserveOption: none()));
    });

//? #########################################################################

    on<GetHomeProductUnderMinimumQuantityProductsEvent>((event, emit) async {
      emit(state.copyWith(isLoadingHomeProductsOnObserve: true));

      final failureOrSuccess = await productRepository.getListOfUnderMinimumQuantityProducts();
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (listOfProducts) {
          emit(state.copyWith(listOfProductsUnderMinimumQuantity: listOfProducts, firebaseFailure: null, isAnyFailure: false));
          add(GenerateProductHomeProductsEvent());
          if (state.listOfReorders == null) add(GetHomeReordersEvent());
        },
      );

      emit(state.copyWith(
        isLoadingHomeProductsOnObserve: false,
        fosHomeProductsOnObserveOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosHomeProductsOnObserveOption: none()));
    });

//? #########################################################################

    on<GetHomeReordersEvent>((event, emit) async {
      print('GetHomeReordersEvent wird ausgeführt');
      emit(state.copyWith(isLoadingHomeReordersOnObserve: true));

      final failureOrSuccess = await reorderRepository.getListOfReorders(GetReordersType.openOrPartialOpen);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (listOfReorders) {
          emit(state.copyWith(listOfReorders: listOfReorders, firebaseFailure: null, isAnyFailure: false));
        },
      );

      emit(state.copyWith(
        isLoadingHomeReordersOnObserve: false,
        fosHomeReordersOnObserveOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosHomeReordersOnObserveOption: none()));
    });

//? #########################################################################

    on<OnHomeProductShowProductsByChangedEvent>((event, emit) async {
      emit(state.copyWith(showProductsBy: event.showProductsBy));
      if (state.isExpandedProducts) {
        if (event.showProductsBy == ShowProductsBy.soldOut && state.listOfProductsSoldOut == null) {
          add(GetHomeProductSoldOutProductsEvent());
        } else if (event.showProductsBy == ShowProductsBy.underMinimumQuantity && state.listOfProductsUnderMinimumQuantity == null) {
          add(GetHomeProductUnderMinimumQuantityProductsEvent());
        } else {
          add(GenerateProductHomeProductsEvent());
        }
      }
    });

//? #########################################################################

    on<OnHomeProductGroupProductsByChangedEvent>((event, emit) async {
      emit(state.copyWith(groupProductsBy: event.groupProductsBy));
      if (state.isExpandedProducts) {
        if (state.showProductsBy == ShowProductsBy.soldOut && state.listOfProductsSoldOut == null) {
          add(GetHomeProductSoldOutProductsEvent());
        } else if (state.showProductsBy == ShowProductsBy.underMinimumQuantity && state.listOfProductsUnderMinimumQuantity == null) {
          add(GetHomeProductUnderMinimumQuantityProductsEvent());
        } else {
          add(GenerateProductHomeProductsEvent());
        }
      }
    });

//? #########################################################################

    on<GenerateProductHomeProductsEvent>((event, emit) async {
      List<HomeProduct> listOfHomeProducts = [];
      final listOfProducts = switch (state.showProductsBy) {
        ShowProductsBy.soldOut => state.listOfProductsSoldOut,
        ShowProductsBy.underMinimumQuantity => state.listOfProductsUnderMinimumQuantity,
      };

      switch (state.groupProductsBy) {
        case GroupProductsBy.manufacturer:
          {
            for (final product in listOfProducts!) {
              final isManufacturerInList = listOfHomeProducts.any((e) => e.manufacturer == product.manufacturer);
              if (isManufacturerInList) {
                final index = listOfHomeProducts.indexWhere((e) => e.manufacturer == product.manufacturer);
                if (index == -1) continue;
                final products = listOfHomeProducts[index].listOfProducts..add(product);
                listOfHomeProducts[index] = listOfHomeProducts[index].copyWith(listOfProducts: products);
              } else {
                final newListOfHomeProduct = HomeProduct(supplier: '', manufacturer: product.manufacturer, listOfProducts: [product]);
                listOfHomeProducts.add(newListOfHomeProduct);
              }
            }
            listOfHomeProducts.sort((a, b) => a.manufacturer.compareTo(b.manufacturer));
            for (final homeProduct in listOfHomeProducts) {
              homeProduct.copyWith(listOfProducts: homeProduct.listOfProducts..sort((a, b) => a.name.compareTo(b.name)));
            }
          }
        case GroupProductsBy.supplier:
          {
            for (final product in listOfProducts!) {
              final isSupplierInList = listOfHomeProducts.any((e) => e.supplier == product.supplier);
              if (isSupplierInList) {
                final index = listOfHomeProducts.indexWhere((e) => e.supplier == product.supplier);
                if (index == -1) continue;
                final products = listOfHomeProducts[index].listOfProducts..add(product);
                listOfHomeProducts[index] = listOfHomeProducts[index].copyWith(listOfProducts: products);
              } else {
                final newListOfHomeProduct = HomeProduct(supplier: product.supplier, manufacturer: '', listOfProducts: [product]);
                listOfHomeProducts.add(newListOfHomeProduct);
              }
            }
            listOfHomeProducts.sort((a, b) => a.supplier.compareTo(b.supplier));
            for (final homeProduct in listOfHomeProducts) {
              homeProduct.copyWith(listOfProducts: homeProduct.listOfProducts..sort((a, b) => a.name.compareTo(b.name)));
            }
          }
      }

      emit(state.copyWith(listOfHomeProducts: listOfHomeProducts));
    });

//? #########################################################################

    on<OnHomeProductIsExpandedProductsChangedEvent>((event, emit) async {
      if (state.showProductsBy == ShowProductsBy.soldOut && state.listOfProductsSoldOut == null) {
        add(GetHomeProductSoldOutProductsEvent());
      }
      if (state.showProductsBy == ShowProductsBy.underMinimumQuantity && state.listOfProductsUnderMinimumQuantity == null) {
        add(GetHomeProductUnderMinimumQuantityProductsEvent());
      }
      emit(state.copyWith(isExpandedProducts: !state.isExpandedProducts));
    });

//? #########################################################################

    on<OnHomeProductSearchControllerChangedEvent>((event, emit) async {
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
      // // if (listOfProducts != null && listOfProducts.length > 20) listOfProducts = listOfProducts.sublist(0, 20);

      // emit(state.copyWith(listOfFilteredProducts: listOfProducts));
    });

//? #########################################################################
  }
}
