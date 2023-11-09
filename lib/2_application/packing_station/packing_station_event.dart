part of 'packing_station_bloc.dart';

abstract class PackingStationEvent {}

class SetPackingStationStateToInitialEvent extends PackingStationEvent {}

class PackgingStationGetAppointmentEvent extends PackingStationEvent {
  final Receipt appointment;

  PackgingStationGetAppointmentEvent({required this.appointment});
}

class PackingStationSetAppointFromOriginalEvent extends PackingStationEvent {}

class PackgingStationGetAppointmentsEvent extends PackingStationEvent {}

class PackingsStationUpdateAppointmentEvent extends PackingStationEvent {
  final Receipt appointment;

  PackingsStationUpdateAppointmentEvent({required this.appointment});
}

class PackingStationFilterAppointmentsEvent extends PackingStationEvent {}

class SetPackingStationFilterAppointmentsEvent extends PackingStationEvent {
  final PackingStationFilter packingStationFilter;

  SetPackingStationFilterAppointmentsEvent({required this.packingStationFilter});
}

class PackingsStationUpdateAppointmentsEvent extends PackingStationEvent {
  final List<Receipt> appointments;

  PackingsStationUpdateAppointmentsEvent({required this.appointments});
}

class SetPackingStationListOfAllAppointmentsEvent extends PackingStationEvent {
  final List<Receipt> allAppointments;

  SetPackingStationListOfAllAppointmentsEvent({required this.allAppointments});
}

class PackingsStationOnAppointmentSelectedEvent extends PackingStationEvent {
  final Receipt appointment;

  PackingsStationOnAppointmentSelectedEvent({required this.appointment});
}

class PackingsStationOnAllAppointmentsSelectedEvent extends PackingStationEvent {
  final bool isSelected;

  PackingsStationOnAllAppointmentsSelectedEvent({required this.isSelected});
}

class PackingsStationGetProductsFromFirestoreEvent extends PackingStationEvent {
  final List<String> productIds;

  PackingsStationGetProductsFromFirestoreEvent({required this.productIds});
}

class PackingStationOnPickingQuantityChanged extends PackingStationEvent {
  final int index;
  final bool isSubtract;
  final bool pickCompletely;

  PackingStationOnPickingQuantityChanged({required this.index, required this.isSubtract, required this.pickCompletely});
}

class PackingStationOnPickAllEvent extends PackingStationEvent {}

class PackingStationClearControllerEvent extends PackingStationEvent {}

class PackingStationIsPartiallyEnabledEvent extends PackingStationEvent {}

class PackingStationGenerateFromAppointmentEvent extends PackingStationEvent {
  final bool generateInvoice;

  PackingStationGenerateFromAppointmentEvent({required this.generateInvoice});
}
