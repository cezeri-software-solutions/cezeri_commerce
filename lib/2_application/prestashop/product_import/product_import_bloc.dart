import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../3_domain/entities_presta/product_presta.dart';
import '../../../3_domain/repositories/prestashop/product/product_import_repository.dart';
import '../../../core/presta_failure.dart';

part 'product_import_event.dart';
part 'product_import_state.dart';

class ProductImportBloc extends Bloc<ProductImportEvent, ProductImportState> {
  final ProductImportRepository productImportRepository;

  ProductImportBloc({required this.productImportRepository}) : super(ProductImportState.initial()) {
//? #########################################################################

    on<SetProducImportStateToInitialEvent>((event, emit) {
      emit(ProductImportState.initial());
    });

//? #########################################################################

    on<GetAllProductsFromPrestaEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductsPrestaOnObserve: true));

      final failureOrSuccess = await productImportRepository.getAllProductsFromPrestashop();
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(prestaFailure: failure, isAnyFailure: true)),
        (listOfProductPresta) => emit(state.copyWith(listOfProductPresta: listOfProductPresta, prestaFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingProductsPrestaOnObserve: false,
        fosProductsPrestaOnObserveOption: optionOf(failureOrSuccess),
      ));
    });

//? #########################################################################

    on<GetProductByIdFromPrestaEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductPrestaOnObserve: true));

      final failureOrSuccess = await productImportRepository.getProductByIdFromPrestashop(event.id, event.marketplace);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(prestaFailure: failure, isAnyFailure: true)),
        (productPresta) => emit(state.copyWith(productPresta: productPresta, prestaFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingProductPrestaOnObserve: false,
        fosProductPrestaOnObserveOption: optionOf(failureOrSuccess),
      ));
    });

//? #########################################################################
//? #########################################################################
//? #########################################################################
//? #########################################################################
//? #########################################################################
  }
}
