import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/3_domain/enums/enums.dart';
import 'package:dartz/dartz.dart';

import '../../../3_domain/entities/product/booking_product.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/reorder/reorder.dart';
import '../../../3_domain/repositories/firebase/product_repository.dart';
import '../../../3_domain/repositories/firebase/reorder_repository.dart';
import '../../../core/firebase_failures.dart';

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
        },
      );

      emit(state.copyWith(
        isLoadingProductsBookingReordersOnObserve: false,
        fosProductsBookingReordersOnObserveOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosProductsBookingReordersOnObserveOption: none()));
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
      List<BookingProduct> bookingProducts = List.from(state.listOfBookingProductsFromReorders);
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
      emit(state.copyWith(listOfSelectedProducts: state.selectedReorderProducts));
    });

//? #########################################################################

//? #########################################################################

//? #########################################################################

//? #########################################################################
  }
}
