import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../3_domain/entities/receipt/receipt.dart';
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

    on<GetAllAppointmentsEvent>((event, emit) async {
      emit(state.copyWith(isLoadingAppointmentsOnObserve: true));

      final failureOrSuccess = await receiptRepository.getListOfAppointments();
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (listOfAppointments) {
          listOfAppointments.sort((a, b) => b.appointmentId.compareTo(a.appointmentId));
          emit(state.copyWith(
            listOfAllAppointments: listOfAppointments,
            isExpanded: List<bool>.filled(listOfAppointments.length, false),
            firebaseFailure: null,
            isAnyFailure: false,
          ));
        },
      );

      add(OnSearchFieldSubmittedAppointmentsEvent());

      emit(state.copyWith(
        isLoadingAppointmentsOnObserve: false,
        fosAppointmentsOnObserveOption: optionOf(failureOrSuccess),
      ));
    });

//? #########################################################################

    on<GetNewAppointmentsFromPrestaEvent>((event, emit) async {
      emit(state.copyWith(isLoadingAppointmentsFromPrestaOnObserve: true));

      final failureOrSuccess = await receiptRepository.loadNewAppointments();
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (listOfAppointments) {
          List<Receipt> listWithNewAppointments = List.from(state.listOfAllAppointments ?? []);
          listWithNewAppointments.addAll(listOfAppointments);
          listWithNewAppointments.sort((a, b) => b.appointmentId.compareTo(a.appointmentId));
          emit(state.copyWith(
            listOfAllAppointments: listWithNewAppointments,
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

    on<DeleteSelectedAppointmentsEvent>((event, emit) async {
      emit(state.copyWith(isLoadingAppointmentOnDelete: true));

      final failureOrSuccess = await receiptRepository.deleteListOfAppointments(event.selectedAppointments.map((e) => e.receiptId).toList());
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (unit) {
          List<Receipt> appointments = List.from(state.listOfFilteredAppointments!);
          for (final appointment in event.selectedAppointments) {
            appointments.removeWhere((e) => e.receiptId == appointment.receiptId);
          }
          emit(state.copyWith(
            listOfFilteredAppointments: appointments,
            isExpanded: List<bool>.filled(appointments.length, false),
            firebaseFailure: null,
            isAnyFailure: false,
          ));
        },
      );

      emit(state.copyWith(
        isLoadingAppointmentOnDelete: false,
        fosAppointmentOnDeleteOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosAppointmentOnDeleteOption: none()));
    });

//? #########################################################################

    on<SetSearchFieldTextAppointmentsEvent>((event, emit) async {
      emit(state.copyWith(appointmentSearchText: event.searchText));
    });

    on<OnSearchFieldSubmittedAppointmentsEvent>((event, emit) async {
      final listOfAppointments = switch (state.appointmentSearchText) {
        '' => state.listOfAllAppointments,
        (_) => state.listOfAllAppointments!
            .where((element) =>
                element.appointmentNumberAsString.toLowerCase().contains(state.appointmentSearchText.toLowerCase()) ||
                element.receiptMarketplaceId.toString().toLowerCase().contains(state.appointmentSearchText.toLowerCase()) ||
                element.receiptMarketplaceReference.toString().toLowerCase().contains(state.appointmentSearchText.toLowerCase()) ||
                element.customer.name.toString().toLowerCase().contains(state.appointmentSearchText.toLowerCase()))
            .toList()
      };
      emit(state.copyWith(listOfFilteredAppointments: listOfAppointments));
    });

//? #########################################################################

    on<OnAppointmentSelectedEvent>((event, emit) async {
      List<Receipt> appointments = List.from(state.selectedAppointments);
      if (appointments.any((e) => e.receiptId == event.appointment.receiptId)) {
        appointments.removeWhere((e) => e.receiptId == event.appointment.receiptId);
      } else {
        appointments.add(event.appointment);
      }
      emit(state.copyWith(selectedAppointments: appointments));
    });

//? #########################################################################

    on<SetAppointmentIsExpandedEvent>((event, emit) async {
      List<bool> isExpanded = List.from(state.isExpanded);
      isExpanded[event.index] = !isExpanded[event.index];
      emit(state.copyWith(isExpanded: isExpanded));
    });

//? #########################################################################
  }
}
