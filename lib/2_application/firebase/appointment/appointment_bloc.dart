import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/3_domain/repositories/firebase/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../3_domain/entities/address.dart';
import '../../../3_domain/entities/carrier/carrier_product.dart';
import '../../../3_domain/entities/carrier/parcel_tracking.dart';
import '../../../3_domain/entities/customer/customer.dart';
import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/receipt/load_appointments_helper/to_load_appointments_from_marketplace.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/entities/receipt/receipt_carrier.dart';
import '../../../3_domain/entities/receipt/receipt_marketplace.dart';
import '../../../3_domain/entities/receipt/receipt_product.dart';
import '../../../3_domain/entities/settings/payment_method.dart';
import '../../../3_domain/repositories/firebase/receipt_respository.dart';
import '../../../core/abstract_failure.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final ReceiptRepository receiptRepository;
  final ProductRepository productRepository;

  AppointmentBloc({required this.receiptRepository, required this.productRepository}) : super(AppointmentState.initial()) {
//? #########################################################################

    on<SetAppointmentStateToInitialEvent>((event, emit) {
      emit(AppointmentState.initial());
    });

//? #########################################################################

    on<GetAppointmentEvent>((event, emit) async {
      emit(state.copyWith(isLoadingReceiptOnObserve: true));

      final failureOrSuccess = await receiptRepository.getReceipt(event.appointment);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (loadedAppointment) => emit(state.copyWith(receipt: loadedAppointment, firebaseFailure: null, isAnyFailure: false)),
      );

      add(OnSearchFieldSubmittedAppointmentsEvent());

      emit(state.copyWith(
        isLoadingReceiptOnObserve: false,
        fosReceiptOnObserveOption: optionOf(failureOrSuccess),
      ));
    });

//? #########################################################################

    on<SetAppointmentEvent>((event, emit) async {
      emit(state.copyWith(receipt: event.appointment, isAnyFailure: false, firebaseFailure: null));
    });

//? #########################################################################

    on<GetReceiptsEvent>((event, emit) async {
      emit(state.copyWith(isLoadingReceiptsOnObserve: true));

      final failureOrSuccess = await receiptRepository.getListOfReceipts(event.tabValue, event.receiptTyp);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (listOfAppointments) {
          listOfAppointments.sort((a, b) => switch (listOfAppointments.first.receiptTyp) {
                ReceiptTyp.offer => b.offerId.compareTo(a.offerId),
                ReceiptTyp.appointment => b.appointmentId.compareTo(a.appointmentId),
                ReceiptTyp.deliveryNote => b.deliveryNoteId.compareTo(a.deliveryNoteId),
                ReceiptTyp.invoice || ReceiptTyp.credit => b.invoiceId.compareTo(a.invoiceId),
              });
          emit(state.copyWith(
            listOfAllReceipts: listOfAppointments,
            isExpanded: List<bool>.filled(listOfAppointments.length, false),
            firebaseFailure: null,
            isAnyFailure: false,
            tabValue: event.tabValue,
            receiptTyp: event.receiptTyp,
          ));

          add(OnSearchFieldSubmittedAppointmentsEvent());
        },
      );

      emit(state.copyWith(
        isLoadingReceiptsOnObserve: false,
        fosReceiptsOnObserveOption: optionOf(failureOrSuccess),
      ));
    });

//? #########################################################################

    on<GetNewAppointmentByIdFromPrestaEvent>((event, emit) async {
      final logger = Logger();
      bool isSuccess = true;
      emit(state.copyWith(
        isLoadingAppointmentFromPrestaOnObserve: true,
        loadedAppointments: 1,
        numberOfToLoadAppointments: 1,
        loadingText: 'Bestellung wird geladen',
      ));

      List<LoadedOrderFromMarketplace> listOfLoadedOrderFromMarketplace = [];

      final toLoadOrderFromMarketplace = ToLoadAppointmentFromMarketplace(marketplace: event.marketplace, orderId: event.id);
      final fosLoadedAppointmentFromMarketplace = await receiptRepository.loadAppointmentsFromMarketplace(toLoadOrderFromMarketplace);
      fosLoadedAppointmentFromMarketplace.fold(
        (failure) {
          logger.e(failure);
          isSuccess = false;
        },
        (loadedOrderFromMarketplace) {
          listOfLoadedOrderFromMarketplace.add(loadedOrderFromMarketplace);
          emit(state.copyWith(loadedAppointments: state.loadedAppointments + 1));
        },
      );

      emit(state.copyWith(loadedAppointments: 0, loadingText: 'Lädt Bestellungen zu Cezeri Commerce hoch...'));

      List<Receipt> listWithNewAppointments = List.from(state.listOfAllReceipts ?? []);
      for (final toUploadAppointment in listOfLoadedOrderFromMarketplace) {
        final fosLoadedAppointment = await receiptRepository.uploadLoadedAppointmentToFirestore(toUploadAppointment);
        fosLoadedAppointment.fold(
          (failure) {
            logger.e(failure);
            isSuccess = false;
          },
          (loadedAppointment) {
            listWithNewAppointments.add(loadedAppointment);
            emit(state.copyWith(loadedAppointments: state.loadedAppointments + 1));
          },
        );
      }

      listWithNewAppointments.sort((a, b) => switch (listWithNewAppointments.first.receiptTyp) {
            ReceiptTyp.offer => b.offerId.compareTo(a.offerId),
            ReceiptTyp.appointment => b.appointmentId.compareTo(a.appointmentId),
            ReceiptTyp.deliveryNote => b.deliveryNoteId.compareTo(a.deliveryNoteId),
            ReceiptTyp.invoice || ReceiptTyp.credit => b.invoiceId.compareTo(a.invoiceId),
          });
      emit(state.copyWith(
        listOfAllReceipts: listWithNewAppointments,
        isExpanded: List<bool>.filled(listWithNewAppointments.length, false),
        firebaseFailure: null,
        isAnyFailure: false,
      ));

      add(OnSearchFieldSubmittedAppointmentsEvent());

      emit(state.copyWith(
        isLoadingAppointmentFromPrestaOnObserve: false,
        fosAppointmentOnObserveFromMarketplacesOption: isSuccess ? const Some(Right(unit)) : const None(),
      ));
      emit(state.copyWith(fosAppointmentOnObserveFromMarketplacesOption: none()));
    });

//? #########################################################################

    on<GetNewAppointmentsFromPrestaEvent>((event, emit) async {
      final logger = Logger();
      bool isSuccess = true;
      emit(state.copyWith(isLoadingAppointmentsFromPrestaOnObserve: true, loadedAppointments: 0, numberOfToLoadAppointments: 0, loadingText: ''));

      List<ToLoadAppointmentsFromMarketplace>? toLoadAppointmentsFromMarketplace;
      final fosToLoadAppointments = await receiptRepository.getToLoadAppointmentsFromMarketplaces();
      fosToLoadAppointments.fold(
        (failure) {
          isSuccess = false;
          emit(state.copyWith(isLoadingAppointmentsFromPrestaOnObserve: false));
          return;
        },
        (success) {
          toLoadAppointmentsFromMarketplace = success;
          int number = 0;
          for (final element in success) {
            number += (element.lastIdToImport - element.nextIdToImport + 1);
          }
          emit(state.copyWith(numberOfToLoadAppointments: number));
        },
      );

      emit(state.copyWith(loadedAppointments: 0, loadingText: 'Lädt Bestellungen vom Marktplatz...'));

      List<LoadedOrderFromMarketplace> listOfLoadedOrderFromMarketplace = [];
      for (final toLoadAppointment in toLoadAppointmentsFromMarketplace!) {
        for (int i = toLoadAppointment.nextIdToImport; i < toLoadAppointment.lastIdToImport + 1; i++) {
          final toLoadOrderFromMarketplace = ToLoadAppointmentFromMarketplace(marketplace: toLoadAppointment.marketplace, orderId: i);
          final fosLoadedAppointmentFromMarketplace = await receiptRepository.loadAppointmentsFromMarketplace(toLoadOrderFromMarketplace);
          fosLoadedAppointmentFromMarketplace.fold(
            (failure) {
              logger.e(failure);
              isSuccess = false;
            },
            (loadedOrderFromMarketplace) {
              listOfLoadedOrderFromMarketplace.add(loadedOrderFromMarketplace);
              emit(state.copyWith(loadedAppointments: state.loadedAppointments + 1));
            },
          );
        }
      }

      emit(state.copyWith(loadedAppointments: 0, loadingText: 'Lädt Bestellungen zu Cezeri Commerce hoch...'));

      List<Receipt> listWithNewAppointments = List.from(state.listOfAllReceipts ?? []);
      for (final toUploadAppointment in listOfLoadedOrderFromMarketplace) {
        final fosLoadedAppointment = await receiptRepository.uploadLoadedAppointmentToFirestore(toUploadAppointment);
        fosLoadedAppointment.fold(
          (failure) {
            logger.e(failure);
            isSuccess = false;
          },
          (loadedAppointment) {
            listWithNewAppointments.add(loadedAppointment);
            emit(state.copyWith(loadedAppointments: state.loadedAppointments + 1));
          },
        );
      }

      // List<Receipt> listWithNewAppointments = List.from(state.listOfAllReceipts ?? []);
      // for (final toLoadAppointment in toLoadAppointmentsFromMarketplace!) {
      //   for (int i = toLoadAppointment.nextIdToImport; i < toLoadAppointment.lastIdToImport + 1; i++) {
      //     final fosLoadedAppointment = await receiptRepository.loadAppointmentFromMarketplaceAndUploadToFirestore(toLoadAppointment.marketplace, i);
      //     fosLoadedAppointment.fold(
      //       (failure) {
      //         logger.e(failure);
      //         isSuccess = false;
      //       },
      //       (loadedAppointment) {
      //         listWithNewAppointments.add(loadedAppointment);
      //         emit(state.copyWith(loadedAppointments: state.loadedAppointments + 1));
      //       },
      //     );
      //   }
      // }

      listWithNewAppointments.sort((a, b) => switch (listWithNewAppointments.first.receiptTyp) {
            ReceiptTyp.offer => b.offerId.compareTo(a.offerId),
            ReceiptTyp.appointment => b.appointmentId.compareTo(a.appointmentId),
            ReceiptTyp.deliveryNote => b.deliveryNoteId.compareTo(a.deliveryNoteId),
            ReceiptTyp.invoice || ReceiptTyp.credit => b.invoiceId.compareTo(a.invoiceId),
          });
      emit(state.copyWith(
        listOfAllReceipts: listWithNewAppointments,
        isExpanded: List<bool>.filled(listWithNewAppointments.length, false),
        firebaseFailure: null,
        isAnyFailure: false,
      ));

      add(OnSearchFieldSubmittedAppointmentsEvent());

      emit(state.copyWith(
        isLoadingAppointmentsFromPrestaOnObserve: false,
        fosAppointmentsOnObserveFromMarketplacesOption: isSuccess ? const Some(Right(unit)) : const None(),
      ));
      emit(state.copyWith(fosAppointmentsOnObserveFromMarketplacesOption: none()));
    });

//? #########################################################################

    on<CreateNewAppointmentManuallyEvent>((event, emit) async {
      emit(state.copyWith(isLoadingReceiptOnCreate: true));

      final failureOrSuccess = await receiptRepository.createReceiptManually(event.receipt);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (receipt) => emit(state.copyWith(firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingReceiptOnCreate: false,
        fosReceiptOnCreateOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosReceiptOnCreateOption: none()));
    });

//? #########################################################################

    on<UpdateAppointmentEvent>((event, emit) async {
      emit(state.copyWith(isLoadingReceiptOnUpdate: true));

      final newAppointment = event.appointment.copyWith(listOfReceiptProduct: event.newListOfReceiptProducts);

      final failureOrSuccess = await receiptRepository.updateReceipt(
        newAppointment,
        event.oldListOfReceiptProducts,
        event.newListOfReceiptProducts,
      );
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (unit) => emit(state.copyWith(receipt: event.appointment, firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingReceiptOnUpdate: false,
        fosReceiptOnUpdateOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosReceiptOnUpdateOption: none()));
    });

//? #########################################################################

    on<DeleteSelectedReceiptsEvent>((event, emit) async {
      emit(state.copyWith(isLoadingReceiptOnDelete: true));

      final failureOrSuccess = await receiptRepository.deleteListOfReceipts(event.selectedReceipts);
      failureOrSuccess.fold(
        (failure) => null,
        (unit) {
          List<Receipt> appointments = List.from(state.listOfFilteredReceipts!);
          for (final appointment in event.selectedReceipts) {
            appointments.removeWhere((e) => e.id == appointment.id);
          }
          emit(state.copyWith(
            listOfFilteredReceipts: appointments,
            isExpanded: List<bool>.filled(appointments.length, false),
            firebaseFailure: null,
            isAnyFailure: false,
          ));
        },
      );

      emit(state.copyWith(
        isLoadingReceiptOnDelete: false,
        fosReceiptOnDeleteOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosReceiptOnDeleteOption: none()));
    });

//? #########################################################################

    on<SetSearchFieldTextAppointmentsEvent>((event, emit) async {
      emit(state.copyWith(receiptSearchText: event.searchText));
    });

    on<OnSearchFieldSubmittedAppointmentsEvent>((event, emit) async {
      List<Receipt> listOfReceipts = [];
      if (state.listOfAllReceipts!.isNotEmpty) {
        listOfReceipts = switch (state.listOfAllReceipts!.first.receiptTyp) {
          ReceiptTyp.offer => switch (state.tabValue) {
              0 => state.listOfAllReceipts!.where((e) => e.offerStatus == OfferStatus.open).toList(),
              _ => state.listOfAllReceipts!,
            },
          ReceiptTyp.appointment => switch (state.tabValue) {
              0 => state.listOfAllReceipts!.where((e) => e.appointmentStatus != AppointmentStatus.completed).toList(),
              _ => state.listOfAllReceipts!,
            },
          ReceiptTyp.deliveryNote => switch (state.tabValue) {
              0 => state.listOfAllReceipts!.where((e) => e.paymentStatus != PaymentStatus.paid).toList(),
              _ => state.listOfAllReceipts!,
            },
          ReceiptTyp.invoice || ReceiptTyp.credit => switch (state.tabValue) {
              0 => state.listOfAllReceipts!.where((e) => e.paymentStatus != PaymentStatus.paid).toList(),
              _ => state.listOfAllReceipts!,
            },
        };
      }

      listOfReceipts = switch (state.receiptSearchText) {
        '' => listOfReceipts,
        (_) => listOfReceipts
            .where((element) =>
                element.offerNumberAsString.toLowerCase().contains(state.receiptSearchText.toLowerCase()) ||
                element.appointmentNumberAsString.toLowerCase().contains(state.receiptSearchText.toLowerCase()) ||
                element.deliveryNoteNumberAsString.toLowerCase().contains(state.receiptSearchText.toLowerCase()) ||
                element.invoiceNumberAsString.toLowerCase().contains(state.receiptSearchText.toLowerCase()) ||
                element.creditNumberAsString.toLowerCase().contains(state.receiptSearchText.toLowerCase()) ||
                element.receiptMarketplaceId.toString().toLowerCase().contains(state.receiptSearchText.toLowerCase()) ||
                element.receiptMarketplaceReference.toString().toLowerCase().contains(state.receiptSearchText.toLowerCase()) ||
                element.receiptCustomer.name.toString().toLowerCase().contains(state.receiptSearchText.toLowerCase()) ||
                element.receiptCustomer.id.toString().toLowerCase().contains(state.receiptSearchText.toLowerCase()))
            .toList()
      };
      emit(state.copyWith(listOfFilteredReceipts: listOfReceipts));
    });

//? #########################################################################

    on<OnGenerateFromOfferNewAppointmentEvent>((event, emit) async {
      emit(state.copyWith(isLoadingReceiptOnGenerate: true));

      final failureOrSuccess = await receiptRepository.generateFromListOfOffersNewAppointments(state.selectedReceipts);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (receipt) {
          emit(state.copyWith(selectedReceipts: [], firebaseFailure: null, isAnyFailure: false));
          add(GetReceiptsEvent(tabValue: state.tabValue, receiptTyp: state.receiptTyp));
        },
      );

      emit(state.copyWith(
        isLoadingReceiptOnGenerate: false,
        fosReceiptsOnGenerateOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosReceiptsOnGenerateOption: none()));
    });

//? #########################################################################

    on<OnGenerateFromAppointmentEvent>((event, emit) async {
      emit(state.copyWith(isLoadingReceiptOnGenerate: true));

      final failureOrSuccess = await receiptRepository.generateFromListOfAppointments(
        state.selectedReceipts,
        event.generateDeliveryNote,
        event.generateInvoice,
      );
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (receipt) {
          emit(state.copyWith(selectedReceipts: [], firebaseFailure: null, isAnyFailure: false));
          add(GetReceiptsEvent(tabValue: state.tabValue, receiptTyp: state.receiptTyp));
        },
      );

      emit(state.copyWith(
        isLoadingReceiptOnGenerate: false,
        fosReceiptsOnGenerateOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosReceiptsOnGenerateOption: none()));
    });

//? #########################################################################

    on<OnGenerateFromDeliveryNotesNewInvoiceEvent>((event, emit) async {
      emit(state.copyWith(isLoadingReceiptOnGenerate: true));

      final failureOrSuccess = await receiptRepository.generateFromListOfDeliveryNotesNewInvoice(state.selectedReceipts);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (receipt) {
          emit(state.copyWith(selectedReceipts: [], firebaseFailure: null, isAnyFailure: false));
          add(GetReceiptsEvent(tabValue: state.tabValue, receiptTyp: state.receiptTyp));
        },
      );

      emit(state.copyWith(
        isLoadingReceiptOnGenerate: false,
        fosReceiptOnGenerateOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosReceiptOnGenerateOption: none()));
    });

//? #########################################################################

    on<OnGenerateFromInvoiceNewCreditEvent>((event, emit) async {
      emit(state.copyWith(isLoadingReceiptOnGenerate: true));

      final failureOrSuccess = await receiptRepository.generateFromInvoiceNewCredit(state.selectedReceipts.first);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (receipt) {
          emit(state.copyWith(selectedReceipts: [], firebaseFailure: null, isAnyFailure: false));
          add(GetReceiptsEvent(tabValue: state.tabValue, receiptTyp: state.receiptTyp));
        },
      );

      emit(state.copyWith(
        isLoadingReceiptOnGenerate: false,
        fosReceiptOnGenerateOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosReceiptOnGenerateOption: none()));
    });

//? #########################################################################

    on<GetAllProductsEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductsOnObserve: true));

      final failureOrSuccess = await productRepository.getListOfProducts(true);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (listOfProducts) {
          listOfProducts.sort((a, b) => a.name.compareTo(b.name));
          emit(state.copyWith(listOfAllProducts: listOfProducts, firebaseFailure: null, isAnyFailure: false));
        },
      );

      emit(state.copyWith(
        isLoadingProductsOnObserve: false,
        fosProductsOnObserveOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosProductsOnObserveOption: none()));
    });

//? #########################################################################

    on<GetProductByEanEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductOnObserve: true));

      final failureOrSuccess = await productRepository.getProductByEan(event.ean);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (product) {
          emit(state.copyWith(product: product, firebaseFailure: null, isAnyFailure: false));
        },
      );

      emit(state.copyWith(
        isLoadingProductOnObserve: false,
        fosProductOnObserveOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosProductOnObserveOption: none()));
    });

//? #########################################################################

    on<OnSelectAllAppointmentsEvent>((event, emit) async {
      List<Receipt> appointments = [];
      bool isSelectedAll = false;
      if (event.isSelected) {
        isSelectedAll = true;
        appointments = List.from(state.listOfFilteredReceipts!);
      }
      emit(state.copyWith(isAllReceiptsSeledcted: isSelectedAll, selectedReceipts: appointments));
    });

//? #########################################################################

    on<OnAppointmentSelectedEvent>((event, emit) async {
      List<Receipt> appointments = List.from(state.selectedReceipts);
      if (appointments.any((e) => e.id == event.appointment.id)) {
        appointments.removeWhere((e) => e.id == event.appointment.id);
      } else {
        appointments.add(event.appointment);
      }
      emit(state.copyWith(
        isAllReceiptsSeledcted:
            state.isAllReceiptsSeledcted && appointments.length < state.selectedReceipts.length ? false : state.isAllReceiptsSeledcted,
        selectedReceipts: appointments,
      ));
    });

//? #########################################################################

    on<SetAppointmentIsExpandedEvent>((event, emit) async {
      List<bool> isExpanded = List.from(state.isExpanded);
      isExpanded[event.index] = !isExpanded[event.index];
      emit(state.copyWith(isExpanded: isExpanded));
    });

//? #########################################################################

    on<OnAppointmentMarketplaceChangedEvent>((event, emit) async {
      emit(state.copyWith(
        receipt: state.receipt!.copyWith(
          marketplaceId: event.marketplace.id,
          receiptMarketplace: ReceiptMarketplace.fromMarketplace(event.marketplace),
        ),
      ));
    });

//? #########################################################################

    on<OnAppointmentPaymentMethodChangedEvent>((event, emit) async {
      emit(state.copyWith(receipt: state.receipt!.copyWith(paymentMethod: event.paymentMethod)));
    });

//? #########################################################################

    on<OnAppointmentPaymentStatusChangedEvent>((event, emit) async {
      emit(state.copyWith(
        receipt: state.receipt!.copyWith(
          paymentStatus: switch (event.paymentStatus) {
            'Offen' => PaymentStatus.open,
            'Teilweise bezahlt' => PaymentStatus.partiallyPaid,
            'Komplett bezahlt' => PaymentStatus.paid,
            _ => PaymentStatus.open,
          },
        ),
      ));
    });

//? #########################################################################

    on<OnAppointmentCarrierChangedEvent>((event, emit) async {
      emit(state.copyWith(receipt: state.receipt!.copyWith(receiptCarrier: event.receiptCarrier)));
    });

//? #########################################################################

    on<OnAppointmentCarrierProductChangedEvent>((event, emit) async {
      emit(state.copyWith(
        receipt: state.receipt!.copyWith(
          receiptCarrier: state.receipt!.receiptCarrier.copyWith(
            carrierProduct: state.receipt!.receiptCarrier.carrierProduct.copyWith(
              productName: event.receiptCarrierProduct.productName,
              id: event.receiptCarrierProduct.id,
            ),
          ),
        ),
      ));
    });

//? #########################################################################

    on<OnEditAddressReceiptDetailEvent>((event, emit) async {
      if (event.address.addressType == AddressType.delivery) {
        print('OnEditAddressReceiptDetailEvent: AddressType.delivery');
        print(event.address);
        emit(state.copyWith(receipt: state.receipt!.copyWith(addressDelivery: event.address)));
      }

      if (event.address.addressType == AddressType.invoice) {
        print('OnEditAddressReceiptDetailEvent: AddressType.invoice');
        emit(state.copyWith(receipt: state.receipt!.copyWith(addressInvoice: event.address)));
      }
    });

//? #########################################################################

    on<SendEmailToCustomerReceiptEvent>((event, emit) async {
      await receiptRepository.sendEmails();
    });

//? #########################################################################

    on<CreateParcelLabelReceiptEvent>((event, emit) async {
      emit(state.copyWith(isLoadingParcelLabelOnCreate: true));

      final fos = await receiptRepository.createNewParcelForReceipt(state.receipt!);

      emit(state.copyWith(
        isLoadingParcelLabelOnCreate: false,
        fosParcelLabelOnCreate: optionOf(fos),
      ));
      emit(state.copyWith(fosParcelLabelOnCreate: none()));
    });

//? #########################################################################

//? #########################################################################
  }
}
