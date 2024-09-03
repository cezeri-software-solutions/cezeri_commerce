import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/3_domain/enums/enums.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '/1_presentation/core/core.dart';
import '../../../3_domain/entities/product/booking_product.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/reorder/reorder.dart';
import '../../../3_domain/repositories/firebase/product_repository.dart';
import '../../../3_domain/repositories/firebase/reorder_repository.dart';
import '../../../failures/abstract_failure.dart';

part 'products_booking_event.dart';
part 'products_booking_state.dart';

class ProductsBookingBloc extends Bloc<ProductsBookingEvent, ProductsBookingState> {
  final ProductRepository productRepository;
  final ReorderRepository reorderRepository;

  ProductsBookingBloc({required this.productRepository, required this.reorderRepository}) : super(ProductsBookingState.initial()) {
//? #########################################################################

    on<SetProductsBookingStateToInitialEvent>((event, emit) {
      emit(ProductsBookingState.initial());
    });

//? #########################################################################

    on<ProductsBookingGetReordersEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductsBookingReordersOnObserve: true));

      final failureOrSuccess = await reorderRepository.getListOfReorders(GetReordersType.openOrPartialOpen);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (listOfReorder) {
          emit(state.copyWith(listOfAllReorders: listOfReorder, selectedReorderProducts: [], firebaseFailure: null, isAnyFailure: false));
          add(ProductsBookingFilterReordersEvent());
          if (state.listOfAllProducts == null || (state.listOfAllProducts != null && state.listOfAllProducts!.isEmpty)) {
            add(ProductsBookingGetProductsEvent());
          }
        },
      );

      if (event.afterUpdate) {
        emit(state.copyWith(
          reorderFilter: '',
          isLoadingProductsBookingReordersOnObserve: false,
        ));
      } else {
        emit(state.copyWith(
          reorderFilter: '',
          isLoadingProductsBookingReordersOnObserve: false,
          fosProductsBookingReordersOnObserveOption: optionOf(failureOrSuccess),
        ));
        emit(state.copyWith(fosProductsBookingReordersOnObserveOption: none()));
      }
    });

//? #########################################################################

    on<ProductsBookingFilterReordersEvent>((event, emit) {
      final listOfReorder = switch (state.reorderFilter) {
        '' => state.listOfAllReorders,
        _ => state.listOfAllReorders!.where((e) => e.reorderNumber.toString() == state.reorderFilter).toList()
      };

      if (listOfReorder != null && listOfReorder.isNotEmpty) listOfReorder.sort((a, b) => b.reorderNumber.compareTo(a.reorderNumber));
      emit(state.copyWith(listOfFilteredReorders: listOfReorder));
    });

//? #########################################################################

    on<ProductsBookingGetProductsEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductsBookingProductsOnObserve: true));

      final productIds = state.listOfBookingProductsFromReorders.map((e) => e.productId).toList();
      final failureOrSuccess = await productRepository.getListOfProductsByIds(productIds);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (listOfProducts) {
          emit(state.copyWith(listOfAllProducts: listOfProducts, firebaseFailure: null, isAnyFailure: false));
        },
      );

      emit(state.copyWith(
        isLoadingProductsBookingProductsOnObserve: false,
        fosProductsBookingProductsOnObserveOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosProductsBookingProductsOnObserveOption: none()));
    });

//? #########################################################################

    on<OnProductsBookingSelectAllReorderProductsEvent>((event, emit) {
      List<BookingProduct> bookingProducts = [];
      bool isSelectedAll = false;
      if (event.isSelected) {
        isSelectedAll = true;
        bookingProducts = List.from(state.listOfBookingProductsFromReorders);
      }
      emit(state.copyWith(isAllReorderProductsSelected: isSelectedAll, selectedReorderProducts: bookingProducts));
    });

//? #########################################################################

    on<OnProductsBookingSelectReorderProductEvent>((event, emit) {
      List<BookingProduct> bookingProducts = List.from(state.selectedReorderProducts);
      if (bookingProducts.any((e) => e.id == event.bookingProduct.id)) {
        bookingProducts.removeWhere((e) => e.id == event.bookingProduct.id);
      } else {
        bookingProducts.add(event.bookingProduct);
      }

      final isAllBookingProductsSelected = state.listOfBookingProductsFromReorders.every((e) => bookingProducts.any((f) => f.id == e.id));

      emit(state.copyWith(isAllReorderProductsSelected: isAllBookingProductsSelected, selectedReorderProducts: bookingProducts));
    });

//? #########################################################################

    on<OnProductsBookingSetBookingProductsFromReorderEvent>((event, emit) {
      List<TextEditingController> newQuantityControllers = [];
      for (final reorderProduct in state.selectedReorderProducts) {
        newQuantityControllers.add(TextEditingController(text: reorderProduct.toBookQuantity.toString()));
      }
      emit(state.copyWith(listOfSelectedProducts: state.selectedReorderProducts, quantityControllers: newQuantityControllers));
    });

//? #########################################################################

    on<OnProductsBookingQuantityControllerChangedEvent>((event, emit) {
      List<BookingProduct> listOfSelectedProducts = List.from(state.listOfSelectedProducts);
      for (int i = 0; i < listOfSelectedProducts.length; i++) {
        listOfSelectedProducts[i] = listOfSelectedProducts[i].copyWith(toBookQuantity: state.quantityControllers[i].text.toMyInt());
      }

      for (var element in state.listOfSelectedProducts) {
        print(element.toBookQuantity);
      }

      emit(state.copyWith(listOfSelectedProducts: listOfSelectedProducts));
    });

//? #########################################################################

    on<OnProductsBookingRemoveFromSelectedReorderProductsEvent>((event, emit) {
      List<TextEditingController> updatedQuantityControllers = List.from(state.quantityControllers);
      List<BookingProduct> updatedSelectedReorderProducts = List.from(state.selectedReorderProducts);
      final index = updatedSelectedReorderProducts.indexWhere((e) => e.id == event.bookingProduct.id);
      if (index == -1) return;

      updatedQuantityControllers.removeAt(index);
      updatedSelectedReorderProducts.removeAt(index);

      emit(state.copyWith(
        listOfSelectedProducts: updatedSelectedReorderProducts,
        selectedReorderProducts: updatedSelectedReorderProducts,
        quantityControllers: updatedQuantityControllers,
      ));
    });

//? #########################################################################

    //? #########################################################################

    on<OnProductsBookingSetReorderFilterEvent>((event, emit) {
      emit(state.copyWith(reorderFilter: event.reorderNumber));
      add(ProductsBookingFilterReordersEvent());
    });

//? #########################################################################

    on<OnProductsBookingSaveEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductsBookingOnUpdate: true));

      final failureOrSuccess = await reorderRepository.updateReordersFromProductsBooking(state.listOfSelectedProducts);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (listOfReorder) {
          emit(state.copyWith(selectedReorderProducts: [], listOfSelectedProducts: [], firebaseFailure: null, isAnyFailure: false));
          add(ProductsBookingGetReordersEvent(afterUpdate: true));
          add(ProductsBookingGetProductsEvent());
        },
      );

      emit(state.copyWith(
        reorderFilter: '',
        isLoadingProductsBookingOnUpdate: false,
        fosProductsBookingOnUpdateOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosProductsBookingOnUpdateOption: none()));
    });

//? #########################################################################

//? #########################################################################

//? #########################################################################
  }
}
