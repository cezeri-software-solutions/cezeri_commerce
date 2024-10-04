import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'specific_price.g.dart';

enum ReductionType { fixed, percent }

enum FixedReductionType { net, gross }

typedef SpecificPriceMarketplace = ({String marketplaceId, String? specificPriceId});

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
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'is_discount_internal')
  final bool isDiscountInternal;
  @JsonKey(name: 'start_date')
  final DateTime startDate;
  @JsonKey(name: 'end_date')
  final DateTime? endDate;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'discounted_price_net')
  final double discountedPriceNet;
  @JsonKey(name: 'discounted_price_gross')
  final double discountedPriceGross;
  @JsonKey(name: 'marketplace_specific_price')
  final List<SpecificPriceMarketplace> listOfSpecificPriceMarketplaces;

  const SpecificPrice({
    required this.id,
    required this.title,
    required this.fromQuantity,
    required this.value,
    required this.reductionType,
    required this.fixedReductionType,
    required this.isActive,
    required this.isDiscountInternal,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.discountedPriceNet,
    required this.discountedPriceGross,
    required this.listOfSpecificPriceMarketplaces,
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
      fixedReductionType: FixedReductionType.net,
      isActive: true,
      isDiscountInternal: false,
      startDate: DateTime.now(),
      endDate: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      discountedPriceNet: 0.0,
      discountedPriceGross: 0.0,
      listOfSpecificPriceMarketplaces: const [],
    );
  }

  SpecificPrice copyWith({
    String? id,
    String? title,
    int? fromQuantity,
    double? value,
    ReductionType? reductionType,
    FixedReductionType? fixedReductionType,
    bool? isActive,
    bool? isDiscountInternal,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? discountedPriceNet,
    double? discountedPriceGross,
    List<SpecificPriceMarketplace>? listOfSpecificPriceMarketplaces,
  }) {
    return SpecificPrice(
      id: id ?? this.id,
      title: title ?? this.title,
      fromQuantity: fromQuantity ?? this.fromQuantity,
      value: value ?? this.value,
      reductionType: reductionType ?? this.reductionType,
      fixedReductionType: fixedReductionType ?? this.fixedReductionType,
      isActive: isActive ?? this.isActive,
      isDiscountInternal: isDiscountInternal ?? this.isDiscountInternal,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      discountedPriceNet: discountedPriceNet ?? this.discountedPriceNet,
      discountedPriceGross: discountedPriceGross ?? this.discountedPriceGross,
      listOfSpecificPriceMarketplaces: listOfSpecificPriceMarketplaces ?? this.listOfSpecificPriceMarketplaces,
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
        isActive,
        isDiscountInternal,
        startDate,
        endDate,
        createdAt,
        updatedAt,
        discountedPriceNet,
        discountedPriceGross,
        listOfSpecificPriceMarketplaces,
      ];

  @override
  bool get stringify => true;
}
