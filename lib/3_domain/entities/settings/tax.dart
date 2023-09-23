import 'package:json_annotation/json_annotation.dart';

part 'tax.g.dart';

@JsonSerializable()
class Tax {
  final String taxId;
  final String taxName;
  final int taxRate;
  final String country;
  final bool isDefault;

  const Tax({
    required this.taxId,
    required this.taxName,
    required this.taxRate,
    required this.country,
    required this.isDefault,
  });

  factory Tax.fromJson(Map<String, dynamic> json) => _$TaxFromJson(json);

  Map<String, dynamic> toJson() => _$TaxToJson(this);

  Tax copyWith({
    String? taxId,
    String? taxName,
    int? taxRate,
    String? country,
    bool? isDefault,
  }) {
    return Tax(
      taxId: taxId ?? this.taxId,
      taxName: taxName ?? this.taxName,
      taxRate: taxRate ?? this.taxRate,
      country: country ?? this.country,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  String toString() {
    return 'Tax(taxId: $taxId, taxName: $taxName, taxRate: $taxRate, country: $country, isDefault: $isDefault)';
  }
}
