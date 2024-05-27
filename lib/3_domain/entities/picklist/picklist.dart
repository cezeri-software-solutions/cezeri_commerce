import 'package:json_annotation/json_annotation.dart';

import '../receipt/receipt.dart';
import 'picklist_appointment.dart';
import 'picklist_product.dart';

part 'picklist.g.dart';

@JsonSerializable(explicitToJson: true)
class Picklist {
  final String id;
  final List<PicklistAppointment> listOfPicklistAppointments;
  final List<PicklistProduct> listOfPicklistProducts; // Für die Pickliste
  final DateTime creationDate;
  final int creationDateInt;
  final DateTime lastEditingDate;

  Picklist({
    required this.id,
    required this.listOfPicklistAppointments,
    required this.listOfPicklistProducts,
    required this.creationDate,
    required this.creationDateInt,
    required this.lastEditingDate,
  });

  factory Picklist.fromJson(Map<String, dynamic> json) => _$PicklistFromJson(json);

  Map<String, dynamic> toJson() => _$PicklistToJson(this);

  factory Picklist.empty() {
    final now = DateTime.now();
    return Picklist(
      id: '',
      listOfPicklistAppointments: [],
      listOfPicklistProducts: [],
      creationDate: now,
      creationDateInt: 0,
      lastEditingDate: now,
    );
  }

  factory Picklist.fromListOfAppointments(List<Receipt> listOfAppointments) {
    final now = DateTime.now();
    List<PicklistProduct> listOfPicklistProducts = [];
    final listOfPicklistAppointments = listOfAppointments.map((e) => PicklistAppointment.fromReceipt(e)).toList();
    for (final appointment in listOfAppointments) {
      for (final product in appointment.listOfReceiptProduct) {
        final picklistProduct = PicklistProduct.fromReceiptProduct(product);
        if (listOfPicklistProducts.any((e) => e == picklistProduct)) {
          final index = listOfPicklistProducts.indexWhere((e) => e == picklistProduct);
          listOfPicklistProducts[index] =
              listOfPicklistProducts[index].copyWith(quantity: listOfPicklistProducts[index].quantity + picklistProduct.quantity);
        } else {
          listOfPicklistProducts.add(picklistProduct);
        }
      }
    }
    return Picklist(
      id: '',
      listOfPicklistAppointments: listOfPicklistAppointments,
      listOfPicklistProducts: listOfPicklistProducts,
      creationDate: now,
      creationDateInt: now.millisecondsSinceEpoch,
      lastEditingDate: now,
    );
  }

  Picklist copyWith({
    String? id,
    List<PicklistAppointment>? listOfPicklistAppointments,
    List<PicklistProduct>? listOfPicklistProducts,
    DateTime? creationDate,
    int? creationDateInt,
    DateTime? lastEditingDate,
  }) {
    return Picklist(
      id: id ?? this.id,
      listOfPicklistAppointments: listOfPicklistAppointments ?? this.listOfPicklistAppointments,
      listOfPicklistProducts: listOfPicklistProducts ?? this.listOfPicklistProducts,
      creationDate: creationDate ?? this.creationDate,
      creationDateInt: creationDateInt ?? this.creationDateInt,
      lastEditingDate: lastEditingDate ?? this.lastEditingDate,
    );
  }

  @override
  String toString() {
    return 'Picklist(id: $id, listOfPicklistAppointments: $listOfPicklistAppointments, listOfPicklistProducts: $listOfPicklistProducts, creationDate: $creationDate, creationDateInt: $creationDateInt, lastEditingDate: $lastEditingDate)';
  }
}
