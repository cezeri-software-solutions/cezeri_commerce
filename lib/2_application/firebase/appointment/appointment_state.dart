// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'appointment_bloc.dart';

@immutable
class AppointmentState {
  final Receipt? appointment;
  final List<Receipt>? listOfAppointment;
  final FirebaseFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingAppointmentOnObserve;
  final bool isLoadingAppointmentsOnObserve;
  final bool isLoadingAppointmentsFromPrestaOnObserve;
  final bool isLoadingAppointmentOnCreate;
  final bool isLoadingAppointmentOnUpdate;
  final bool isLoadingAppointmentOnDelete;
  final Option<Either<FirebaseFailure, Receipt>> fosAppointmentOnObserveOption;
  final Option<Either<FirebaseFailure, List<Receipt>>> fosAppointmentsOnObserveOption;
  final Option<Either<FirebaseFailure, List<Receipt>>> fosAppointmentsOnObserveFromPrestaOption;
  final Option<Either<FirebaseFailure, Receipt>> fosAppointmentOnCreateOption;
  final Option<Either<FirebaseFailure, Receipt>> fosAppointmentOnUpdateOption;
  final Option<Either<FirebaseFailure, Unit>> fosAppointmentOnDeleteOption;

  const AppointmentState({
    this.appointment,
    required this.listOfAppointment,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingAppointmentOnObserve,
    required this.isLoadingAppointmentsOnObserve,
    required this.isLoadingAppointmentsFromPrestaOnObserve,
    required this.isLoadingAppointmentOnCreate,
    required this.isLoadingAppointmentOnUpdate,
    required this.isLoadingAppointmentOnDelete,
    required this.fosAppointmentOnObserveOption,
    required this.fosAppointmentsOnObserveOption,
    required this.fosAppointmentsOnObserveFromPrestaOption,
    required this.fosAppointmentOnCreateOption,
    required this.fosAppointmentOnUpdateOption,
    required this.fosAppointmentOnDeleteOption,
  });

  factory AppointmentState.initial() => AppointmentState(
        appointment: null,
        listOfAppointment: null,
        firebaseFailure: null,
        isAnyFailure: false,
        isLoadingAppointmentOnObserve: false,
        isLoadingAppointmentsOnObserve: true,
        isLoadingAppointmentsFromPrestaOnObserve: false,
        isLoadingAppointmentOnCreate: false,
        isLoadingAppointmentOnUpdate: false,
        isLoadingAppointmentOnDelete: false,
        fosAppointmentOnObserveOption: none(),
        fosAppointmentsOnObserveOption: none(),
        fosAppointmentsOnObserveFromPrestaOption: none(),
        fosAppointmentOnCreateOption: none(),
        fosAppointmentOnUpdateOption: none(),
        fosAppointmentOnDeleteOption: none(),
      );

  AppointmentState copyWith({
    Receipt? appointment,
    List<Receipt>? listOfAppointment,
    FirebaseFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingAppointmentOnObserve,
    bool? isLoadingAppointmentsOnObserve,
    bool? isLoadingAppointmentsFromPrestaOnObserve,
    bool? isLoadingAppointmentOnCreate,
    bool? isLoadingAppointmentOnUpdate,
    bool? isLoadingAppointmentOnDelete,
    Option<Either<FirebaseFailure, Receipt>>? fosAppointmentOnObserveOption,
    Option<Either<FirebaseFailure, List<Receipt>>>? fosAppointmentsOnObserveOption,
    Option<Either<FirebaseFailure, List<Receipt>>>? fosAppointmentsOnObserveFromPrestaOption,
    Option<Either<FirebaseFailure, Receipt>>? fosAppointmentOnCreateOption,
    Option<Either<FirebaseFailure, Receipt>>? fosAppointmentOnUpdateOption,
    Option<Either<FirebaseFailure, Unit>>? fosAppointmentOnDeleteOption,
  }) {
    return AppointmentState(
      appointment: appointment ?? this.appointment,
      listOfAppointment: listOfAppointment ?? this.listOfAppointment,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingAppointmentOnObserve: isLoadingAppointmentOnObserve ?? this.isLoadingAppointmentOnObserve,
      isLoadingAppointmentsOnObserve: isLoadingAppointmentsOnObserve ?? this.isLoadingAppointmentsOnObserve,
      isLoadingAppointmentsFromPrestaOnObserve: isLoadingAppointmentsFromPrestaOnObserve ?? this.isLoadingAppointmentsFromPrestaOnObserve,
      isLoadingAppointmentOnCreate: isLoadingAppointmentOnCreate ?? this.isLoadingAppointmentOnCreate,
      isLoadingAppointmentOnUpdate: isLoadingAppointmentOnUpdate ?? this.isLoadingAppointmentOnUpdate,
      isLoadingAppointmentOnDelete: isLoadingAppointmentOnDelete ?? this.isLoadingAppointmentOnDelete,
      fosAppointmentOnObserveOption: fosAppointmentOnObserveOption ?? this.fosAppointmentOnObserveOption,
      fosAppointmentsOnObserveOption: fosAppointmentsOnObserveOption ?? this.fosAppointmentsOnObserveOption,
      fosAppointmentsOnObserveFromPrestaOption: fosAppointmentsOnObserveFromPrestaOption ?? this.fosAppointmentsOnObserveFromPrestaOption,
      fosAppointmentOnCreateOption: fosAppointmentOnCreateOption ?? this.fosAppointmentOnCreateOption,
      fosAppointmentOnUpdateOption: fosAppointmentOnUpdateOption ?? this.fosAppointmentOnUpdateOption,
      fosAppointmentOnDeleteOption: fosAppointmentOnDeleteOption ?? this.fosAppointmentOnDeleteOption,
    );
  }
}
