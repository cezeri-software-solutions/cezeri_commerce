import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/3_domain/entities/picklist/picklist_product.dart';
import 'package:cezeri_commerce/3_domain/entities/receipt/receipt_product.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../1_presentation/core/core.dart';
import '../../3_domain/entities/customer/customer.dart';
import '../../3_domain/entities/picklist/picklist.dart';
import '../../3_domain/entities/product/product.dart';
import '../../3_domain/entities/receipt/receipt.dart';
import '../../3_domain/entities/settings/packaging_box.dart';
import '../../3_domain/enums/enums.dart';
import '../../3_domain/repositories/database/customer_repository.dart';
import '../../3_domain/repositories/database/packing_station_repository.dart';
import '../../3_domain/repositories/database/receipt_repository.dart';
import '../../failures/abstract_failure.dart';

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

      final failureOrSuccess = await receiptRepository.getReceipt(event.appointment.id, event.appointment.receiptTyp);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (loadedAppointment) async {
          final listOfPackagingBoxes = event.listOfPackagingBoxes;
          if (!listOfPackagingBoxes.any((e) => e.name == '')) listOfPackagingBoxes.insert(0, PackagingBox.empty());
          emit(state.copyWith(
            originalAppointment: loadedAppointment,
            listOfPackagingBoxes: listOfPackagingBoxes,
            firebaseFailure: null,
            isAnyFailure: false,
          ));
          add(PackingStationSetAppointFromOriginalEvent());
          add(PackingStationfindSmallestPackagingBoxEvent());
        },
      );

      Customer? customer;
      if (state.originalAppointment != null) {
        final fosCustomer = await customerRepository.getCustomer(state.originalAppointment!.customerId);
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

      final failureOrSuccess = await receiptRepository.getListOfReceipts(0, ReceiptType.appointment, sortOutDeliveryBlocked: true);
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
        PackingStationFilter.paid => state.listOfAllAppointments!.where((e) => e.paymentStatus == PaymentStatus.paid && !e.isPicked).toList(),
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
          add(PackingStationfindSmallestPackagingBoxEvent());
        },
      );

      emit(state.copyWith(
        isLoadingProductsOnObserve: false,
        fosProductsOnObserveOption: optionOf(failureOrSuccess),
      ));
    });

//? #########################################################################

    on<PackingStationOnPickingQuantityChanged>((event, emit) async {
      if (!state.shouldScan) return;
      double getWeight(List<ReceiptProduct> receiptProducts) {
        double weight = 0.0;
        for (final receiptProduct in receiptProducts) {
          weight += receiptProduct.weight * receiptProduct.shippedQuantity;
        }
        return (weight + state.packagingBox.weight).toMyRoundedDouble();
      }

      if (event.pickCompletely) {
        List<ReceiptProduct> receiptProducts = List.from(state.appointment!.listOfReceiptProduct);
        final updatedReceiptProduct = receiptProducts[event.index].copyWith(shippedQuantity: receiptProducts[event.index].quantity);
        receiptProducts[event.index] = updatedReceiptProduct;
        emit(state.copyWith(
            appointment: state.appointment!.copyWith(listOfReceiptProduct: receiptProducts, weight: getWeight(receiptProducts)),
            weightController: TextEditingController(text: getWeight(receiptProducts).toString())));

        add(PackingStationfindSmallestPackagingBoxEvent());
        return;
      }

      if (!event.isSubtract) {
        List<ReceiptProduct> receiptProducts = List.from(state.appointment!.listOfReceiptProduct);
        final updatedReceiptProduct = receiptProducts[event.index].copyWith(
            shippedQuantity: receiptProducts[event.index].shippedQuantity < receiptProducts[event.index].quantity
                ? receiptProducts[event.index].shippedQuantity + 1
                : receiptProducts[event.index].shippedQuantity);
        receiptProducts[event.index] = updatedReceiptProduct;
        emit(state.copyWith(
            appointment: state.appointment!.copyWith(listOfReceiptProduct: receiptProducts, weight: getWeight(receiptProducts)),
            weightController: TextEditingController(text: getWeight(receiptProducts).toString())));

        add(PackingStationfindSmallestPackagingBoxEvent());
        return;
      }

      if (event.isSubtract) {
        List<ReceiptProduct> receiptProducts = List.from(state.appointment!.listOfReceiptProduct);
        final updatedReceiptProduct = receiptProducts[event.index].copyWith(
            shippedQuantity: receiptProducts[event.index].shippedQuantity > 0
                ? receiptProducts[event.index].shippedQuantity - 1
                : receiptProducts[event.index].shippedQuantity);
        receiptProducts[event.index] = updatedReceiptProduct;
        emit(state.copyWith(
            appointment: state.appointment!.copyWith(listOfReceiptProduct: receiptProducts, weight: getWeight(receiptProducts)),
            weightController: TextEditingController(text: getWeight(receiptProducts).toString())));

        add(PackingStationfindSmallestPackagingBoxEvent());
        return;
      }
    });

//? #########################################################################

    on<PackingStationOnPickAllEvent>((event, emit) async {
      double getWeight(List<ReceiptProduct> receiptProducts) {
        double weight = 0.0;
        for (final receiptProduct in receiptProducts) {
          weight += receiptProduct.weight * receiptProduct.shippedQuantity;
        }
        return (weight + state.packagingBox.weight).toMyRoundedDouble();
      }

      List<ReceiptProduct> receiptProducts = state.appointment!.listOfReceiptProduct.map((e) {
        return e.copyWith(shippedQuantity: e.quantity);
      }).toList();
      emit(state.copyWith(
        appointment: state.appointment!.copyWith(listOfReceiptProduct: receiptProducts, weight: getWeight(receiptProducts)),
        weightController: TextEditingController(text: getWeight(receiptProducts).toString()),
      ));

      add(PackingStationfindSmallestPackagingBoxEvent());
    });

//? #########################################################################

    on<PackingStationIsPartiallyEnabledEvent>((event, emit) async {
      emit(state.copyWith(isPartiallyEnabled: !state.isPartiallyEnabled));
    });

//? #########################################################################

    on<PackingStationGenerateFromAppointmentEvent>((event, emit) async {
      emit(state.copyWith(isLoadingOnGenerateAppointments: true));

      final appointment = state.appointment!.copyWith(
        packagingBox: state.packagingBox.name != '' ? state.packagingBox : state.appointment!.packagingBox,
      );
      final originalAppointment = state.originalAppointment!.copyWith(
        packagingBox: state.packagingBox.name != '' ? state.packagingBox : state.originalAppointment!.packagingBox,
        weight: state.appointment!.weight,
      );

      final failureOrSuccess = await receiptRepository.generateFromAppointment(
        appointment,
        originalAppointment,
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

    on<PackingStationOnWeightControllerChangedEvent>((event, emit) async {
      emit(state.copyWith(appointment: state.appointment!.copyWith(weight: state.weightController.text.toMyDouble())));
    });

//? #########################################################################

    on<PackingStationOnPackagingBoxChangedEvent>((event, emit) async {
      final packingBox = state.listOfPackagingBoxes.where((e) => e.name == event.packagingBoxName).first;
      emit(state.copyWith(
        appointment: state.appointment!.copyWith(packagingBox: packingBox, weight: state.appointment!.weight + packingBox.weight),
        packagingBox: packingBox,
        weightController: TextEditingController(text: (state.appointment!.weight + packingBox.weight).toMyRoundedDouble().toString()),
      ));
    });

//? #########################################################################

    on<PackingStationfindSmallestPackagingBoxEvent>((event, emit) async {
      bool canProductFitInPackagingBox(Product product, PackagingBox box) {
        // Überprüft, ob das Item in irgendeiner Orientierung in die Box passt
        final boxDim = box.dimensionsInside;
        return (product.depth <= boxDim.length && product.width <= boxDim.width && product.height <= boxDim.height) ||
            (product.width <= boxDim.length && product.height <= boxDim.width && product.depth <= boxDim.height) ||
            (product.height <= boxDim.length && product.depth <= boxDim.width && product.width <= boxDim.height);
      }

      PackagingBox? findSmallestPackagingBox(List<Product>? products, List<PackagingBox> boxes, {Function(double)? remainingVolumePercentCallback}) {
        if (products == null) return null;
        print('1: ${products.length}');

        double totalVolumeOfProducts = products.fold(0, (sum, item) => sum + item.volume);
        boxes.sort((a, b) => a.dimensionsInside.volume.compareTo(b.dimensionsInside.volume));

        for (final box in boxes) {
          if (products.every((item) => canProductFitInPackagingBox(item, box))) {
            double remainingVolumePercent = ((box.dimensionsInside.volume - totalVolumeOfProducts) / box.dimensionsInside.volume) * 100;
            if (remainingVolumePercentCallback != null) {
              remainingVolumePercentCallback(remainingVolumePercent.toMyRoundedDouble());
            }
            return box;
          }
        }
        return null;
      }

      List<Product> getListOfFirestoreProductsPartial(List<Product> products, List<ReceiptProduct> receiptProducts) {
        List<Product> toReturnProducts = [];
        for (final receiptProduct in receiptProducts) {
          final product = products.where((e) => e.id == receiptProduct.productId).firstOrNull;
          if (product == null) continue;
          for (int i = 0; i < (receiptProduct.quantity - receiptProduct.shippedQuantity); i++) {
            toReturnProducts.add(product);
          }
        }
        return toReturnProducts;
      }

      List<Product> getListOfFirestoreProducts(List<Product> products, List<ReceiptProduct> receiptProducts) {
        List<Product> toReturnProducts = [];
        for (final receiptProduct in receiptProducts) {
          final product = products.where((e) => e.id == receiptProduct.productId).firstOrNull;
          if (product == null) continue;
          for (int i = 0; i < receiptProduct.quantity; i++) {
            toReturnProducts.add(product);
          }
        }
        return toReturnProducts;
      }

      final toCalculateProducts = switch (state.listOfProducts) {
        null => null,
        _ => switch (state.appointment) {
            null => null,
            _ => switch (state.appointment!.listOfReceiptProduct.every((e) => e.shippedQuantity == 0)) {
                true => getListOfFirestoreProducts(state.listOfProducts!, state.appointment!.listOfReceiptProduct),
                _ => getListOfFirestoreProductsPartial(state.listOfProducts!, state.appointment!.listOfReceiptProduct),
              }
          }
      };

      double remainingVolumePercent = 0;
      final smallesPackagingBox =
          findSmallestPackagingBox(toCalculateProducts, state.listOfPackagingBoxes, remainingVolumePercentCallback: (double percent) {
        remainingVolumePercent = percent;
      });
      final selectedPackagingBox = smallesPackagingBox != null
          ? state.listOfPackagingBoxes.where((e) => e.id == smallesPackagingBox.id).firstOrNull ?? state.packagingBox
          : state.packagingBox;

      emit(state.copyWith(
        smallesPackagingBox: smallesPackagingBox,
        packagingBox: selectedPackagingBox,
        remainingVolumePercent: remainingVolumePercent,
      ));
    });

//? #########################################################################
//? #########################################################################
//? #########################################################################

    on<PackingStationSetAppointFromOriginalEvent>((event, emit) async {
      if (state.originalAppointment!.listOfReceiptProduct.every((e) => e.shippedQuantity == 0)) {
        emit(
          state.copyWith(
            appointment: state.originalAppointment,
            weightController: TextEditingController(text: state.originalAppointment!.weight.toString()),
          ),
        );
        return;
      } else {
        emit(
          state.copyWith(
            appointment: Receipt.genPartial(GenType.partialRest, state.originalAppointment!),
            weightController: TextEditingController(text: Receipt.genPartial(GenType.partialRest, state.originalAppointment!).weight.toString()),
          ),
        );
      }
    });

//? #########################################################################
//? ############################ Picklist ###################################
//? #########################################################################

    on<PicklistOnCreatePicklistEvent>((event, emit) async {
      if (state.selectedAppointments.isEmpty) {
        showMyDialogAlert(
          context: event.context,
          title: 'Achtung!',
          content: 'Bitte wähle mindestens einen Auftrag zum Erstellen einer Pickliste aus.',
        );
        return;
      }
      emit(state.copyWith(isLoadingPicklistOnCreate: true));

      final failureOrSuccess = await packingStationRepository.createPicklist(state.selectedAppointments);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (picklist) => emit(state.copyWith(picklist: picklist, firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        selectedAppointments: [],
        isLoadingPicklistOnCreate: false,
        fosPicklistOnCreateOption: optionOf(failureOrSuccess),
      ));
    });

//? #########################################################################

    on<PicklistOnSetPicklistEvent>((event, emit) async {
      emit(state.copyWith(picklist: event.picklist));
    });

//? #########################################################################

    on<PicklistGetPicklistsEvent>((event, emit) async {
      emit(state.copyWith(isLoadingPicklistsOnObserve: true));

      final failureOrSuccess = await packingStationRepository.getListOfPicklists();
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (picklists) {
          final sortedPicklist = picklists..sort((a, b) => b.creationDate.compareTo(a.creationDate));
          emit(state.copyWith(listOfPicklists: sortedPicklist, firebaseFailure: null, isAnyFailure: false));
        },
      );

      emit(state.copyWith(
        isLoadingPicklistsOnObserve: false,
        fosPicklistsOnObserveOption: optionOf(failureOrSuccess),
      ));
    });

//? #########################################################################

    on<PicklistOnUpdatePicklistEvent>((event, emit) async {
      emit(state.copyWith(isLoadingPicklistOnUpdate: true));

      final failureOrSuccess = await packingStationRepository.updatePicklist(state.picklist!);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (_) {
          if (state.listOfPicklists != null && state.picklist != null) {
            final index = state.listOfPicklists!.indexWhere((e) => e.id == state.picklist!.id);
            if (index != -1) {
              List<Picklist> updatedList = List<Picklist>.from(state.listOfPicklists!);
              updatedList[index] = state.picklist!;
              emit(state.copyWith(listOfPicklists: updatedList));
            }
          }
          emit(state.copyWith(firebaseFailure: null, isAnyFailure: false));
        },
      );

      emit(state.copyWith(
        isLoadingPicklistOnUpdate: false,
        fosPicklistOnUpdateOption: optionOf(failureOrSuccess),
      ));
    });

//? #########################################################################

    on<PicklistOnPicklistQuantityChanged>((event, emit) async {
      if (event.pickCompletely) {
        List<PicklistProduct> picklistProducts = List.from(state.picklist!.listOfPicklistProducts);
        final updatedPicklistProduct = picklistProducts[event.index].copyWith(pickedQuantity: picklistProducts[event.index].quantity);
        picklistProducts[event.index] = updatedPicklistProduct;
        emit(state.copyWith(picklist: state.picklist!.copyWith(listOfPicklistProducts: picklistProducts)));
        return;
      }

      if (!event.isSubtract) {
        List<PicklistProduct> picklistProducts = List.from(state.picklist!.listOfPicklistProducts);
        final updatedPicklistProduct = picklistProducts[event.index].copyWith(
            pickedQuantity: picklistProducts[event.index].pickedQuantity < picklistProducts[event.index].quantity
                ? picklistProducts[event.index].pickedQuantity + 1
                : picklistProducts[event.index].pickedQuantity);
        picklistProducts[event.index] = updatedPicklistProduct;
        emit(state.copyWith(picklist: state.picklist!.copyWith(listOfPicklistProducts: picklistProducts)));
        return;
      }

      if (event.isSubtract) {
        List<PicklistProduct> picklistProducts = List.from(state.picklist!.listOfPicklistProducts);
        final updatedPicklistProduct = picklistProducts[event.index].copyWith(
            pickedQuantity: picklistProducts[event.index].pickedQuantity > 0
                ? picklistProducts[event.index].pickedQuantity - 1
                : picklistProducts[event.index].pickedQuantity);
        picklistProducts[event.index] = updatedPicklistProduct;
        emit(state.copyWith(picklist: state.picklist!.copyWith(listOfPicklistProducts: picklistProducts)));
        return;
      }
    });

//? #########################################################################

    on<PicklistOnPickAllQuantityEvent>((event, emit) async {
      List<PicklistProduct> picklistProducts = state.picklist!.listOfPicklistProducts.map((e) {
        return e.copyWith(pickedQuantity: e.quantity);
      }).toList();
      emit(state.copyWith(picklist: state.picklist!.copyWith(listOfPicklistProducts: picklistProducts)));
    });

//? #########################################################################

    on<PackingSationSetShouldScanEvent>((event, emit) {
      emit(state.copyWith(shouldScan: event.value));
    });

//? #########################################################################

    on<PackingStationOnEanScannedEvent>((event, emit) async {
      if (!state.shouldScan) return;
      final product = state.listOfProducts!.where((e) => e.ean == event.ean).firstOrNull;

      if (product == null) {
        add(PackingSationSetShouldScanEvent(value: false));
        await showMyDialogAlert(context: event.context, title: 'Achtung', content: 'Kein Artikel mit der EAN: ${event.ean} im Auftrag vorhanden!');
        add(PackingSationSetShouldScanEvent(value: true));
        return;
      }

      final receiptProduct = state.appointment!.listOfReceiptProduct.where((e) => e.productId == product.id).firstOrNull;

      if (receiptProduct == null) {
        add(PackingSationSetShouldScanEvent(value: false));
        await showMyDialogAlert(context: event.context, title: 'Achtung', content: 'Kein Artikel mit der EAN: ${event.ean} im Auftrag vorhanden!');
        add(PackingSationSetShouldScanEvent(value: true));
        return;
      }

      if (receiptProduct.shippedQuantity >= receiptProduct.quantity) {
        add(PackingSationSetShouldScanEvent(value: false));
        await showMyDialogAlert(
          context: event.context,
          title: 'Achtung',
          content: 'Der Artikel \n\n${receiptProduct.name}\n\n ist bereits vollständig gepackt!',
        );
        add(PackingSationSetShouldScanEvent(value: true));
        return;
      }

      final index = state.appointment!.listOfReceiptProduct.indexWhere((e) => e.productId == receiptProduct.productId);
      add(PackingStationOnPickingQuantityChanged(index: index, isSubtract: false, pickCompletely: false));
    });

//? #########################################################################
  }
}
