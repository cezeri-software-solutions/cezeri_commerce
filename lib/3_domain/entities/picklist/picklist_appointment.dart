import 'package:json_annotation/json_annotation.dart';

import '../receipt/receipt.dart';
import '../receipt/receipt_customer.dart';
import 'picklist_product.dart';

part 'picklist_appointment.g.dart';

@JsonSerializable(explicitToJson: true)
class PicklistAppointment {
  final String id;
  final String receiptId;
  final int appointmentId;
  final String appointmentNumberAsString;
  final String customerId;
  final ReceiptCustomer receiptCustomer;
  final AppointmentStatus appointmentStatus;
  final PaymentStatus paymentStatus;
  final List<PicklistProduct> listOfPicklistProducts; // Für die Packliste

  const PicklistAppointment({
    required this.id,
    required this.receiptId,
    required this.appointmentId,
    required this.appointmentNumberAsString,
    required this.customerId,
    required this.receiptCustomer,
    required this.appointmentStatus,
    required this.paymentStatus,
    required this.listOfPicklistProducts,
  });

  factory PicklistAppointment.fromJson(Map<String, dynamic> json) => _$PicklistAppointmentFromJson(json);

  Map<String, dynamic> toJson() => _$PicklistAppointmentToJson(this);

  factory PicklistAppointment.empty() {
    return PicklistAppointment(
      id: '',
      receiptId: '',
      appointmentId: 0,
      appointmentNumberAsString: '',
      customerId: '',
      receiptCustomer: ReceiptCustomer.empty(),
      appointmentStatus: AppointmentStatus.open,
      paymentStatus: PaymentStatus.open,
      listOfPicklistProducts: const [],
    );
  }

  factory PicklistAppointment.fromReceipt(Receipt receipt) {
    return PicklistAppointment(
      id: receipt.id,
      receiptId: receipt.receiptId,
      appointmentId: receipt.appointmentId,
      appointmentNumberAsString: receipt.appointmentNumberAsString,
      customerId: receipt.customerId,
      receiptCustomer: receipt.receiptCustomer,
      appointmentStatus: receipt.appointmentStatus,
      paymentStatus: receipt.paymentStatus,
      listOfPicklistProducts: receipt.listOfReceiptProduct.map((e) => PicklistProduct.fromReceiptProduct(e)).toList(),
    );
  }

  PicklistAppointment copyWith({
    String? id,
    String? receiptId,
    int? appointmentId,
    String? appointmentNumberAsString,
    String? customerId,
    ReceiptCustomer? receiptCustomer,
    AppointmentStatus? appointmentStatus,
    PaymentStatus? paymentStatus,
    List<PicklistProduct>? listOfPicklistProducts,
  }) {
    return PicklistAppointment(
      id: id ?? this.id,
      receiptId: receiptId ?? this.receiptId,
      appointmentId: appointmentId ?? this.appointmentId,
      appointmentNumberAsString: appointmentNumberAsString ?? this.appointmentNumberAsString,
      customerId: customerId ?? this.customerId,
      receiptCustomer: receiptCustomer ?? this.receiptCustomer,
      appointmentStatus: appointmentStatus ?? this.appointmentStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      listOfPicklistProducts: listOfPicklistProducts ?? this.listOfPicklistProducts,
    );
  }

  @override
  String toString() {
    return 'PicklistAppointment(id: $id, receiptId: $receiptId, appointmentId: $appointmentId, appointmentNumberAsString: $appointmentNumberAsString, customerId: $customerId, receiptCustomer: $receiptCustomer, appointmentStatus: $appointmentStatus, paymentStatus: $paymentStatus, listOfPicklistProducts: $listOfPicklistProducts)';
  }
}
