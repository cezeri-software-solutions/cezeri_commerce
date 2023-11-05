import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../3_domain/entities/carrier/carrier_product.dart';
import '../../../3_domain/entities/customer/customer.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/entities/receipt/receipt_carrier.dart';
import '../../../3_domain/entities/receipt/receipt_product.dart';
import '../../../3_domain/entities/settings/payment_method.dart';
import '../../../3_domain/repositories/firebase/receipt_respository.dart';
import '../../../core/firebase_failures.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final ReceiptRepository receiptRepository;

  AppointmentBloc({required this.receiptRepository}) : super(AppointmentState.initial()) {
//? #########################################################################

    on<SetAppointmentStateToInitialEvent>((event, emit) {
      emit(AppointmentState.initial());
    });

//? #########################################################################

    on<GetAppointmentEvent>((event, emit) async {
      emit(state.copyWith(isLoadingReceiptOnObserve: true));

      final failureOrSuccess = await receiptRepository.getAppointment(event.appointment);
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
      emit(state.copyWith(receipt: event.appointment));
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
        },
      );

      add(OnSearchFieldSubmittedAppointmentsEvent());

      emit(state.copyWith(
        isLoadingReceiptsOnObserve: false,
        fosReceiptsOnObserveOption: optionOf(failureOrSuccess),
      ));
    });

//? #########################################################################

    on<GetNewAppointmentsFromPrestaEvent>((event, emit) async {
      emit(state.copyWith(isLoadingAppointmentsFromPrestaOnObserve: true));

      final failureOrSuccess = await receiptRepository.loadNewAppointments();
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (listOfAppointments) {
          List<Receipt> listWithNewAppointments = List.from(state.listOfAllReceipts ?? []);
          listWithNewAppointments.addAll(listOfAppointments);
          listWithNewAppointments.sort((a, b) => switch (listOfAppointments.first.receiptTyp) {
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
        },
      );

      add(OnSearchFieldSubmittedAppointmentsEvent());

      emit(state.copyWith(
        isLoadingAppointmentsFromPrestaOnObserve: false,
        fosAppointmentsOnObserveFromPrestaOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosAppointmentsOnObserveFromPrestaOption: none()));
    });

//? #########################################################################

    on<CreateNewAppointmentManuallyEvent>((event, emit) async {
      emit(state.copyWith(isLoadingReceiptOnCreate: true));

      final failureOrSuccess = await receiptRepository.createAppointmentManually(event.receipt);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (receipt) => emit(state.copyWith(firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingReceiptOnCreate: false,
        fosReceiptOnCreateOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosReceiptOnUpdateOption: none()));
    });

//? #########################################################################

    on<UpdateAppointmentEvent>((event, emit) async {
      emit(state.copyWith(isLoadingReceiptOnUpdate: true));

      final newAppointment = event.appointment.copyWith(listOfReceiptProduct: event.newListOfReceiptProducts);

      final failureOrSuccess = await receiptRepository.updateAppointment(
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
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (unit) {
          List<Receipt> appointments = List.from(state.listOfFilteredReceipts!);
          for (final appointment in event.selectedReceipts) {
            appointments.removeWhere((e) => e.receiptId == appointment.receiptId);
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
      List<Receipt> listOfReceipts = switch (state.listOfAllReceipts!.first.receiptTyp) {
        ReceiptTyp.offer => switch (state.tabValue) {
            0 => state.listOfAllReceipts!.where((e) => e.offerStatus == OfferStatus.open).toList(),
            _ => state.listOfAllReceipts!,
          },
        ReceiptTyp.appointment => switch (state.tabValue) {
            0 => state.listOfAllReceipts!.where((e) => e.receiptStatus == ReceiptStatus.open).toList(),
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

    on<OnGenerateFromAppointmentEvent>((event, emit) async {
      emit(state.copyWith(isLoadingReceiptOnGenerate: true));

      final failureOrSuccess = await receiptRepository.generateFromAppointment(
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
        fosReceiptOnGenerateOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosReceiptOnGenerateOption: none()));
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
      if (appointments.any((e) => e.receiptId == event.appointment.receiptId)) {
        appointments.removeWhere((e) => e.receiptId == event.appointment.receiptId);
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
      emit(state.copyWith(receipt: state.receipt!.copyWith(marketplaceId: event.marketplaceId)));
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
            ),
          ),
        ),
      ));
    });

//? #########################################################################
  }
}
