part of 'appointment_bloc.dart';

@immutable
abstract class AppointmentEvent {}

class SetAppointmentStateToInitialEvent extends AppointmentEvent {}

class GetAppointmentEvent extends AppointmentEvent {
  final Receipt appointment;

  GetAppointmentEvent({required this.appointment});
}

class GetCustomerInAppointmentEvent extends AppointmentEvent {
  final String customerId;

  GetCustomerInAppointmentEvent({required this.customerId});
}

class GetAllAppointmentsEvent extends AppointmentEvent {}

class GetOpenAppointmentsEvent extends AppointmentEvent {}

class GetNewAppointmentsFromPrestaEvent extends AppointmentEvent {}

class UpdateAppointmentEvent extends AppointmentEvent {
  final Receipt appointment;
  final List<ReceiptProduct> oldListOfReceiptProducts;
  final List<ReceiptProduct> newListOfReceiptProducts;

  UpdateAppointmentEvent({required this.appointment, required this.oldListOfReceiptProducts, required this.newListOfReceiptProducts});
}

class DeleteSelectedAppointmentsEvent extends AppointmentEvent {
  final List<Receipt> selectedAppointments;

  DeleteSelectedAppointmentsEvent({required this.selectedAppointments});
}

class SetSearchFieldTextAppointmentsEvent extends AppointmentEvent {
  final String searchText;

  SetSearchFieldTextAppointmentsEvent({required this.searchText});
}

class OnSearchFieldSubmittedAppointmentsEvent extends AppointmentEvent {}

//* --- helper --- *//
class SetAppointmentIsExpandedEvent extends AppointmentEvent {
  final int index;

  SetAppointmentIsExpandedEvent({required this.index});
}

class OnSelectAllAppointmentsEvent extends AppointmentEvent {
  final bool isSelected;

  OnSelectAllAppointmentsEvent({required this.isSelected});
}

class OnAppointmentSelectedEvent extends AppointmentEvent {
  final Receipt appointment;

  OnAppointmentSelectedEvent({required this.appointment});
}
