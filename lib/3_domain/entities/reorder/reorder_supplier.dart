import 'package:json_annotation/json_annotation.dart';

part 'reorder_supplier.g.dart';

@JsonSerializable()
class ReorderSupplier {
  final String id;
  final int supplierNumber;
  final String company;
  final String name;

  const ReorderSupplier({required this.id, required this.supplierNumber, required this.company, required this.name});

  factory ReorderSupplier.fromJson(Map<String, dynamic> json) => _$ReorderSupplierFromJson(json);
  Map<String, dynamic> toJson() => _$ReorderSupplierToJson(this);

  factory ReorderSupplier.empty() {
    return const ReorderSupplier(
      id: '',
      supplierNumber: 0,
      company: '',
      name: '',
    );
  }

  ReorderSupplier copyWith({
    String? id,
    int? supplierNumber,
    String? company,
    String? name,
  }) {
    return ReorderSupplier(
      id: id ?? this.id,
      supplierNumber: supplierNumber ?? this.supplierNumber,
      company: company ?? this.company,
      name: name ?? this.name,
    );
  }

  @override
  String toString() {
    return 'ReorderSupplier(id: $id, supplierNumber: $supplierNumber, company: $company, name: $name)';
  }
}
