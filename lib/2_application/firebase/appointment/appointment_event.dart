part of 'appointment_bloc.dart';

@immutable
abstract class AppointmentEvent {}

class SetAppointmentStateToInitialEvent extends AppointmentEvent {}

class GetAllAppointmentsEvent extends AppointmentEvent {}

class GetNewAppointmentsFromPrestaEvent extends AppointmentEvent {}

//* --- helper --- *//
class SetAppointmentIsExpandedEvent extends AppointmentEvent {
  final int index;

  SetAppointmentIsExpandedEvent({required this.index});
}
