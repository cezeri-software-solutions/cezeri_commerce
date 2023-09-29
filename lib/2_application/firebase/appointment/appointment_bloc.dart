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
            listOfAppointment: listOfAppointments,
            isExpanded: List<bool>.filled(listOfAppointments.length, false),
            firebaseFailure: null,
            isAnyFailure: false,
          ));
        },
      );

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
          List<Receipt> listWithNewAppointments = List.from(state.listOfAppointment ?? []);
          listWithNewAppointments.addAll(listOfAppointments);
          listWithNewAppointments.sort((a, b) => b.appointmentId.compareTo(a.appointmentId));
          emit(state.copyWith(
            listOfAppointment: listWithNewAppointments,
            isExpanded: List<bool>.filled(listWithNewAppointments.length, false),
            firebaseFailure: null,
            isAnyFailure: false,
          ));
        },
      );

      emit(state.copyWith(
        isLoadingAppointmentsFromPrestaOnObserve: false,
        fosAppointmentsOnObserveFromPrestaOption: optionOf(failureOrSuccess),
      ));
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
