import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'specific_price.g.dart';

enum ReductionType { fixed, percent }

enum FixedReductionType { amount, percent }

@JsonSerializable(explicitToJson: true)
class SpecificPrice extends Equatable {
  final String id;
  final String title;
  @JsonKey(name: 'from_quantity')
  final int fromQuantity;
  final double value;
  @JsonKey(name: 'reduction_type')
  final ReductionType reductionType;
  @JsonKey(name: 'fixed_reduction_type')
  final FixedReductionType fixedReductionType;
  @JsonKey(name: 'start_date')
  final DateTime startDate;
  @JsonKey(name: 'end_date')
  final DateTime endDate;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const SpecificPrice({
    required this.id,
    required this.title,
    required this.fromQuantity,
    required this.value,
    required this.reductionType,
    required this.fixedReductionType,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SpecificPrice.fromJson(Map<String, dynamic> json) => _$SpecificPriceFromJson(json);
  Map<String, dynamic> toJson() => _$SpecificPriceToJson(this);

  factory SpecificPrice.empty() {
    return SpecificPrice(
      id: '',
      title: '',
      fromQuantity: 1,
      value: 0.0,
      reductionType: ReductionType.fixed,
      fixedReductionType: FixedReductionType.amount,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  SpecificPrice copyWith({
    String? id,
    String? title,
    int? fromQuantity,
    double? value,
    ReductionType? reductionType,
    FixedReductionType? fixedReductionType,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SpecificPrice(
      id: id ?? this.id,
      title: title ?? this.title,
      fromQuantity: fromQuantity ?? this.fromQuantity,
      value: value ?? this.value,
      reductionType: reductionType ?? this.reductionType,
      fixedReductionType: fixedReductionType ?? this.fixedReductionType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        fromQuantity,
        value,
        reductionType,
        fixedReductionType,
        startDate,
        endDate,
        createdAt,
        updatedAt,
      ];

  @override
  bool get stringify => true;
}
