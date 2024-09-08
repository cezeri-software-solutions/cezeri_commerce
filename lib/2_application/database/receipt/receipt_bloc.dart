import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/3_domain/repositories/database/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../3_domain/entities/carrier/parcel_tracking.dart';
import '../../../3_domain/entities/customer/customer.dart';
import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/receipt/load_appointments_helper/to_load_appointments_from_marketplace.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/repositories/database/marketplace_repository.dart';
import '../../../3_domain/repositories/database/receipt_repository.dart';
import '../../../constants.dart';
import '../../../failures/abstract_failure.dart';

part 'receipt_event.dart';
part 'receipt_state.dart';

class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  final ReceiptRepository receiptRepository;
  final ProductRepository productRepository;
  final MarketplaceRepository marketplaceRepository;

  ReceiptBloc({
    required this.receiptRepository,
    required this.productRepository,
    required this.marketplaceRepository,
  }) : super(ReceiptState.initial()) {
    on<SetAppointmentStateToInitialEvent>(_onSetAppointmentStateToInitial);
    on<GetReceiptEvent>(_onGetReceipt);
    on<SetReceiptEvent>(_onSetAppointment);
    on<GetReceiptsEvent>(_onGetReceipts);
    on<GetReceiptsPerPageEvent>(_onGetReceiptsPerPage);
    on<GetNewAppointmentByIdFromPrestaEvent>(_onGetNewAppointmentByIdFromPresta);
    on<GetNewAppointmentsFromMarketplacesEvent>(_onGetNewAppointmentsFromMarketplaces);
    on<CreateNewReceiptManuallyEvent>(_onCreateNewReceiptManually);
    on<DeleteSelectedReceiptsEvent>(_onDeleteSelectedReceipts);
    on<OnSearchFieldSubmittedAppointmentsEvent>(_onOnSearchFieldSubmittedAppointments);
    on<OnSearchFieldClearedEvent>(_onSearchFieldCleared);
    on<OnGenerateFromOfferNewAppointmentEvent>(_onOnGenerateFromOfferNewAppointment);
    on<OnGenerateFromAppointmentEvent>(_onOnGenerateFromAppointment);
    on<OnGenerateFromDeliveryNotesNewInvoiceEvent>(_onOnGenerateFromDeliveryNotesNewInvoice);
    on<OnGenerateFromInvoiceNewCreditEvent>(_onOnGenerateFromInvoiceNewCredit);
    on<OnSelectAllAppointmentsEvent>(_onOnSelectAllAppointments);
    on<OnAppointmentSelectedEvent>(_onOnAppointmentSelected);
    on<SetAppointmentIsExpandedEvent>(_onSetAppointmentIsExpanded);
    on<ItemsPerPageChangedEvent>(_onItemsPerPageChanged);
  }
//? #########################################################################

  void _onSetAppointmentStateToInitial(SetAppointmentStateToInitialEvent event, Emitter<ReceiptState> emit) {
    emit(ReceiptState.initial());
  }

//? #########################################################################

  void _onGetReceipt(GetReceiptEvent event, Emitter<ReceiptState> emit) async {
    emit(state.copyWith(isLoadingReceiptOnObserve: true));

    final failureOrSuccess = await receiptRepository.getReceipt(event.appointment.id, event.appointment.receiptTyp);
    failureOrSuccess.fold(
      (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
      (loadedAppointment) => emit(state.copyWith(receipt: loadedAppointment, firebaseFailure: null, isAnyFailure: false)),
    );

    add(OnSearchFieldSubmittedAppointmentsEvent());

    emit(state.copyWith(
      isLoadingReceiptOnObserve: false,
      fosReceiptOnObserveOption: optionOf(failureOrSuccess),
    ));
    emit(state.copyWith(fosReceiptOnObserveOption: none()));
  }

//? #########################################################################

  void _onSetAppointment(SetReceiptEvent event, Emitter<ReceiptState> emit) async {
    emit(state.copyWith(receipt: event.appointment, isAnyFailure: false, firebaseFailure: null));
  }

//? #########################################################################

  void _onGetReceipts(GetReceiptsEvent event, Emitter<ReceiptState> emit) async {
    emit(state.copyWith(isLoadingReceiptsOnObserve: true));

    final failureOrSuccess = await receiptRepository.getListOfReceipts(event.tabValue, event.receiptTyp);
    failureOrSuccess.fold(
      (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
      (listOfAppointments) {
        listOfAppointments.sort((a, b) => switch (listOfAppointments.first.receiptTyp) {
              ReceiptType.offer => b.offerId.compareTo(a.offerId),
              ReceiptType.appointment => b.creationDate.compareTo(a.creationDate),
              ReceiptType.deliveryNote => b.deliveryNoteId.compareTo(a.deliveryNoteId),
              ReceiptType.invoice || ReceiptType.credit => b.invoiceId.compareTo(a.invoiceId),
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
  }

//? #########################################################################

  void _onGetReceiptsPerPage(GetReceiptsPerPageEvent event, Emitter<ReceiptState> emit) async {
    emit(state.copyWith(isLoadingReceiptsOnObserve: true));

    if (event.isFirstLoad) {
      final fosMarketplaces = await marketplaceRepository.getListOfMarketplaces();
      fosMarketplaces.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (marketplaces) => emit(state.copyWith(listOfMarketpaces: marketplaces, firebaseFailure: null, isAnyFailure: false)),
      );
    }

    if (event.calcCount) {
      final fosCount = await receiptRepository.getTotalNumberOfReceiptsBySearchText(
        receiptType: event.receiptType,
        tabIndex: event.tabValue,
        searchText: state.receiptSearchController.text,
      );
      fosCount.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (countNumber) => emit(state.copyWith(totalQuantity: countNumber, firebaseFailure: null, isAnyFailure: false)),
      );
    }

    final failureOrSuccess = await receiptRepository.getListOfReceiptsPerPageBySearchText(
      tabIndex: event.tabValue,
      receiptType: event.receiptType,
      searchText: state.receiptSearchController.text,
      currentPage: event.currentPage,
      itemsPerPage: state.perPageQuantity,
    );

    failureOrSuccess.fold(
      (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
      (listOfAppointments) {
        emit(state.copyWith(
          listOfAllReceipts: listOfAppointments,
          listOfFilteredReceipts: listOfAppointments,
          currentPage: event.currentPage,
          isExpanded: List<bool>.filled(listOfAppointments.length, false),
          firebaseFailure: null,
          isAnyFailure: false,
          tabValue: event.tabValue,
          receiptTyp: event.receiptType,
        ));

        add(OnSearchFieldSubmittedAppointmentsEvent());
      },
    );

    emit(state.copyWith(
      isLoadingReceiptsOnObserve: false,
      fosReceiptsOnObserveOption: optionOf(failureOrSuccess),
    ));
  }

//? #########################################################################

  void _onGetNewAppointmentByIdFromPresta(GetNewAppointmentByIdFromPrestaEvent event, Emitter<ReceiptState> emit) async {
    bool isSuccess = true;
    emit(state.copyWith(
      isLoadingAppointmentFromPrestaOnObserve: true,
      loadedAppointments: 1,
      numberOfToLoadAppointments: 1,
      loadingText: 'Bestellung wird geladen',
    ));

    List<LoadedOrderFromMarketplace> listOfLoadedOrderFromMarketplace = [];

    final toLoadOrderFromMarketplace = ToLoadAppointmentFromMarketplace(marketplace: event.marketplace, orderId: event.id);
    final fosLoadedAppointmentFromMarketplace = await receiptRepository.loadAppointmentsFromMarketplacePresta(toLoadOrderFromMarketplace);
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
      final fosLoadedAppointment = await receiptRepository.uploadLoadedAppointmentToDatabase(toUploadAppointment);
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
          ReceiptType.offer => b.offerId.compareTo(a.offerId),
          ReceiptType.appointment => b.appointmentId.compareTo(a.appointmentId),
          ReceiptType.deliveryNote => b.deliveryNoteId.compareTo(a.deliveryNoteId),
          ReceiptType.invoice || ReceiptType.credit => b.invoiceId.compareTo(a.invoiceId),
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
  }

//? #########################################################################

  void _onGetNewAppointmentsFromMarketplaces(GetNewAppointmentsFromMarketplacesEvent event, Emitter<ReceiptState> emit) async {
    List<AbstractFailure> failures = [];
    emit(state.copyWith(isLoadingAppointmentsFromPrestaOnObserve: true, loadedAppointments: 0, numberOfToLoadAppointments: 0, loadingText: ''));

    List<ToLoadAppointmentsFromMarketplace>? toLoadAppointmentsFromMarketplace;
    final fosToLoadAppointments = await receiptRepository.getToLoadAppointmentsFromMarketplaces();
    fosToLoadAppointments.fold(
      (failure) {
        failures.add(failure);
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

    emit(state.copyWith(loadedAppointments: 1, loadingText: 'Lädt Bestellungen vom Marktplatz...'));

    List<LoadedOrderFromMarketplace> listOfLoadedOrderFromMarketplace = [];
    for (final toLoadAppointment in toLoadAppointmentsFromMarketplace!) {
      switch (toLoadAppointment.marketplace.marketplaceType) {
        case MarketplaceType.prestashop:
          {
            for (int i = toLoadAppointment.nextIdToImport; i < toLoadAppointment.lastIdToImport + 1; i++) {
              final toLoadOrderFromMarketplace = ToLoadAppointmentFromMarketplace(marketplace: toLoadAppointment.marketplace, orderId: i);
              final fosLoadedAppointmentFromMarketplace = await receiptRepository.loadAppointmentsFromMarketplacePresta(toLoadOrderFromMarketplace);
              fosLoadedAppointmentFromMarketplace.fold(
                (failure) {
                  logger.e(failure);
                  failures.add(failure);
                },
                (loadedOrderFromMarketplace) {
                  listOfLoadedOrderFromMarketplace.add(loadedOrderFromMarketplace);
                  emit(state.copyWith(loadedAppointments: state.loadedAppointments + 1));
                },
              );
            }
          }
        case MarketplaceType.shopify:
          {
            final fosLoadedAppointmentFromShopify = await receiptRepository.loadAppointmentsFromMarketplaceShopify(toLoadAppointment);
            fosLoadedAppointmentFromShopify.fold(
              (failure) {
                logger.e(failure);
                failures.add(failure);
              },
              (loadedOrderFromMarketplace) {
                listOfLoadedOrderFromMarketplace.addAll(loadedOrderFromMarketplace);
                emit(state.copyWith(loadedAppointments: state.loadedAppointments + 1));
              },
            );
          }
        case MarketplaceType.shop:
          throw Exception('Aus einem Ladengeschäft können keine Bestellungen importiert werden.');
      }
    }

    emit(state.copyWith(loadedAppointments: 1, loadingText: 'Lädt Bestellungen zu Cezeri Commerce hoch...'));

    List<Receipt> listWithNewAppointments = List.from(state.listOfAllReceipts ?? []);
    for (final toUploadAppointment in listOfLoadedOrderFromMarketplace) {
      final fosLoadedAppointment = await receiptRepository.uploadLoadedAppointmentToDatabase(toUploadAppointment);
      fosLoadedAppointment.fold(
        (failure) {
          logger.e(failure);
          failures.add(failure);
        },
        (loadedAppointment) {
          listWithNewAppointments.add(loadedAppointment);
          emit(state.copyWith(loadedAppointments: state.loadedAppointments + 1));
        },
      );
    }

    listWithNewAppointments.sort((a, b) => switch (listWithNewAppointments.first.receiptTyp) {
          ReceiptType.offer => b.offerId.compareTo(a.offerId),
          ReceiptType.appointment => b.appointmentId.compareTo(a.appointmentId),
          ReceiptType.deliveryNote => b.deliveryNoteId.compareTo(a.deliveryNoteId),
          ReceiptType.invoice || ReceiptType.credit => b.invoiceId.compareTo(a.invoiceId),
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
      fosAppointmentsOnObserveFromMarketplacesOption: failures.isEmpty ? const Some(Right(unit)) : Some(Left(failures)),
    ));
    emit(state.copyWith(fosAppointmentsOnObserveFromMarketplacesOption: none()));
  }

//? #########################################################################

  void _onCreateNewReceiptManually(CreateNewReceiptManuallyEvent event, Emitter<ReceiptState> emit) async {
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
  }

//? #########################################################################

  void _onDeleteSelectedReceipts(DeleteSelectedReceiptsEvent event, Emitter<ReceiptState> emit) async {
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
  }

//? #########################################################################

  void _onOnSearchFieldSubmittedAppointments(OnSearchFieldSubmittedAppointmentsEvent event, Emitter<ReceiptState> emit) {
    // List<Receipt> listOfReceipts = [];
    // if (state.listOfAllReceipts!.isNotEmpty) {
    //   listOfReceipts = switch (state.listOfAllReceipts!.first.receiptTyp) {
    //     ReceiptType.offer => switch (state.tabValue) {
    //         0 => state.listOfAllReceipts!.where((e) => e.offerStatus == OfferStatus.open).toList(),
    //         _ => state.listOfAllReceipts!,
    //       },
    //     ReceiptType.appointment => switch (state.tabValue) {
    //         0 => state.listOfAllReceipts!.where((e) => e.appointmentStatus != AppointmentStatus.completed).toList(),
    //         _ => state.listOfAllReceipts!,
    //       },
    //     ReceiptType.deliveryNote => switch (state.tabValue) {
    //         0 => state.listOfAllReceipts!.where((e) => e.paymentStatus != PaymentStatus.paid).toList(),
    //         _ => state.listOfAllReceipts!,
    //       },
    //     ReceiptType.invoice || ReceiptType.credit => switch (state.tabValue) {
    //         0 => state.listOfAllReceipts!.where((e) => e.paymentStatus != PaymentStatus.paid).toList(),
    //         _ => state.listOfAllReceipts!,
    //       },
    //   };
    // }

    // listOfReceipts = switch (state.receiptSearchText) {
    //   '' => listOfReceipts,
    //   (_) => listOfReceipts
    //       .where((e) =>
    //           e.offerNumberAsString.toLowerCase().contains(state.receiptSearchText.toLowerCase()) ||
    //           e.appointmentNumberAsString.toLowerCase().contains(state.receiptSearchText.toLowerCase()) ||
    //           e.deliveryNoteNumberAsString.toLowerCase().contains(state.receiptSearchText.toLowerCase()) ||
    //           e.invoiceNumberAsString.toLowerCase().contains(state.receiptSearchText.toLowerCase()) ||
    //           e.creditNumberAsString.toLowerCase().contains(state.receiptSearchText.toLowerCase()) ||
    //           e.receiptMarketplaceId.toString().toLowerCase().contains(state.receiptSearchText.toLowerCase()) ||
    //           e.receiptMarketplaceReference.toString().toLowerCase().contains(state.receiptSearchText.toLowerCase()) ||
    //           (e.receiptCustomer.company ?? '').toString().toLowerCase().contains(state.receiptSearchText.toLowerCase()) ||
    //           e.receiptCustomer.name.toString().toLowerCase().contains(state.receiptSearchText.toLowerCase()) ||
    //           e.receiptCustomer.id.toString().toLowerCase().contains(state.receiptSearchText.toLowerCase()) ||
    //           e.addressInvoice.companyName.toString().toLowerCase().contains(state.receiptSearchText.toLowerCase()) ||
    //           e.addressInvoice.name.toString().toLowerCase().contains(state.receiptSearchText.toLowerCase()) ||
    //           e.addressDelivery.companyName.toString().toLowerCase().contains(state.receiptSearchText.toLowerCase()) ||
    //           e.addressDelivery.name.toString().toLowerCase().contains(state.receiptSearchText.toLowerCase()) ||
    //           e.listOfReceiptProduct.any((p) => p.name.toLowerCase().contains(state.receiptSearchText.toLowerCase())) ||
    //           e.listOfReceiptProduct.any((p) => p.articleNumber.toLowerCase().contains(state.receiptSearchText.toLowerCase())))
    //       .toList()
    // };
    // emit(state.copyWith(listOfFilteredReceipts: listOfReceipts));
  }

//? #########################################################################

  void _onSearchFieldCleared(OnSearchFieldClearedEvent event, Emitter<ReceiptState> emit) async {
    emit(state.copyWith(receiptSearchController: SearchController()));
    add(GetReceiptsPerPageEvent(isFirstLoad: false, calcCount: true, currentPage: 1, tabValue: state.tabValue, receiptType: state.receiptType));
  }

//? #########################################################################

  void _onOnGenerateFromOfferNewAppointment(OnGenerateFromOfferNewAppointmentEvent event, Emitter<ReceiptState> emit) async {
    emit(state.copyWith(isLoadingReceiptOnGenerate: true));

    final failureOrSuccess = await receiptRepository.generateFromListOfOffersNewAppointments(state.selectedReceipts);
    failureOrSuccess.fold(
      (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
      (receipt) {
        emit(state.copyWith(selectedReceipts: [], firebaseFailure: null, isAnyFailure: false));
        add(GetReceiptsEvent(tabValue: state.tabValue, receiptTyp: state.receiptType));
      },
    );

    emit(state.copyWith(
      isLoadingReceiptOnGenerate: false,
      fosReceiptsOnGenerateOption: optionOf(failureOrSuccess),
    ));
    emit(state.copyWith(fosReceiptsOnGenerateOption: none()));
  }

//? #########################################################################

  void _onOnGenerateFromAppointment(OnGenerateFromAppointmentEvent event, Emitter<ReceiptState> emit) async {
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
        add(GetReceiptsEvent(tabValue: state.tabValue, receiptTyp: state.receiptType));
      },
    );

    emit(state.copyWith(
      isLoadingReceiptOnGenerate: false,
      fosReceiptsOnGenerateOption: optionOf(failureOrSuccess),
    ));
    emit(state.copyWith(fosReceiptsOnGenerateOption: none()));
  }

//? #########################################################################

  void _onOnGenerateFromDeliveryNotesNewInvoice(OnGenerateFromDeliveryNotesNewInvoiceEvent event, Emitter<ReceiptState> emit) async {
    emit(state.copyWith(isLoadingReceiptOnGenerate: true));

    final failureOrSuccess = await receiptRepository.generateFromListOfDeliveryNotesNewInvoice(state.selectedReceipts);
    failureOrSuccess.fold(
      (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
      (receipt) {
        emit(state.copyWith(selectedReceipts: [], firebaseFailure: null, isAnyFailure: false));
        add(GetReceiptsEvent(tabValue: state.tabValue, receiptTyp: state.receiptType));
      },
    );

    emit(state.copyWith(
      isLoadingReceiptOnGenerate: false,
      fosReceiptOnGenerateOption: optionOf(failureOrSuccess),
    ));
    emit(state.copyWith(fosReceiptOnGenerateOption: none()));
  }

//? #########################################################################

  void _onOnGenerateFromInvoiceNewCredit(OnGenerateFromInvoiceNewCreditEvent event, Emitter<ReceiptState> emit) async {
    emit(state.copyWith(isLoadingReceiptOnGenerate: true));

    final failureOrSuccess = await receiptRepository.generateFromInvoiceNewCredit(state.selectedReceipts.first, event.setQuantity);
    failureOrSuccess.fold(
      (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
      (receipt) {
        emit(state.copyWith(selectedReceipts: [], firebaseFailure: null, isAnyFailure: false));
        add(GetReceiptsEvent(tabValue: state.tabValue, receiptTyp: state.receiptType));
      },
    );

    emit(state.copyWith(
      isLoadingReceiptOnGenerate: false,
      fosReceiptOnGenerateOption: optionOf(failureOrSuccess),
    ));
    emit(state.copyWith(fosReceiptOnGenerateOption: none()));
  }

//? #########################################################################

  void _onOnSelectAllAppointments(OnSelectAllAppointmentsEvent event, Emitter<ReceiptState> emit) {
    List<Receipt> appointments = [];
    bool isSelectedAll = false;
    if (event.isSelected) {
      isSelectedAll = true;
      appointments = List.from(state.listOfFilteredReceipts!);
    }
    emit(state.copyWith(isAllReceiptsSeledcted: isSelectedAll, selectedReceipts: appointments));
  }

//? #########################################################################

  void _onOnAppointmentSelected(OnAppointmentSelectedEvent event, Emitter<ReceiptState> emit) {
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
  }

//? #########################################################################

  void _onSetAppointmentIsExpanded(SetAppointmentIsExpandedEvent event, Emitter<ReceiptState> emit) {
    List<bool> isExpanded = List.from(state.isExpanded);
    isExpanded[event.index] = !isExpanded[event.index];
    emit(state.copyWith(isExpanded: isExpanded));
  }

//? #########################################################################

  void _onItemsPerPageChanged(ItemsPerPageChangedEvent event, Emitter<ReceiptState> emit) {
    emit(state.copyWith(perPageQuantity: event.value));
    add(GetReceiptsPerPageEvent(isFirstLoad: false, calcCount: false, currentPage: 1, tabValue: state.tabValue, receiptType: state.receiptType));
  }

//? #########################################################################
}
