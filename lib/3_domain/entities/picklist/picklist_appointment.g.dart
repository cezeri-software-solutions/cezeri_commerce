// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picklist_appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PicklistAppointment _$PicklistAppointmentFromJson(Map<String, dynamic> json) =>
    PicklistAppointment(
      id: json['id'] as String,
      receiptId: json['receiptId'] as String,
      appointmentId: (json['appointmentId'] as num).toInt(),
      appointmentNumberAsString: json['appointmentNumberAsString'] as String,
      customerId: json['customerId'] as String,
      receiptCustomer: ReceiptCustomer.fromJson(
          json['receiptCustomer'] as Map<String, dynamic>),
      appointmentStatus:
          $enumDecode(_$AppointmentStatusEnumMap, json['appointmentStatus']),
      paymentStatus: $enumDecode(_$PaymentStatusEnumMap, json['paymentStatus']),
      listOfPicklistProducts: (json['listOfPicklistProducts'] as List<dynamic>)
          .map((e) => PicklistProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PicklistAppointmentToJson(
        PicklistAppointment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'receiptId': instance.receiptId,
      'appointmentId': instance.appointmentId,
      'appointmentNumberAsString': instance.appointmentNumberAsString,
      'customerId': instance.customerId,
      'receiptCustomer': instance.receiptCustomer.toJson(),
      'appointmentStatus':
          _$AppointmentStatusEnumMap[instance.appointmentStatus]!,
      'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
      'listOfPicklistProducts':
          instance.listOfPicklistProducts.map((e) => e.toJson()).toList(),
    };

const _$AppointmentStatusEnumMap = {
  AppointmentStatus.open: 'open',
  AppointmentStatus.partiallyCompleted: 'partiallyCompleted',
  AppointmentStatus.completed: 'completed',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.open: 'open',
  PaymentStatus.partiallyPaid: 'partiallyPaid',
  PaymentStatus.paid: 'paid',
};
