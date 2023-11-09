import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/3_domain/entities/receipt/receipt_product.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../3_domain/entities/customer/customer.dart';
import '../../3_domain/entities/product/product.dart';
import '../../3_domain/entities/receipt/receipt.dart';
import '../../3_domain/enums/enums.dart';
import '../../3_domain/repositories/firebase/customer_repository.dart';
import '../../3_domain/repositories/firebase/packing_station_repository.dart';
import '../../3_domain/repositories/firebase/receipt_respository.dart';
import '../../core/firebase_failures.dart';

part 'packing_station_event.dart';
part 'packing_station_state.dart';

class PackingStationBloc extends Bloc<PackingStationEvent, PackingStationState> {
  final ReceiptRepository receiptRepository;
  final CustomerRepository customerRepository;
  final PackingStationRepository packingStationRepository;

  PackingStationBloc({
    required this.receiptRepository,
    required this.customerRepository,
    required this.packingStationRepository,
  }) : super(PackingStationState.initial()) {
//? #########################################################################

    on<SetPackingStationStateToInitialEvent>((event, emit) {
      emit(PackingStationState.initial());
    });

//? #########################################################################

    on<PackgingStationGetAppointmentEvent>((event, emit) async {
      emit(state.copyWith(isLoadingAppointmentOnObserve: true));

      final failureOrSuccess = await receiptRepository.getAppointment(event.appointment);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (loadedAppointment) async {
          emit(state.copyWith(originalAppointment: loadedAppointment, firebaseFailure: null, isAnyFailure: false));
          add(PackingStationSetAppointFromOriginalEvent());
        },
      );

      Customer? customer;
      if (state.originalAppointment != null) {
        final fosCustomer = await customerRepository.getCustomerById(state.originalAppointment!.customerId);
        if (fosCustomer.isRight()) {
          customer = fosCustomer.foldRight(customer, (r, previous) => customer = r);
        }
      }

      emit(state.copyWith(
        customer: customer ?? Customer.empty(),
        isLoadingAppointmentOnObserve: false,
        fosAppointmentOnObserveOption: optionOf(failureOrSuccess),
      ));
    });

//? #########################################################################

    on<PackgingStationGetAppointmentsEvent>((event, emit) async {
      emit(state.copyWith(isLoadingAppointmentsOnObserve: true));

      final failureOrSuccess = await receiptRepository.getListOfReceipts(0, ReceiptTyp.appointment);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (loadedAppointment) {
          emit(state.copyWith(listOfAllAppointments: loadedAppointment, firebaseFailure: null, isAnyFailure: false));
          add(PackingStationFilterAppointmentsEvent());
        },
      );

      emit(state.copyWith(
        isLoadingAppointmentsOnObserve: false,
        fosAppointmentsOnObserveOption: optionOf(failureOrSuccess),
      ));
    });

//? #########################################################################

    on<SetPackingStationFilterAppointmentsEvent>((event, emit) {
      emit(state.copyWith(packingStationFilter: event.packingStationFilter));
      add(PackgingStationGetAppointmentsEvent());
    });

//? #########################################################################

    on<PackingStationFilterAppointmentsEvent>((event, emit) {
      final filteredAppointments = switch (state.packingStationFilter) {
        PackingStationFilter.paid => state.listOfAllAppointments!.where((e) => e.paymentStatus == PaymentStatus.paid).toList(),
        PackingStationFilter.picked => state.listOfAllAppointments!.where((e) => e.isPicked).toList(),
        PackingStationFilter.all => state.listOfAllAppointments!,
      };

      filteredAppointments.sort((a, b) => b.appointmentId.compareTo(a.appointmentId));

      emit(state.copyWith(listOfFilteredAppointments: filteredAppointments));
    });

//? #########################################################################

    on<PackingsStationOnAllAppointmentsSelectedEvent>((event, emit) async {
      List<Receipt> receipts = [];
      bool isSelectedAll = false;
      if (event.isSelected) {
        isSelectedAll = true;
        receipts = List.from(state.listOfFilteredAppointments);
      }
      emit(state.copyWith(isAllReceiptsSelected: isSelectedAll, selectedAppointments: receipts));
    });

//? #########################################################################

    on<PackingsStationOnAppointmentSelectedEvent>((event, emit) async {
      List<Receipt> receipts = List.from(state.selectedAppointments);
      if (receipts.any((e) => e.id == event.appointment.id)) {
        receipts.removeWhere((e) => e.id == event.appointment.id);
      } else {
        receipts.add(event.appointment);
      }
      emit(state.copyWith(
        isAllReceiptsSelected:
            state.isAllReceiptsSelected && receipts.length < state.selectedAppointments.length ? false : state.isAllReceiptsSelected,
        selectedAppointments: receipts,
      ));
    });

//? #########################################################################

    on<PackingsStationGetProductsFromFirestoreEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductsOnObserve: true));

      final failureOrSuccess = await packingStationRepository.getListOfProducts(event.productIds);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (loadedProducts) {
          emit(state.copyWith(listOfProducts: loadedProducts, firebaseFailure: null, isAnyFailure: false));
        },
      );

      emit(state.copyWith(
        isLoadingProductsOnObserve: false,
        fosProductsOnObserveOption: optionOf(failureOrSuccess),
      ));
    });

//? #########################################################################

    on<PackingStationOnPickingQuantityChanged>((event, emit) async {
      if (event.pickCompletely) {
        List<ReceiptProduct> receiptProducts = List.from(state.appointment!.listOfReceiptProduct);
        final updatedReceiptProduct = receiptProducts[event.index].copyWith(shippedQuantity: receiptProducts[event.index].quantity);
        receiptProducts[event.index] = updatedReceiptProduct;
        emit(state.copyWith(appointment: state.appointment!.copyWith(listOfReceiptProduct: receiptProducts)));
        return;
      }

      if (!event.isSubtract) {
        List<ReceiptProduct> receiptProducts = List.from(state.appointment!.listOfReceiptProduct);
        final updatedReceiptProduct = receiptProducts[event.index].copyWith(
            shippedQuantity: receiptProducts[event.index].shippedQuantity < receiptProducts[event.index].quantity
                ? receiptProducts[event.index].shippedQuantity + 1
                : receiptProducts[event.index].shippedQuantity);
        receiptProducts[event.index] = updatedReceiptProduct;
        emit(state.copyWith(appointment: state.appointment!.copyWith(listOfReceiptProduct: receiptProducts)));
        return;
      }

      if (event.isSubtract) {
        List<ReceiptProduct> receiptProducts = List.from(state.appointment!.listOfReceiptProduct);
        final updatedReceiptProduct = receiptProducts[event.index].copyWith(
            shippedQuantity: receiptProducts[event.index].shippedQuantity > 0
                ? receiptProducts[event.index].shippedQuantity - 1
                : receiptProducts[event.index].shippedQuantity);
        receiptProducts[event.index] = updatedReceiptProduct;
        emit(state.copyWith(appointment: state.appointment!.copyWith(listOfReceiptProduct: receiptProducts)));
        return;
      }
    });

//? #########################################################################

    on<PackingStationOnPickAllEvent>((event, emit) async {
      List<ReceiptProduct> receiptProducts = state.appointment!.listOfReceiptProduct.map((e) {
        return e.copyWith(shippedQuantity: e.quantity);
      }).toList();
      emit(state.copyWith(appointment: state.appointment!.copyWith(listOfReceiptProduct: receiptProducts)));
    });

//? #########################################################################

    on<PackingStationClearControllerEvent>((event, emit) async {
      emit(state.copyWith(barcodeScannerController: TextEditingController()));
    });

//? #########################################################################

    on<PackingStationIsPartiallyEnabledEvent>((event, emit) async {
      emit(state.copyWith(isPartiallyEnabled: !state.isPartiallyEnabled));
    });

//? #########################################################################

    on<PackingStationGenerateFromAppointmentEvent>((event, emit) async {
      emit(state.copyWith(isLoadingOnGenerateAppointments: true));

      final failureOrSuccess = await receiptRepository.generateFromAppointment(
        state.appointment!,
        state.originalAppointment!,
        true,
        event.generateInvoice,
      );
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (receipt) {
          emit(state.copyWith(firebaseFailure: null, isAnyFailure: false));
          add(PackgingStationGetAppointmentsEvent());
        },
      );

      emit(state.copyWith(
        isLoadingOnGenerateAppointments: false,
        fosOnGenerateAppointmentsOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosOnGenerateAppointmentsOption: none()));
    });

//? #########################################################################
//? #########################################################################
//? #########################################################################

    on<PackingStationSetAppointFromOriginalEvent>((event, emit) async {
      if (state.originalAppointment!.listOfReceiptProduct.every((e) => e.shippedQuantity == 0)) {
        emit(state.copyWith(appointment: state.originalAppointment));
        return;
      } else {
        emit(state.copyWith(appointment: Receipt.genPartial(GenType.partialRest, state.originalAppointment!)));
      }
    });
  }
}
